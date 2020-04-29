import 'package:flutter/foundation.dart';

class Role with ChangeNotifier {
  final int id;
  final String description;
  final String name;

  Role({
    this.id,
    this.description,
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> parsedJson) {
    return Role(
      id: parsedJson['id'],
      description: parsedJson['description'],
      name: parsedJson['name'],
    );
  }
}
