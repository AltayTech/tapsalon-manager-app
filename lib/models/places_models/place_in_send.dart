import 'package:flutter/foundation.dart';

import '../timing.dart';

class PlaceInSend with ChangeNotifier {
  int id;
  String name;
  String excerpt;
  String about;
  String timings_excerpt;
  int price;
  String phone;
  String mobile;
  String address;
  double latitude;
  double longitude;
  int placeType;
  List<int> fields;
  List<int> facilities;
  int image;
  List<int> gallery;
  List<Timing> timings;
  int province;
  int city;
  int region;
  int status;

  PlaceInSend({
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
    this.placeType,
    this.fields,
    this.facilities,
    this.image,
    this.gallery,
    this.timings,
    this.province,
    this.city,
    this.region,
    this.status,
  });

  factory PlaceInSend.fromJson(Map<String, dynamic> parsedJson) {
//    List<ImageObj> galleryRaw = [];
//
//    if (parsedJson['gallery'] != null) {
//      var galleryList = parsedJson['gallery'] as List;
//      galleryRaw = new List<ImageObj>();
//      galleryRaw = galleryList.map((i) => ImageObj.fromJson(i)).toList();
//    }
//
//    var facilitiesList = parsedJson['facilities'] as List;
//    List<Facility> faciltyRaw = new List<Facility>();
//    faciltyRaw = facilitiesList.map((i) => Facility.fromJson(i)).toList();
//
//    var filedsList = parsedJson['fields'] as List;
//    List<Field> fieldRaw = new List<Field>();
//    fieldRaw = filedsList.map((i) => Field.fromJson(i)).toList();
//
//    List<Timing> timingsRaw = [];
//    if (parsedJson['timings'] != null) {
//      var timingsList = parsedJson['timings'] as List;
//      timingsRaw = new List<Timing>();
//      timingsRaw = timingsList.map((i) => Timing.fromJson(i)).toList();
//    }
    return PlaceInSend(
      id: parsedJson['id'],
      name: parsedJson['name'] != null ? parsedJson['name'] : '',
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

//      placeType: PlaceType.fromJson(parsedJson['place_type']),
//      fields: fieldRaw,
//      facilities: faciltyRaw,
//      image: parsedJson['image'] != null
//          ? ImageObj.fromJson(parsedJson['image'])
//          : ImageObj(
//              id: 0,
//              filename: '',
//              url: PlaceType.fromJson(parsedJson['place_type']).id != 2
//                  ? ImageUrl(
//                      medium: 'assets/images/place_placeholder.jpeg',
//                      large: 'assets/images/place_placeholder.jpeg',
//                      thumb: 'assets/images/place_placeholder.jpeg',
//                    )
//                  : ImageUrl(
//                      medium: 'assets/images/gym_placeholder.jpg',
//                      large: 'assets/images/gym_placeholder.jpg',
//                      thumb: 'assets/images/gym_placeholder.jpg',
//                    )),
//      gallery: galleryRaw,
//      timings: timingsRaw,
//      province: Province.fromJson(parsedJson['ostan']),
//      city: City.fromJson(parsedJson['city']),
//      region: Region.fromJson(parsedJson['region']),
////      user: UserInComplex.fromJson(parsedJson['user']),
//      likes_count: parsedJson['likes_count'] != null
//          ? int.parse(parsedJson['likes_count'].toString())
//          : 0,
//      comments_count: parsedJson['comments_count'] != null
//          ? int.parse(parsedJson['comments_count'].toString())
//          : 0,
//      visitsNo: parsedJson['visitsNo'] != null
//          ? int.parse(parsedJson['visitsNo'].toString())
//          : 0,
//      rate: parsedJson['rate'] != null
//          ? double.parse(parsedJson['rate'].toString())
//          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
//    Map fields =
//        this.fields != null ? this.fields.toJson() : null;
//
    List<Map> timings = this.timings != null
        ? this.timings.map((i) => i.toJson()).toList()
        : null;

    return {
      'id': id,
      'name': name,
      'excerpt': excerpt,
      'about': about,
      'timings_excerpt': timings_excerpt,
      'price': price,
      'phone': phone,
      'mobile': mobile,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'place_type_id': placeType,
      'fields_ids': fields,
      'facilities_ids': facilities,
      'image_id': image,
      'gallery_ids': gallery,
      'timings': timings,
      'ostan_id': province,
      'city_id': city,
      'region_id': region,
      'status': status,
    };
  }
}
