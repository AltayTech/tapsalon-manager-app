import 'package:flutter/foundation.dart';

class Pivot with ChangeNotifier {
  final int place_id;
  final int field_id;

  Pivot({this.place_id, this.field_id});

  factory Pivot.fromJson(Map<String, dynamic> parsedJson) {
    return Pivot(
      place_id: parsedJson['place_id'],
      field_id: parsedJson['field_id'],
    );
  }
}
