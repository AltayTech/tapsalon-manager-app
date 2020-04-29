import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsalon_manager/models/facility.dart';
import 'package:tapsalon_manager/models/field.dart';
import 'package:tapsalon_manager/models/image.dart' as image;
import 'package:tapsalon_manager/models/place.dart';
import 'package:tapsalon_manager/models/urls.dart';

import '../models/salon.dart';

class Salons with ChangeNotifier {
  List<Salon> _items = [
//    Salon(
//        id: 'salon1',
//        title: 'سالن شماره 1',
//        description: 'This is normal Salon',
//        imageUrl:
//        'https://tapsalon.ir/wp-content/uploads/2019/03/photo_2019-02-17_17-56-25.jpg',
//        rating: 4.3,
//        city: 'تبریز',
//        price: 45,
//        lat: 38.07537,
//        lng: 46.2965326,
//        contactInfo: [
//          'تبریز',
//          'مدیریت: محمد احمدی',
//          'قراملک',
//          '09147532589',
//          'تبریز، قراملک، جنب ماشین سازی، میدان ماشین سازی',
//        ],
//        fields: [
//          'فوتسال',
//          'والیبال',
//          'هندبال',
//          'بستکبال',
//        ],
//        facilities: [
//          'رختکن',
//          'بوفه',
//          'پارکت',
//        ],
//        days: days,
//        hours: hours,
//        times: contentCell),
  ];

  Place _itemPlace;

  List<image.Image> _itemPlaceImages = [];

  Place get itemPlace => _itemPlace;

  List<Salon> get items {
    return [..._items];
  }

  Future<void> retrievePlace(int placeId) async {
    print('retrievePlace');

    final url = Urls.rootUrl + Urls.placesEndPoint + '/$placeId';
    print(url);

    try {
      final response = await get(url);

      final extractedData = json.decode(response.body);

      print(extractedData);

      Place place = Place.fromJson(extractedData);

      _itemPlace = place;
      _itemPlaceImages = place.image;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  static List<Map<String, String>> days = [
    {'12': 'شنبه'},
    {'13': 'یکشنبه'},
    {'14': 'دوشنبه'},
    {'15': 'سه شنبه'},
    {'16': 'چهارشنبه'},
    {'17': 'پنج شنبه'},
    {'18': 'جمعه'},
  ];
  static List<String> hours = [
    '7.5',
    '9',
    '10.5',
    '12',
    '13.5',
    '15',
    '16.5',
    '18',
    '19.5',
    '21',
    '22.5',
  ];
  static List<List<String>> contentCell = [
    ['1', '1', '1', '1', '1', '1', '1'],
    ['1', '1', '1', '1', '1', '1', '1'],
    ['1', '1', '1', '1', '1', '1', '1'],
    ['1', '2', '1', '1', '1', '1', '1'],
    ['1', '1', '1', '1', '1', '1', '1'],
    ['1', '1', '1', '2', '1', '1', '1'],
    ['1', '1', '1', '1', '1', '1', '1'],
    ['1', '2', '1', '1', '1', '1', '1'],
    ['1', '1', '1', '1', '1', '1', '1'],
    ['1', '1', '1', '1', '1', '1', '1'],
    ['1', '1', '1', '1', '1', '1', '1'],
  ];

  Salon findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addSalon() {
    // _items.add(value);
    notifyListeners();
  }

  Future<void> fetchAndSetSalons([bool filterByUser = false]) async {

  }

  Future<void> editPlace({
    int place_id,
    String title,
    String excerpt,
    String about,
    String address,
    String price,
    List<int> fields,
    List<int> facilities,
    int place_type,
    int image_id,
  }) async {
    print('editPlace');

    final url = Urls.rootUrl + Urls.placesEndPoint + '/$place_id';
    print(url);

    try {
      final prefs = await SharedPreferences.getInstance();

      var _token = prefs.getString('tokenM');
      final response = await put(url,
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'title': title,
            'excerpt': excerpt,
            'about': about,
            'price': price,
            'fields': fields,
            'facilities': facilities,
            'image_id': image_id,
          }));
      print(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());
        notifyListeners();

        return true;
      } else {
        notifyListeners();

        return false;
      }
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }
}
