import 'package:flutter/foundation.dart';

import 'complex_in_place.dart';
import 'facility.dart';
import 'featured.dart';
import 'field.dart';
import 'image.dart';
import 'image_url.dart';
import 'palce_type.dart';

class Place with ChangeNotifier {
  final int id;
  final String title;
  final String excerpt;
  final String about;
  final String price;
  final String img_url;
  final String timing;
  final String created_at;
  final String updated_at;
  final ComplexInPlace complexInPlace;
  final PlaceType placeType;
  final Featured featured;
  final List<Image> image;
  final List<Facility> facilities;
  final List<Field> fields;

  Place(
      {this.id,
      this.title,
      this.excerpt,
      this.about,
      this.price,
      this.img_url,
      this.timing,
      this.created_at,
      this.updated_at,
      this.complexInPlace,
      this.placeType,
      this.featured,
      this.image,
      this.facilities,
      this.fields});

  factory Place.fromJson(Map<String, dynamic> parsedJson) {
    var imageList = parsedJson['image'] as List;
    List<Image> imageRaw = new List<Image>();
    imageRaw = imageList.map((i) => Image.fromJson(i)).toList();

    var facilitiesList = parsedJson['facilities'] as List;
    List<Facility> faciltyRaw = new List<Facility>();
    faciltyRaw = facilitiesList.map((i) => Facility.fromJson(i)).toList();

    var filedsList = parsedJson['fields'] as List;
    List<Field> fieldRaw = new List<Field>();
    fieldRaw = filedsList.map((i) => Field.fromJson(i)).toList();

    return Place(
      id: parsedJson['id'],
      title: parsedJson['title'],
      excerpt: parsedJson['excerpt'],
      about: parsedJson['about'],
      price: parsedJson['price'],
      img_url: parsedJson['img_url'],
      timing: parsedJson['timing'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
      complexInPlace: ComplexInPlace.fromJson(parsedJson['complex']),
      placeType: PlaceType.fromJson(parsedJson['place_type']),
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
      image: imageRaw,
      facilities: faciltyRaw,
      fields: fieldRaw,
    );
  }
}
