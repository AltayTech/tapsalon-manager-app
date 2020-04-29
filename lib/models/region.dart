import 'package:flutter/foundation.dart';

class Region with ChangeNotifier {
  final int id;
  final int city_id;
  final String name;
  final int no_users;

  Region({this.id, this.city_id, this.name, this.no_users});

  factory Region.fromJson(Map<String, dynamic> parsedJson) {
    return Region(
      id: parsedJson['id'],
      city_id: parsedJson['city_id'],
      name: parsedJson['name'],
      no_users: parsedJson['no_users'],
    );
  }
}
