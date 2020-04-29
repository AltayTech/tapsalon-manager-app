import 'package:flutter/foundation.dart';

import 'city.dart';
import 'ostan.dart';
import 'user.dart';
class Salon with ChangeNotifier {
  final int id;
  final int user_id;
  final int ostan_id;
  final int city_id;
  final String latitude;
  final String longitude;
  final String title;
  final String excerpt;
  final String about;
  final String address;
  final String price;
  final String img_url;
  final int likes;
  final int visits;
  final int stars;
  final String phone;
  final String mobile;
  final String created_at;
  final String updated_at;
  final Ostan ostan;
  final City city;
  final User user;

  Salon(
      {this.id,
        this.user_id,
        this.ostan_id,
        this.city_id,
        this.latitude,
        this.longitude,
        this.title,
        this.excerpt,
        this.about,
        this.address,
        this.price,
        this.img_url,
        this.likes,
        this.visits,
        this.stars,
        this.phone,
        this.mobile,
        this.created_at,
        this.updated_at,
        this.ostan,
        this.city,
        this.user});

  factory Salon.fromJson(Map<String, dynamic> parsedJson) {

//    var ostanList = parsedJson['ostan'] as List;
//    List<Ostan> ostanRaw = new List<Ostan>();
//    ostanRaw = ostanList.map((i) => Ostan.fromJson(i)).toList();
//
//    var cityList = parsedJson['data'] as List;
//    List<City> cityRaw = new List<City>();
//    cityRaw = cityList.map((i) => City.fromJson(i)).toList();
//
//    var userList = parsedJson['data'] as List;
//    List<User> userRaw = new List<User>();
//    userRaw = userList.map((i) => User.fromJson(i)).toList();
//

    return Salon(
      id: parsedJson['id'],
      user_id: parsedJson['user_id'],
      ostan_id: parsedJson['ostan_id'],
      city_id: parsedJson['city_id'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      title: parsedJson['title'],
      excerpt: parsedJson['excerpt'],
      about: parsedJson['about'],
      address: parsedJson['address'],
      price: parsedJson['price'],
      img_url: parsedJson['img_url'],
      likes: parsedJson['likes'],
      visits: parsedJson['visits'],
      stars: parsedJson['stars'],
      phone: parsedJson['phone'],
      mobile: parsedJson['mobile'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
      ostan: Ostan.fromJson(parsedJson['ostan']),
      city: City.fromJson(parsedJson['city']),
      user: User.fromJson(parsedJson['user']),
    );
  }
}
