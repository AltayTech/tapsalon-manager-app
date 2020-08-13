import 'package:flutter/foundation.dart';

class Province with ChangeNotifier {
  final int id;

  final String name;
  final int no_users;
  final int place_count;

  Province({
    this.id,
    this.name,
    this.no_users,
    this.place_count,
  });

  factory Province.fromJson(Map<String, dynamic> parsedJson) {
    return Province(
      id: parsedJson['id'] != null ? parsedJson['id'] : 0,
      name: parsedJson['name'] != null ? parsedJson['name'] : '',
      no_users: parsedJson['no_users'] != null ? parsedJson['no_users'] : 0,
      place_count: parsedJson['place_count'] != null ? parsedJson['place_count'] : 0,
    );
  }
}
