import 'package:flutter/foundation.dart';

class Notification with ChangeNotifier {
  final int id;
  final int complex_id;
  final String title;
  final String description;
  final int type;
  final String created_at;
  final String updated_at;

  Notification(
      {this.id,
      this.complex_id,
      this.title,
      this.description,
      this.type,
      this.created_at,
      this.updated_at});

  factory Notification.fromJson(Map<String, dynamic> parsedJson) {
    return Notification(
      id: parsedJson['id'],
      complex_id: parsedJson['complex_id'],
      title: parsedJson['title'],
      description: parsedJson['description'],
      type: parsedJson['type'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
    );
  }
}
