import 'dart:convert';

import '../model/event_model.dart';
import 'package:http/http.dart' as http;

class EventService {
   Future<List<Event>> getAll() async {
    const url = "http://jsonplaceholder.typicode.com/todos";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode ==  200){
      final json = jsonDecode(response.body) as List;
      // final json = "[" + response.body + "]" as List;
      final events = json.map((e) {
        return Event(
          id: e["id"],
          title: e["title"],
          userId: e["userId"],
          completed: e["completed"]
          );
      }).toList();
      return events;
    }
    return [];
    // throw "Something went worng";
   }
}