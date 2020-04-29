import 'package:flutter/foundation.dart';

class Facility with ChangeNotifier {
  final int id;
  final String description;
  final String name;
  final String excerpt;
  final String icon;


  Facility({this.id, this.description, this.name, this.excerpt, this.icon});

  factory Facility.fromJson(Map<String, dynamic> parsedJson) {
    return Facility(
      id: parsedJson['id'],
      name: parsedJson['name'],
      description: parsedJson['description'],
      excerpt: parsedJson['excerpt'],
      icon: parsedJson['icon'],
    );
  }
}
