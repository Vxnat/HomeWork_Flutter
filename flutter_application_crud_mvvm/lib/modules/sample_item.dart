import 'package:flutter/material.dart';

class SampleItem {
  String id;
  ValueNotifier<String> name;
  ValueNotifier<String> description;
  String date;
  String imgItem;

  SampleItem(
      {required this.id,
      required String name,
      required String description,
      required this.date,
      required this.imgItem})
      : name = ValueNotifier(name),
        description = ValueNotifier(description);

  @override
  String toString() {
    return '$id|${name.value}|${description.value}|$date|$imgItem';
  }

  // Reconstruct a Note object from a string
  factory SampleItem.fromString(String noteString) {
    List<String> parts = noteString.split('|');
    return SampleItem(
      id: parts[0],
      name: parts[1],
      description: parts[2],
      date: parts[3],
      imgItem: parts[4],
    );
  }
}
