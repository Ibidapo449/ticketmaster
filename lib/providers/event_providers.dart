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
  String time = '';
  String location = '';
  String image = '';

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
    time = prefs.getString('eventName') ?? 'N/A';
    location = prefs.getString('location') ?? 'N/A';
    image = prefs.getString('image') ?? '';
    print(image);
    notifyListeners();
  }
}

class FormDataProvider extends ChangeNotifier {
  FormData _formData = FormData(
    artistName: '',
    eventName: '',
    section: '',
    row: '',
    seat: '',
    date: '',
    location: '',
    time: '',
  );

  FormData get formData => _formData;

  void updateFormData(FormData newFormData) {
    _formData = newFormData;
    notifyListeners();
  }
}
