import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsalon_manager/models/user_models/manager_stats.dart';

import '../models/rule_data.dart';
import '../models/searchDetails.dart';
import '../models/user_models/user.dart';
import '../provider/urls.dart';

class UserInfo with ChangeNotifier {
  List<RuleData> _ruleList = [RuleData(id: 0, title: '', content: '')];
  static SearchDetails _searchDetails_zero = SearchDetails(
    current_page: 1,
    from: 1,
    last_page: 0,
    last_page_url: '',
    next_page_url: '',
    path: '',
    prev_page_url: '',
    to: 10,
    total: 0,
  );

  static User _user_zero = User(
    id: 1,
  );

  User _user = _user_zero;

  SearchDetails get notificationSearchDetails => _notificationSearchDetails;
  String searchEndPoint;
  SearchDetails _notificationSearchDetails = _searchDetails_zero;

  User get user => _user;

  Future<void> getUser() async {
    print('getUser');

    final url = Urls.rootUrl + Urls.userEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');
    print(_token);

    try {
      final response = await post(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'version': Urls.versionCode
      });

      final extractedData = json.decode(response.body);
      print(extractedData);

      User user = User.fromJson(extractedData);

      _user = user;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  String _token;

  String fname;

  String lname;
  String mobile;
  String address;

  int gender = 1;
  int ostanId;
  int cityId;

  void endBuilder() {
    searchEndPoint = '';
    if (!(gender == null)) {
      searchEndPoint = searchEndPoint + '?gender=$gender';
    }
    if (!(fname == '')) {
      searchEndPoint = searchEndPoint + '&fname=$fname';
    }
    if (!(lname == '')) {
      searchEndPoint = searchEndPoint + '&lname=$lname';
    }

    if (!(ostanId == null)) {
      searchEndPoint = searchEndPoint + '&ostan_id=$ostanId';
    }
    if (!(cityId == null)) {
      searchEndPoint = searchEndPoint + '&city_id=$cityId';
    }
    if (!(mobile == null)) {
      searchEndPoint = searchEndPoint + '&mobile=$mobile';
    }
    if (!(address == null)) {
      searchEndPoint = searchEndPoint + '&address=$address';
    }
    print(searchEndPoint);
  }

  Future<void> sendCustomer() async {
    print('sendCustomer');

    final url = Urls.rootUrl + Urls.userEndPoint + searchEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    try {
      final response = await put(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );

      final extractedData = json.decode(response.body);
      print(extractedData);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  List<RuleData> get ruleList => _ruleList;

  ManagerStats _managerStats;

  ManagerStats get managerStats => _managerStats;

  Future<void> getManagerStat() async {
    print('getManagerStas');

    final url = Urls.rootUrl + Urls.managerStatsEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');
    print(_token);

    try {
      final response = await get(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'version': Urls.versionCode
      });

      final extractedData = json.decode(response.body);
      print(extractedData);

      ManagerStats managerStats = ManagerStats.fromJson(extractedData);

      _managerStats = managerStats;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }
}
