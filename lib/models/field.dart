import 'package:flutter/foundation.dart';

class Field with ChangeNotifier {
  final int id;
  final String description;
  final String name;
  final String excerpt;
  final String icon;

  Field({
    this.id,
    this.description,
    this.name,
    this.excerpt,
    this.icon,
  });

  factory Field.fromJson(Map<String, dynamic> parsedJson) {
    return Field(
      id: parsedJson['id'] != null ? parsedJson['id'] : 0,
      name: parsedJson['name'] != null ? parsedJson['name'] : '',
      description:
          parsedJson['description'] != null ? parsedJson['description'] : '',
      excerpt: parsedJson['excerpt'] != null ? parsedJson['excerpt'] : '',
      icon: parsedJson['icon'] != null ? parsedJson['icon'] : '',
    );
  }
}
