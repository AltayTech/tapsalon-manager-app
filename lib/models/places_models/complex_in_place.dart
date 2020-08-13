
import 'package:flutter/foundation.dart';

class ComplexInPlace with ChangeNotifier {
  final int id;

  final String name;
  final String about;

  ComplexInPlace({
    this.id,
    this.name,
    this.about,
  });

  factory ComplexInPlace.fromJson(Map<String, dynamic> parsedJson) {
    return ComplexInPlace(
      id: parsedJson['id'],
      name: parsedJson['name'],
      about: parsedJson['about'],
    );
  }
}
