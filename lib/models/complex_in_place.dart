import 'package:flutter/foundation.dart';

class ComplexInPlace with ChangeNotifier {
  final int id;

//  final int media_id;
  final double latitude;
  final double longitude;
  final String name;
  final String excerpt;
  final String about;
  final String address;
  final String img_url;
  final int likes_no;
  final int visits_no;
  final double stars;
  final String phone;
  final String mobile;
  final String created_at;
  final String updated_at;

  ComplexInPlace({
    this.id,
//    this.media_id,
    this.latitude,
    this.longitude,
    this.name,
    this.excerpt,
    this.about,
    this.address,
    this.img_url,
    this.likes_no,
    this.visits_no,
    this.stars,
    this.phone,
    this.mobile,
    this.created_at,
    this.updated_at,
  });

  factory ComplexInPlace.fromJson(Map<String, dynamic> parsedJson) {
    return ComplexInPlace(
      id: parsedJson['id'],
//      media_id: parsedJson['media_id'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      name: parsedJson['name'],
      excerpt: parsedJson['excerpt'],
      about: parsedJson['about'],
      address: parsedJson['address'],
      img_url: parsedJson['img_url'],
      likes_no: parsedJson['likes_no'],
      visits_no: parsedJson['visits_no'],
      stars: double.parse(parsedJson['stars'].toString()),
      phone: parsedJson['phone'],
      mobile: parsedJson['mobile'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
    );
  }
}
