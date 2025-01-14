import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ticketmaster/State/EventState.dart';
import 'package:ticketmaster/model/allEventModel.dart';

import '../model/event_model.dart';
import 'package:http/http.dart' as http;

class EventService {
  List<EventModel> allevent = [];
  bool loading = true;
  bool error = false;
  Future<List<Event>> getAll(keyword) async {
    String url =
        "https://app.ticketmaster.com/discovery/v2/events.json?classificationName=music&keyword=$keyword&apikey=fJaxE14X0bWaFZMnXW1A3GGDAHUttspN";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    List<Event> event = [];
    if (response.statusCode == 200) {
      final decodeddata = jsonDecode(response.body);
      if (decodeddata['page']['totalPages'] >= 1) {
        final decodedevent = eventgetFromJson(response.body);
        event = decodedevent.embedded!.events ?? [];
      } else {
        event = [];
      }
    }
    return event;
  }

  Future<EventResult> getEvent() async {
    EventResult event = EventResult(Eventstate.isLoading, []);
    try {
      String url =
          "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&classificationName=music&apikey=fJaxE14X0bWaFZMnXW1A3GGDAHUttspN";
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      // List<Event> event = [];

      if (response.statusCode == 200) {
        final convertedres = jsonDecode(response.body);
        final decodeddata =
            AllEventEmbedded.fromJson(convertedres['_embedded']);
        allevent = decodeddata.events ?? [];
        var groupedEvents = allevent.fold<Map<String, List<EventModel>>>(
          {},
          (map, event) {
            var venueName = event.embedded?.venues?.first.name;
            if (venueName != null) {
              map.putIfAbsent(venueName, () => []).add(event);
            }
            return map;
          },
        );

        var seenUrls = <String>{};
        print(groupedEvents);
        print(groupedEvents.entries.where((entry) => entry.value.length > 1));
        var uniqueVenueEvents = groupedEvents.entries
            .where((entry) =>
                entry.value.length >
                1) // Only include venues with a single event
            .expand((entry) => entry.value)
            .where((event) {
          // Check if the image URL with ratio "16_9" has been seen
          var imageUrl = event.images
              ?.firstWhere((element) => element.ratio == "16_9",
                  orElse: () => ImageView())
              .url;

          // Only include this event if the URL is unique or first occurrence
          if (imageUrl != null && seenUrls.add(imageUrl)) {
            return true;
          } else {
            return false; // Skip if we've already seen this URL
          }
        }).toList();

        event = EventResult(Eventstate.isData, uniqueVenueEvents);
        for (var a in uniqueVenueEvents) {
          print(
            a.images?.where((element) => element.ratio == "16_9").first.url,
          );
        }
      } else {
        event = EventResult(Eventstate.isError, []);
      }
    } catch (e) {
      print(e);
      event = EventResult(Eventstate.isError, []);
    }

    return event;
    // return event;
  }

  Future<EventResult> getEventType() async {
    EventResult event = EventResult(Eventstate.isLoading, []);
    try {
      String url =
          "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&classificationName=music&apikey=fJaxE14X0bWaFZMnXW1A3GGDAHUttspN";
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      // List<Event> event = [];

      if (response.statusCode == 200) {
        final convertedres = jsonDecode(response.body);
        final decodeddata =
            AllEventEmbedded.fromJson(convertedres['_embedded']);
        allevent = decodeddata.events?.take(1).toList() ?? [];

        event = EventResult(Eventstate.isData, allevent);
      } else {
        event = EventResult(Eventstate.isError, []);
      }
    } catch (e) {
      print(e);
      event = EventResult(Eventstate.isError, []);
    }
    return event;
    // return event;
  }

  Future<EventResult> getEventConcert() async {
    EventResult event = EventResult(Eventstate.isLoading, []);
    try {
      String url =
          "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&classificationName=Concert&apikey=fJaxE14X0bWaFZMnXW1A3GGDAHUttspN";
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      // List<Event> event = [];

      if (response.statusCode == 200) {
        final convertedres = jsonDecode(response.body);
        final decodeddata =
            AllEventEmbedded.fromJson(convertedres['_embedded']);
        allevent = decodeddata.events?.take(1).toList() ?? [];

        event = EventResult(Eventstate.isData, allevent);
      } else {
        event = EventResult(Eventstate.isError, []);
      }
    } catch (e) {
      print(e);
      event = EventResult(Eventstate.isError, []);
    }
    return event;
    // return event;
  }

  Future<EventResult> getEventSport() async {
    EventResult event = EventResult(Eventstate.isLoading, []);
    try {
      String url =
          "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&classificationName=Sport&apikey=fJaxE14X0bWaFZMnXW1A3GGDAHUttspN";
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      // List<Event> event = [];

      if (response.statusCode == 200) {
        final convertedres = jsonDecode(response.body);
        final decodeddata =
            AllEventEmbedded.fromJson(convertedres['_embedded']);
        allevent = decodeddata.events?.take(1).toList() ?? [];

        event = EventResult(Eventstate.isData, allevent);
      } else {
        event = EventResult(Eventstate.isError, []);
      }
    } catch (e) {
      print(e);
      event = EventResult(Eventstate.isError, []);
    }
    return event;
    // return event;
  }

  Future<EventResult> getEventFamily() async {
    EventResult event = EventResult(Eventstate.isLoading, []);

    try {
      String url =
          "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&classificationName=Family&apikey=fJaxE14X0bWaFZMnXW1A3GGDAHUttspN";
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      // List<Event> event = [];

      if (response.statusCode == 200) {
        final convertedres = jsonDecode(response.body);
        final decodeddata =
            AllEventEmbedded.fromJson(convertedres['_embedded']);
        allevent = decodeddata.events?.take(1).toList() ?? [];

        event = EventResult(Eventstate.isData, allevent);
      } else {
        event = EventResult(Eventstate.isError, []);
      }
    } catch (e) {
      print(e);
      event = EventResult(Eventstate.isError, []);
    }
    return event;
    // return event;
  }

  Future<EventResult> getEventTypeComedy() async {
    EventResult event = EventResult(Eventstate.isLoading, []);
    try {
      String url =
          "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&classificationName=Comedy&apikey=fJaxE14X0bWaFZMnXW1A3GGDAHUttspN";
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      // List<Event> event = [];
      if (response.statusCode == 200) {
        final convertedres = jsonDecode(response.body);
        final decodeddata =
            AllEventEmbedded.fromJson(convertedres['_embedded']);
        allevent = decodeddata.events?.take(1).toList() ?? [];

        event = EventResult(Eventstate.isData, allevent);
      } else {
        event = EventResult(Eventstate.isError, []);
      }
    } catch (e) {
      print(e);
      event = EventResult(Eventstate.isError, []);
    }
    return event;
    // return event;
  }
}
