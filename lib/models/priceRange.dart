import 'package:flutter/foundation.dart';

class PriceRange with ChangeNotifier {
  final String min;
  final String max;

  PriceRange({this.min, this.max});

  factory PriceRange.fromJson(Map<String, dynamic> parsedJson) {
    return PriceRange(
      min: parsedJson['min'],
      max: parsedJson['max'],
    );
  }
}
