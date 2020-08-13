import 'package:flutter/foundation.dart';

class City with ChangeNotifier {
  final int id;
  final int provinceId;
  final String name;
  final double latitude;
  final double longitude;
  final int place_count;

  City({
    this.id,
    this.provinceId,
    this.name,
    this.latitude,
    this.longitude,
    this.place_count,
  });

  factory City.fromJson(Map<String, dynamic> parsedJson) {
    return City(
      id: parsedJson['id'] != null ? parsedJson['id'] : 0,
      provinceId: parsedJson['ostan_id'] != null ? parsedJson['ostan_id'] : 0,
      name: parsedJson['name'] != null ? parsedJson['name'] : '',
      latitude: parsedJson['latitude'] != null ? parsedJson['latitude'] : 0.0,
      longitude:
          parsedJson['longitude'] != null ? parsedJson['longitude'] : 0.0,
      place_count:
          parsedJson['place_count'] != null ? parsedJson['place_count'] : 0,
    );
  }
}
