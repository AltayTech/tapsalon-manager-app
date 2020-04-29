import 'package:flutter/foundation.dart';

import 'featured.dart';
import 'field_search.dart';
import 'image_url.dart';
import 'place_in_complex.dart';
import 'region.dart';

class ComplexSearch with ChangeNotifier {
  final int id;
  final int media_id;
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

  final List<FieldSearch> fields;
  final Region region;
  final Featured featured;
  final List<PlaceInComplex> placeList;

  ComplexSearch({
    this.id,
    this.media_id,
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
    this.fields,
    this.region,
    this.featured,
    this.placeList,
  });

  factory ComplexSearch.fromJson(Map<String, dynamic> parsedJson) {
    List<FieldSearch> fieldsRaw = new List<FieldSearch>();

    try {
      var fieldsList = parsedJson['fields'] as List<dynamic>;
      fieldsRaw = new List<FieldSearch>();
      fieldsRaw = fieldsList.map((i) => FieldSearch.fromJson(i)).toList();
    } catch (error) {
      fieldsRaw = [];
    }
    var placeList = parsedJson['places'] as List;
    List<PlaceInComplex> placeRaw = new List<PlaceInComplex>();
    placeRaw = placeList.map((i) => PlaceInComplex.fromJson(i)).toList();

    return ComplexSearch(
      id: parsedJson['id'],
      media_id: parsedJson['media_id'],
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
      fields: fieldsRaw,
      region: Region.fromJson(parsedJson['region']),
      featured: parsedJson['featured'] != null
          ? Featured.fromJson(parsedJson['featured'])
          : Featured(
              id: 0,
              title: '',
              created_at: '',
              extension: '',
              filename: '',
              place_id: 0,
              updated_at: '',
              url: Url(large: '', medium: '', thumb: '')),
      placeList: placeRaw,
    );
  }
}
