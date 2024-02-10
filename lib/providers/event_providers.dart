import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/model/event_model.dart';
import 'package:ticketmaster/services/event_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class EventProvider extends ChangeNotifier {
  final _service = EventService();
  bool isLoading = false;
  List<Event> _events = [];
  List<Event> _eventss = [];
  List<Event> _eventsss = [];
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

  void getlength1(len) {
    // datalength = 0;

    datalength = len;
    notifyListeners();
  }

  void addform() {
    datalength += 1;
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
  );

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

  Future<void> uploadbook() async {
    uploadimageerror = false;

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dlsavisdq/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'image_preset_hSmart'
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
  }

  void resetpair() {
    imageurl = '';
  }

  void deleteimage() {
    image = null;

    notifyListeners();
  }
}
