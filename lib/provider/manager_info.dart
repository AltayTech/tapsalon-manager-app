import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsalon_manager/models/main_notifications.dart';
import 'package:tapsalon_manager/models/rule_data.dart';
import 'package:tapsalon_manager/models/searchDetails.dart';
import 'package:tapsalon_manager/models/urls.dart';
import 'package:tapsalon_manager/models/user.dart';
import '../models/notification.dart' as notification;

class ManagerInfo with ChangeNotifier {
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

  List<notification.Notification> _notificationItems = [];

  User get user => _user;

  List<notification.Notification> get notificationItems => _notificationItems;

  Future<void> getUser() async {
    print('getUser');

    final url = Urls.rootUrl + Urls.userEndPoint;

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('tokenM');

    try {
      final response = await post(url, headers: {
        'Authorization': 'Bearer $_token',
      });

      final extractedData = json.decode(response.body);

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

    print(searchEndPoint);
  }

  Future<void> sendCustomer() async {
    print('sendCustomer');

    final url = Urls.rootUrl + Urls.userEndPoint + searchEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('tokenM');

    try {
      final response = await put(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
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

  Future<void> getNotification() async {
    print('getNotification');

    final url = Urls.rootUrl + Urls.userEndPoint + '/notifications';
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('tokenM');
    if (_token!=null) {
      try {
        final response = await get(url, headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

        final extractedData = json.decode(response.body);

        MainNotifications mainNotifications =
        MainNotifications.fromJson(extractedData);

        _notificationItems = mainNotifications.data;
        _notificationSearchDetails = SearchDetails(
          current_page: mainNotifications.current_page,
          first_page_url: mainNotifications.first_page_url,
          from: mainNotifications.from,
          last_page: mainNotifications.last_page,
          last_page_url: mainNotifications.last_page_url,
          next_page_url: mainNotifications.next_page_url,
          path: mainNotifications.path,
          per_page: mainNotifications.per_page,
          prev_page_url: mainNotifications.prev_page_url,
          to: mainNotifications.to,
          total: mainNotifications.total,
        );

        notifyListeners();
      } catch (error) {
        print(error.toString());
        throw (error);
      }
    }
  }


//  Order findById(int id) {
//    return _orders.firstWhere((prod) => prod.id == id);
//  }
//
//  OrderDetails getOrder() {
//    return _order;
//  }

//  Future<void> getOrderDetails(int orderId) async {
//    print('getOrderDetails');
//    print(orderId.toString());
//
//    _currentOrderId = orderId;
//
//    final url = Urls.rootUrl + Urls.orderInfoEndPoint + '?order_id=$orderId';
//
//    final prefs = await SharedPreferences.getInstance();
//
//    _token = prefs.getString('token');
//
//    OrderDetails orderDetails;
//    try {
//      final response = await get(url, headers: {
//        'Authorization': 'Bearer $_token',
//      });
//
//      final extractedData = json.decode(response.body);
//
//      orderDetails = OrderDetails.fromJson(extractedData);
//
//      _order = orderDetails;
//      print(extractedData.toString());
//
//      notifyListeners();
//    } catch (error) {
//      print(error.toString());
//      throw (error);
//    }
//  }

//  Future<void> payCashOrder(int orderId) async {
//    print('payCashOrder');
//
//    final url = Urls.rootUrl + Urls.payEndPoint + '?order_id=$orderId';
//
//    final prefs = await SharedPreferences.getInstance();
//
//    _token = prefs.getString('token');
//
//    try {
//      final response = await get(url, headers: {
//        'Authorization': 'Bearer $_token',
//      });
//
//      final extractedData = json.decode(response.body);
//      _payUrl = extractedData;
//      print(extractedData.toString());
//
//      notifyListeners();
//    } catch (error) {
//      print(error.toString());
//      throw (error);
//    }
//  }

//  Future<void> addFavorite(int productId, String action) async {
//    print('addFavorite');
//
//    final url = Urls.rootUrl +
//        Urls.favoriteEndPoint +
//        '?product_id=$productId&action=$action';
//
//    final prefs = await SharedPreferences.getInstance();
//
//    _token = prefs.getString('token');
//
//    try {
//      final response = await post(url, headers: {
//        'Authorization': 'Bearer $_token',
//      });
//
//      final extractedData = json.decode(response.body);
//      print(extractedData);
//
//      notifyListeners();
//    } catch (error) {
//      print(error.toString());
//      throw (error);
//    }
//  }

//  Future<void> getFavorite() async {
//    print('getFavorite');
//
//    final url = Urls.rootUrl + Urls.favoriteEndPoint;
//
//    final prefs = await SharedPreferences.getInstance();
//
//    _token = prefs.getString('token');
//
//    try {
//      final response = await get(url, headers: {
//        'Authorization': 'Bearer $_token',
//      });
//
//      final extractedData = json.decode(response.body) as List;
//
//      List<ProductFavorite> productFavorite = new List<ProductFavorite>();
//
//      productFavorite =
//          extractedData.map((i) => ProductFavorite.fromJson(i)).toList();
//
//      _favoriteProducts = productFavorite;
//
//      print(extractedData);
//
//      notifyListeners();
//    } catch (error) {
//      print(error.toString());
//      throw (error);
//    }
//  }

//
//  Future<void> addPicture(int order_id) async {
//    print('addPicture');
//
//    File _image;
//
//    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    if (_image != null) {
//      chequeImageList.add(_image);
//      Upload(_image, order_id);
//    }
//  }


//  Future<void> getRules() async {
//    print('getFavorite');
//
//    final url = Urls.rootUrl + Urls.rulesEndPoint;
//
//    try {
//      final response = await get(url);
//
//      final extractedData = json.decode(response.body) as List;
//
//      List<RuleData> ruleList = new List<RuleData>();
//
//      ruleList = extractedData.map((i) => RuleData.fromJson(i)).toList();
//
//      _ruleList = ruleList;
//
//      print(extractedData);
//
//      notifyListeners();
//    } catch (error) {
//      print(error.toString());
//      throw (error);
//    }
//  }

  List<RuleData> get ruleList => _ruleList;
}
