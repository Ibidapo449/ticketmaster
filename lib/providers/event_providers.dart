import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/State/EventState.dart';
import 'package:ticketmaster/model/event_model.dart';
import 'package:ticketmaster/services/event_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

class EventProvider extends ChangeNotifier {
  EventProvider() {
    _loadVisibleContainerIndex(); // Load when the provider is created
  }

  final _service = EventService();
  int visibleContainerIndex = 1;
  bool isLoading = false;
  List<Event> _events = [];
  bool fiveMinutesElapsed = false;
  EventResult eventResult = EventResult(Eventstate.isLoading, []);
  bool isSwitched2 = false;
  String countryOn = '';

  EventResult eventResultConcert = EventResult(Eventstate.isLoading, []);
  EventResult eventResultSport = EventResult(Eventstate.isLoading, []);
  EventResult eventResultComedy = EventResult(Eventstate.isLoading, []);
  EventResult eventResultFamily = EventResult(Eventstate.isLoading, []);

  List<Event> get events => _events;
  String date = '';

  String eventName = '';
  String artistName = '';
  String time = '';
  String location = '';
  String image = '';
  String ticketType = '';
  String level = '';
  String section = '';
  bool error = false;
  int numberOfTicket = 1;
  int token = 1;
  int datalength = 0;

  bool _loaded = false;

  bool get loaded => _loaded;

  void updateLoaded(bool value) {
    _loaded = value;
    notifyListeners();
  }

  void setLength(int length) {
    // Update the length of events
  }

  void startTimer() {
    fiveMinutesElapsed = true;
    notifyListeners();
  }

  void getlength1(len) {
    // datalength = 0;

    datalength = len;
    notifyListeners();
  }

  void addform() {
    datalength += 1;
    notifyListeners();
  }

  Future<void> _loadVisibleContainerIndex() async {
    final prefs = await SharedPreferences.getInstance();
    visibleContainerIndex = prefs.getInt('visibleContainerIndex') ?? 1;
    notifyListeners();
  }

  Future<void> _saveVisibleContainerIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('visibleContainerIndex', visibleContainerIndex);
  }

  void changeTicketInfo() {
    visibleContainerIndex = visibleContainerIndex % 5 + 1;
    _saveVisibleContainerIndex();
    notifyListeners();
  }

  Future<void> getAllEvents(keyword, artistname) async {
    error = false;
    isLoading = true;
    String joinboth = keyword + ' ' + artistName;
    // print(artistname);
    // print(joinboth);
    final response = await _service.getAll(joinboth);

    _events = response;

    if (_events.isEmpty) {
      final response = await _service.getAll(artistname);
      _events = response;

      if (_events.isEmpty) {
        final response = await _service.getAll(keyword);
        _events = response;
        if (_events.isEmpty) {
          error = true;
        }
      }
    }

    isLoading = false;
    loadSavedData();
    notifyListeners();
  }

  Future<void> getMajorEvents() async {
    eventResult = EventResult(Eventstate.isLoading, []);
    notifyListeners();
    final response = await _service.getEvent();

    eventResult = response;

    notifyListeners();
  }

  Future<void> getMajorEventsFamily() async {
    eventResultFamily = EventResult(Eventstate.isLoading, []);
    notifyListeners();
    final response = await _service.getEventFamily();

    eventResultFamily = response;

    notifyListeners();
  }

  Future<void> getMajorEventsConcert() async {
    eventResultConcert = EventResult(Eventstate.isLoading, []);
    notifyListeners();
    final response = await _service.getEventConcert();

    eventResultConcert = response;

    notifyListeners();
  }

  Future<void> getMajorEventsSport() async {
    eventResultSport = EventResult(Eventstate.isLoading, []);
    notifyListeners();
    final response = await _service.getEventSport();

    eventResultSport = response;

    notifyListeners();
  }

  Future<void> getMajorEventsComedy() async {
    eventResultComedy = EventResult(Eventstate.isLoading, []);
    notifyListeners();
    final response = await _service.getEventTypeComedy();

    eventResultComedy = response;

    notifyListeners();
  }

  void getSwitch() async {
    bool switchVal = true;

    final pref = await SharedPreferences.getInstance();

    switchVal = pref.getBool('LazyLoad') ?? true;
    print(switchVal);

    isSwitched2 = switchVal;
    notifyListeners();
  }

  void getCountry() async {
    String switchVal = '';

    final pref = await SharedPreferences.getInstance();

    switchVal = pref.getString('CountryState') ?? 'Atlanta, GA';
    print(switchVal);

    countryOn = switchVal;
    notifyListeners();
  }

  Future<void> loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    date = prefs.getString('date') ?? 'N/A';
    eventName = prefs.getString('eventName') ?? 'N/A';
    artistName = prefs.getString('artistName') ?? 'N/A';
    time = prefs.getString('time') ?? 'N/A';
    location = prefs.getString('location') ?? 'N/A';
    image = prefs.getString('image') ?? '';
    ticketType = prefs.getString('ticketType') ?? 'N/A';
    level = prefs.getString('level') ?? 'N/A';
    section = prefs.getString('section') ?? 'N/A';
    numberOfTicket = prefs.getInt('numberOfTicket') ?? 1;
    token = prefs.getInt('token') ?? 0;

    notifyListeners();
  }
}

