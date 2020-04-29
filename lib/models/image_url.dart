import 'package:flutter/foundation.dart';

class Url with ChangeNotifier {
  final String thumb;
  final String medium;
  final String large;

  Url({this.thumb, this.medium, this.large});

  factory Url.fromJson(Map<String, dynamic> parsedJson) {
    return Url(
      thumb: parsedJson['thumb'],
      medium: parsedJson['medium'],
      large: parsedJson['large'],
    );
  }
}
