import 'package:flutter/foundation.dart';

class Timing with ChangeNotifier {
  final int id;
  final int place_id;
  final String gender;
  final String date_start;
  final String date_end;
  final int discount;
  final int reservable;
  final String created_at;
  final String updated_at;

  Timing(
      {this.id,
      this.place_id,
      this.gender,
      this.date_start,
      this.date_end,
      this.discount,
      this.reservable,
      this.created_at,
      this.updated_at});

  factory Timing.fromJson(Map<String, dynamic> parsedJson) {
    return Timing(
      id: parsedJson['id'],
      place_id: parsedJson['place_id'] != null ? parsedJson['place_id'] : 0,
      gender: parsedJson['gender'] != null ? parsedJson['gender'] : '',
      date_start: parsedJson['start'] != null ? parsedJson['start'] : '0',
      date_end: parsedJson['end'] != null ? parsedJson['end'] : '0',
      discount: parsedJson['discount'] != null ? parsedJson['discount'] : 0,
      reservable:
          parsedJson['reservable'] != null ? parsedJson['reservable'] : 0,
      created_at:
          parsedJson['created_at'] != null ? parsedJson['created_at'] : '0',
      updated_at:
          parsedJson['updated_at'] != null ? parsedJson['updated_at'] : '0',
    );
  }
}
