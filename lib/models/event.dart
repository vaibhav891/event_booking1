import 'dart:convert';

class Event {
  String name;
  String image;
  String date;
  int seatsAvailable;
  Event({
    this.name,
    this.image,
    this.date,
    this.seatsAvailable,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'date': date,
      'seatsAvailable': seatsAvailable,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Event(
      name: map['name'],
      image: map['image'],
      date: map['date'],
      seatsAvailable: map['seatsAvailable'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));
}
