import 'package:flutter/foundation.dart';

class PlaceType with ChangeNotifier {
  final int id;
  final String name;

  PlaceType({
    this.id,
    this.name,
  });

  factory PlaceType.fromJson(Map<String, dynamic> parsedJson) {
    return PlaceType(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}
