import 'package:flutter/foundation.dart';

class PlaceInComplex with ChangeNotifier {
  final int id;
  final String title;
  final String excerpt;
  final String about;
  final String price;
  final String img_url;
  final String timing;
  final String created_at;
  final String updated_at;

  PlaceInComplex({
    this.id,
    this.title,
    this.excerpt,
    this.about,
    this.price,
    this.img_url,
    this.timing,
    this.created_at,
    this.updated_at,
  });

  factory PlaceInComplex.fromJson(Map<String, dynamic> parsedJson) {
//    var ostanList = parsedJson['ostan'] as List;
//    List<Ostan> ostanRaw = new List<Ostan>();
//    ostanRaw = ostanList.map((i) => Ostan.fromJson(i)).toList();

    return PlaceInComplex(
      id: parsedJson['id'],
      title: parsedJson['title'],
      excerpt: parsedJson['excerpt'],
      about: parsedJson['about'],
      price: parsedJson['price'],
      img_url: parsedJson['img_url'],
      timing: parsedJson['timing'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
    );
  }
}
