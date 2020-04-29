import 'package:flutter/foundation.dart';

class Ostan with ChangeNotifier {
  final int id;
  final String description;
  final String name;
  final int no_users;

  Ostan({this.id, this.description, this.name, this.no_users});

  factory Ostan.fromJson(Map<String, dynamic> parsedJson) {
    return Ostan(
      id: parsedJson['id'],
      description: parsedJson['description'],
      name: parsedJson['name'],
      no_users: parsedJson['no_users'],
    );
  }
}
