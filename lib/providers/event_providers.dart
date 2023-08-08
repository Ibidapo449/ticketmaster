import 'package:flutter/material.dart';
import 'package:ticketmaster/model/event_model.dart';
import 'package:ticketmaster/services/event_services.dart';

class EventProvider extends ChangeNotifier {
  final _service = EventService();
  bool isLoading = false;
  List<Event> _events = [];
  List<Event> get events => _events;

  Future<void> getAllEvents() async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getAll();

    _events = response;
    isLoading = false;
    notifyListeners();
  }
}