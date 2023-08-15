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
  int numberOfTicket = 1;

  Future<void> getAllEvents(keyword) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getAll(keyword);

    _events = response;
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

    notifyListeners();
  }
}

class FormDataProvider extends ChangeNotifier {
  FormData _formData = FormData(
    artistName: '',
    eventName: '',
    section: '',
    row: '',
    seat: 1,
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
