import 'package:ticketmaster/model/allEventModel.dart';

class EventResult {
  final Eventstate state;
  final List<EventModel> event;

  EventResult(this.state, this.event);
}
enum Eventstate { isLoading, isError, isData, isEmpty }