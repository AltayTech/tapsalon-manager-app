import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsalon_manager/models/city.dart';
import 'package:tapsalon_manager/models/ostan.dart';
import 'package:tapsalon_manager/models/region.dart';
import 'package:tapsalon_manager/models/urls.dart';

class Cities with ChangeNotifier {
  City _selectedCity =
      City(id: 0, ostan_id: 0, name: '', description: '', no_users: 0);

  List<Region> _regionsItems = [];

  List<Region> get regionsItems => _regionsItems;

  City get selectedCity => _selectedCity;

  set selectedCity(City value) {
    _selectedCity = value;
  }

  List<City> _citiesItems = [
    City(id: 0, ostan_id: 0, name: 'aaaaaaa', description: '', no_users: 0)
  ];
  List<Ostan> _ostansItems = [
    Ostan(id: 0, name: '', description: '', no_users: 0)
  ];

  List<City> get citiesItems => _citiesItems;

  List<Ostan> get ostansItems => _ostansItems;

  Future<void> setSelectedCity(City selectedCity) async {
    print('setSelectedCity');

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedCity', selectedCity.id);

    _selectedCity = selectedCity;

    notifyListeners();
  }

  Future<void> getSelectedCity() async {
    print('getSelectedCity');

    final prefs = await SharedPreferences.getInstance();
    int _selectedCityId = prefs.getInt('selectedCity');
    if (_selectedCityId != null) {
      final url = Urls.rootUrl + Urls.citiesEndPoint + '/$_selectedCityId';
      print(url);

      try {
        final response = await get(url);

        final extractedData = json.decode(response.body);
        print(extractedData);

        City dataRaw = City.fromJson(extractedData);

//      print(dataRaw[0].description.toString());
//      print(dataRaw[0].id.toString());
        _selectedCity = dataRaw;

        notifyListeners();
      } catch (error) {
        print(error.toString());
        throw (error);
      }
    }
  }

  Future<void> retrieveCities() async {
    print('retrieveCities');

    final url = Urls.rootUrl + Urls.citiesEndPoint;

    try {
      final response = await get(url);

//      final extractedData = json.decode(response.body);
      Iterable extractedData = json.decode(response.body) as List;
      print(extractedData);

      List<City> dataRaw = extractedData.map((i) => City.fromJson(i)).toList();

//      print(dataRaw[0].description.toString());
//      print(dataRaw[0].id.toString());
      _citiesItems = dataRaw;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveOstanCities(int ostanId) async {
    print('retrieveOstanCities');

    final url = Urls.rootUrl + Urls.ostansEndPoint + '/$ostanId/cities';
    print(url);

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      Iterable extractedData = json.decode(response.body) as List;
      print(extractedData);

      List<City> dataRaw = extractedData.map((i) => City.fromJson(i)).toList();

//      print(dataRaw[0].description.toString());
//      print(dataRaw[0].id.toString());
      _citiesItems.clear();
      _citiesItems = dataRaw;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveCityRegions(int cityId) async {
    print('retrieveCityRegions');

    final url = Urls.rootUrl + Urls.citiesEndPoint + '/$cityId/regions';
    print(url);

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      Iterable extractedData = json.decode(response.body) as List;
      print(extractedData);

      List<Region> dataRaw =
          extractedData.map((i) => Region.fromJson(i)).toList();
      _regionsItems.clear();
      _regionsItems = dataRaw;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveOstans() async {
    print('retrieveOstans');

    final url = Urls.rootUrl + Urls.ostansEndPoint;

    try {
      final response = await get(url);

      final extractedData = json.decode(response.body) as List;
      print(extractedData);
      List<Ostan> dataRaw =
          extractedData.map((i) => Ostan.fromJson(i)).toList();

      print(dataRaw[0].description.toString());
      _ostansItems = dataRaw;
      print(_ostansItems[0].description.toString());

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }
}
