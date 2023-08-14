// To parse this JSON data, do
//
//     final eventget = eventgetFromJson(jsonString);

import 'dart:convert';

Eventget eventgetFromJson(String str) => Eventget.fromJson(json.decode(str));

class Eventget {
  EventgetEmbedded? embedded;

  Eventget({
    this.embedded,
  });

  factory Eventget.fromJson(Map<String, dynamic> json) => Eventget(
        embedded: EventgetEmbedded.fromJson(json["_embedded"]),
      );
}

class EventgetEmbedded {
  List<Event>? events;

  EventgetEmbedded({
    this.events,
  });

  factory EventgetEmbedded.fromJson(Map<String, dynamic> json) =>
      EventgetEmbedded(
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
      );
}

class Event {
  String name;

  String id;
  bool test;
  String url;

  List<Image> images;

  String? info;
  String? pleaseNote;

  Event({
    required this.name,
    required this.id,
    required this.test,
    required this.url,
    required this.images,
    this.info,
    this.pleaseNote,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        name: json["name"],
        id: json["id"],
        test: json["test"],
        url: json["url"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        info: json["info"],
        pleaseNote: json["pleaseNote"],
      );
}

class Image {
  String url;
  int width;
  int height;
  bool fallback;

  Image({
    required this.url,
    required this.width,
    required this.height,
    required this.fallback,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        url: json["url"],
        width: json["width"],
        height: json["height"],
        fallback: json["fallback"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
        "fallback": fallback,
      };
}

class FormData {
  String artistName;
  String eventName;
  String section;
  String row;
  String seat;
  String date;
  String location;
  String time;
  String ticketType;
  String level;
  String numberOfTicket;
  // String email;

  FormData({
    required this.artistName,
    required this.eventName,
    required this.section,
    required this.row,
    required this.seat,
    required this.date,
    required this.location,
    required this.time,
    required this.ticketType,
    required this.level,
    required this.numberOfTicket,

    // required this.email
  });
}
