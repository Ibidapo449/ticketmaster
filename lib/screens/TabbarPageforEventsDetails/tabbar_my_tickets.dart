import 'package:flutter/material.dart';
import 'package:ticketmaster/screens/event_details_screen.dart';

import '../../model/EventInfo.dart' show EventInfo;

class TabbarMyTickets extends StatefulWidget {
  final String artistName;
  final String eventName;
  final String section;
  final String row;
  final String seat;
  final String date;
  final String location;
  final String time;
  final String image;
  final String ticketType;
  final String level;
  final int number_of_ticket;
  final double opacity1;
  final double opacity2;
  const TabbarMyTickets(
      {super.key,
      required this.artistName,
      required this.eventName,
      required this.section,
      required this.row,
      required this.seat,
      required this.date,
      required this.location,
      required this.time,
      required this.image,
      required this.ticketType,
      required this.level,
      required this.number_of_ticket,
      required this.opacity1,
      required this.opacity2});

  @override
  State<TabbarMyTickets> createState() => _PastState();
}

class _PastState extends State<TabbarMyTickets> {
  @override
  Widget build(BuildContext context) {
    return EventDetails(
      opacity1: widget.opacity1,
      opacity2: widget.opacity2,
      event: EventInfo(
          artistName: widget.artistName,
          eventName: widget.eventName,
          section: widget.section,
          row: widget.row,
          seat: widget.seat,
          date: widget.date,
          location: widget.location,
          time: widget.time,
          imageUrl: widget.image,
          ticketType: widget.ticketType,
          level: widget.level,
          ticketCount: widget.number_of_ticket),
    );
  }
}