class FormDataProvider extends ChangeNotifier {
  File? image;
  String es = '';
  bool error = false;
  String imageurl = '';
  bool uploadimageerror = false;
  FormData _formData = FormData(
      artistName: '',
      eventName: '',
      section: '',
      row: '',
      seat: '1',
      date: '',
      location: '',
      time: '',
      ticketType: '',
      level: '',
      numberOfTicket: 1,
      imageUrl: '');

  FormData get formData => _formData;

  void updateFormData(FormData newFormData) {
    _formData = newFormData;
    notifyListeners();
  }

  Future<void> pickimage() async {
    try {
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (result == null) {
        return;
      }

      final ImageTemporary = File(result.path);

      image = ImageTemporary;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: result.path,
        aspectRatioPresets: <CropAspectRatioPreset>[
          CropAspectRatioPreset.ratio16x9
        ],
        maxWidth: 1024,
        maxHeight: 576,
        compressQuality: 100,
      );

      if (croppedFile != null) {
        image = File(croppedFile.path);
      }
    } catch (e) {
      error = true;
      es = e.toString();
    }
    notifyListeners();
  }

  Future<void> downloadAndUploadImage(String imageUrl) async {
    try {
      // Get the temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName = imageUrl.split('/').last;
      final String filePath = '${tempDir.path}/$fileName';

      // Download the image
      final http.Response response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Save the file locally
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('Image downloaded to: $filePath');

        // Upload to Cloudinary (Assuming you have a function for this)
        // final String cloudinaryUrl = await uploadToCloudinary(file);
        // print('Uploaded Image URL: $cloudinaryUrl');
        uploadbook();
        image = file;
      } else {
        print('Failed to download image. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading or uploading image: $e');
      rethrow;
    }
    notifyListeners();
  }

  void downloadImage() async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(
          "https://encrypted-tbn1.gstatic.com/licensed-image?q=tbn:ANd9GcQiuHN2I6aB5HAq6TSJMEeYpwRc54t9h2fc-JhJpF6OUTUK9VB9E2zHWG3tMJzelVZMLIpM6oW9yEIyHkE");
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
    }
  }

// Your existing Cloudinary upload function

  Future<void> uploadbook() async {
    uploadimageerror = false;
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/drvnpclui/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'image_preset_ticket'
        ..files.add(await http.MultipartFile.fromPath('file', image!.path));
      final response = await request.send();
      print(response.statusCode);

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);

        final url = jsonMap['url'];
        imageurl = url;
        print(imageurl);
      } else {
        uploadimageerror = true;
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  void resetpair() {
    imageurl = '';
  }

  void deleteimage() {
    image = null;

    notifyListeners();
  }

  void addimage(url) {
    imageurl = url;
    print(imageurl);
    notifyListeners();
  }
}
