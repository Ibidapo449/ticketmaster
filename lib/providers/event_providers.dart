import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/model/event_model.dart';
import 'package:ticketmaster/services/event_services.dart';

class EventProvider extends ChangeNotifier {
  final _service = EventService();
  bool isLoading = false;
  List<Event> _events = [];
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
    } else if (_events.isEmpty) {
      final response = await _service.getAll(keyword);
      _events = response;
    } else if (_events.isEmpty) {
      error = true;
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
}
