import 'dart:convert';

import 'package:event_booking/models/event.dart';
import 'package:flutter/services.dart';

class Events {
  static final _instance = Events._();
  List<Event> eventList;

  Events._() {
    eventList = [];
  }
  factory Events() => _instance;

  Future<String> _loadFromAsset() async {
    return await rootBundle.loadString("assets/event_list.json");
  }

  Future<List<Event>> getEventList(String searchText) async {
    String jsonString = await _loadFromAsset();
    final jsonResponse = jsonDecode(jsonString);
    for (var obj in jsonResponse) {
      Event event = new Event(
          id: obj["id"],
          name: obj["name"],
          image: obj["image"],
          date: obj["date"],
          seatsAvailable: obj["seatsAvailable"]);
      eventList.add(event);
    }
    if (searchText.isEmpty) {
      return eventList;
    } else {
      return eventList
          .where((element) => element.name.toLowerCase().contains(searchText))
          .toList();
    }
  }

  Future<Event> getEventByID(String id) async {
    if (eventList.isEmpty) {
      String jsonString = await _loadFromAsset();
      final jsonResponse = jsonDecode(jsonString);
      for (var obj in jsonResponse) {
        Event event = new Event(
            id: obj["id"],
            name: obj["name"],
            image: obj["image"],
            date: obj["date"],
            seatsAvailable: obj["seatsAvailable"]);
        eventList.add(event);
      }
    }

    return eventList.firstWhere((element) => id == element.id);
  }
}
