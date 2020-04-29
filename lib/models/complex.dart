import 'package:flutter/foundation.dart';
import 'package:tapsalon_manager/models/image.dart';
import 'package:tapsalon_manager/models/image_url.dart';

import 'city.dart';
import 'featured.dart';
import 'ostan.dart';
import 'place_in_complex.dart';
import 'region.dart';
import 'user_in_complex.dart';

class Complex with ChangeNotifier {
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
  final UserInComplex user;

  final List<PlaceInComplex> placeList;
  final Ostan ostan;
  final City city;
  final Region region;
  final Featured featured;
  final List<Image> image;

  Complex({
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
    this.user,
    this.placeList,
    this.ostan,
    this.city,
    this.region,
    this.featured,
    this.image,
  });

  factory Complex.fromJson(Map<String, dynamic> parsedJson) {
    var placeList = parsedJson['places'] as List<dynamic>;
    List<PlaceInComplex> placeRaw = new List<PlaceInComplex>();
    placeRaw = placeList.map((i) => PlaceInComplex.fromJson(i)).toList();

    var imageList = parsedJson['image'] as List<dynamic>;
    List<Image> imageRaw = new List<Image>();
    imageRaw = imageList.map((i) => Image.fromJson(i)).toList();

    return Complex(
      id: parsedJson['id'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      name: parsedJson['name'],
      excerpt: parsedJson['excerpt'],
      about: parsedJson['about'],
      img_url: parsedJson['img_url'],
      address: parsedJson['address'],
      likes_no: parsedJson['likes_no'],
      visits_no: parsedJson['visits_no'],
      stars: double.parse(parsedJson['stars'].toString()),
      phone: parsedJson['phone'],
      mobile: parsedJson['mobile'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
      ostan: Ostan.fromJson(parsedJson['ostan']),
      placeList: placeRaw,
      user: UserInComplex.fromJson(parsedJson['user']),
      city: City.fromJson(parsedJson['city']),
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
      image: imageRaw,
    );
  }
}
