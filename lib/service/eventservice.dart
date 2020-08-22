import 'dart:convert';

import 'package:event_booking/models/event.dart';
import 'package:flutter/services.dart';

Future<String> _loadFromAsset() async {
  return await rootBundle.loadString("assets/event_list.json");
}

Future<List<Event>> getEventList(String searchText) async {
  List<Event> eventList = [];

  String jsonString = await _loadFromAsset();
  final jsonResponse = jsonDecode(jsonString);
  for (var obj in jsonResponse) {
    Event event = new Event(
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
