import 'package:flutter/foundation.dart';

class City with ChangeNotifier {
  final int id;
  final int ostan_id;
  final String name;
  final String description;
  final int no_users;

  City({this.id, this.ostan_id, this.name, this.description, this.no_users});

  factory City.fromJson(Map<String, dynamic> parsedJson) {
    return City(
      id: parsedJson['id'],
      ostan_id: parsedJson['ostan_id'],
      description: parsedJson['description'],
      name: parsedJson['name'],
      no_users: parsedJson['no_users'],
    );
  }
}
