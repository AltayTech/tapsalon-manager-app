import 'package:flutter/foundation.dart';
import 'package:tapsalon_manager/models/places_models/place_type.dart';

import '../image.dart';
import '../image_url.dart';
import '../region.dart';

class PlaceInSearch with ChangeNotifier {
  final int id;

  final String name;
  final String excerpt;
  final String about;
  final String timings_excerpt;
  final int price;
  final String phone;
  final String mobile;
  final String address;
  final double latitude;
  final double longitude;
  final int comments_count;
  final int likes_count;
  final double rate;
  final int visit;
  final int status;
  final int parent_id;

  final String createdAt;
  final String updatedAt;
  final bool liked;
  final PlaceType placeType;
  final Region region;

  final ImageObj image;

  PlaceInSearch({
    this.id,
    this.name,
    this.excerpt,
    this.about,
    this.timings_excerpt,
    this.price,
    this.phone,
    this.mobile,
    this.address,
    this.latitude,
    this.longitude,
    this.comments_count,
    this.likes_count,
    this.rate,
    this.visit,
    this.status,
    this.parent_id,
    this.createdAt,
    this.updatedAt,
    this.liked,
    this.image,
    this.placeType,
    this.region,
  });

  factory PlaceInSearch.fromJson(Map<String, dynamic> parsedJson) {
    return PlaceInSearch(
      id: parsedJson['id'],
      name: parsedJson['name'],
      excerpt: parsedJson['excerpt'] != null ? parsedJson['excerpt'] : '',
      about: parsedJson['about'] != null ? parsedJson['about'] : '',
      timings_excerpt: parsedJson['timings_excerpt'] != null
          ? parsedJson['timings_excerpt']
          : '',
      price: parsedJson['price'] != null ? parsedJson['price'] : 0,
      phone: parsedJson['phone'] != null ? parsedJson['phone'] : '',
      mobile: parsedJson['mobile'] != null ? parsedJson['mobile'] : '',
      address: parsedJson['address'] != null ? parsedJson['address'] : '',
      latitude: parsedJson['latitude'] != null
          ? double.parse(parsedJson['latitude'].toString())
          : 0.0,
      longitude: parsedJson['longitude'] != null
          ? double.parse(parsedJson['longitude'].toString())
          : 0.0,
      comments_count: parsedJson['comments_count'] != null
          ? parsedJson['comments_count']
          : 0,
      likes_count:
          parsedJson['likes_count'] != null ? parsedJson['likes_count'] : 0,
      rate: parsedJson['rate'] != null ? parsedJson['rate'] : 0,
      visit: parsedJson['visit'] != null ? parsedJson['visit'] : 0,
      status: parsedJson['status'] != null ? parsedJson['status'] : 0,
      parent_id: parsedJson['parent_id'] != null ? parsedJson['parent_id'] : 0,
      placeType: PlaceType.fromJson(parsedJson['place_type']),
      region: Region.fromJson(parsedJson['region']),
      createdAt:
          parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      updatedAt:
          parsedJson['updated_at'] != null ? parsedJson['updated_at'] : '',
      liked: parsedJson['liked'] != null ? parsedJson['liked'] : false,
      image: parsedJson['image'] != null
          ? ImageObj.fromJson(parsedJson['image'])
          : ImageObj(
              id: 0,
              filename: '',
              url: PlaceType.fromJson(parsedJson['place_type']).id != 2
                  ? ImageUrl(
                      medium: 'assets/images/place_placeholder.jpeg',
                      large: 'assets/images/place_placeholder.jpeg',
                      thumb: 'assets/images/place_placeholder.jpeg',
                    )
                  : ImageUrl(
                      medium: 'assets/images/gym_placeholder.jpg',
                      large: 'assets/images/gym_placeholder.jpg',
                      thumb: 'assets/images/gym_placeholder.jpg',
                    )),
    );
  }
}
