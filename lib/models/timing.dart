import 'package:flutter/foundation.dart';

class Timing with ChangeNotifier {
  final int id;
   int place_id;
   String gender;
   String date_start;
   String date_end;
   int discount;
   int reservable;
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
//      'place_id': place_id,
      'gender': gender,
      'start': date_start,
      'end': date_end,
      'discount': discount,
      'reservable': reservable,

    };
  }
}
