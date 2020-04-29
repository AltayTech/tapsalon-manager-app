import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsalon_manager/models/login_body.dart';
import 'package:tapsalon_manager/models/login_response.dart';
import 'package:tapsalon_manager/models/urls.dart';

class AuthManager with ChangeNotifier {
  String _token_m;
  String _credential_access_token;

  bool _isLoggedin;

  bool get isAuthM {
    getToken();
    return _token_m != null && _token_m != '';
  }

  set isLoggedin(bool value) {
    _isLoggedin = value;
  }

  LoginBody loginBody;

  String get tokenM => _token_m;

  set tokenM(String value) {
    _token_m = value;
  }

  String get credential_access_token => _credential_access_token;
  Map<String, String> headers = {};

  Future<bool> getCredetialToken() async {
    final url = Urls.rootUrl + Urls.loginEndPoint;
    print(url);

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'grant_type': 'client_credentials',
            'client_id': '5',
            'client_secret': 'ug3jb2ST8Cyka30a1DaXcyzP7qpOPBCaLwRRui1N',
          }));

      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData != 'false') {
        try {
          LoginResponse loginResponse = LoginResponse.fromJson(responseData);
          _credential_access_token = loginResponse.access_token;
          final prefs = await SharedPreferences.getInstance();

          prefs.setString('credential_access_token', _credential_access_token);
          prefs.setString('expires_in_m', loginResponse.expires_in.toString());
          prefs.setString('refresh_token_m', loginResponse.refresh_token);
          print(_credential_access_token);
          prefs.setString('isLoginM', 'true');
        } catch (error) {
          _credential_access_token = '';
        }
      } else {
        final prefs = await SharedPreferences.getInstance();

        _credential_access_token = '';
        prefs.setString('credential_access_token', _credential_access_token);
        print(_credential_access_token);
        print('noooo _credential_access_token');
        prefs.setString('isLoginM', 'true');
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<bool> authenticate(String verificationCode, String phoneNumber) async {
    final url = Urls.rootUrl + Urls.loginEndPoint;
    print(url);

    try {
      print(phoneNumber);
      print(verificationCode);

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'grant_type': 'password',
            'client_id': '2',
            'client_secret': 'fOfrW7RhvvbofNoTy5YDGnnhmIodcR1KF6Ax78BN',
            'username': phoneNumber,
            'password': verificationCode,
          }));

      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData != 'false') {
        try {
          LoginResponse loginResponse = LoginResponse.fromJson(responseData);
          _token_m = loginResponse.access_token;
          final prefs = await SharedPreferences.getInstance();

          prefs.setString('tokenM', _token_m);
          prefs.setString('expires_in_m', loginResponse.expires_in.toString());
          prefs.setString('refresh_token_m', loginResponse.refresh_token);
          print(_token_m);
          prefs.setString('isLoginM', 'true');
          _isLoggedin = true;
        } catch (error) {
          _isLoggedin = false;

          _token_m = '';
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        _isLoggedin = false;

        _token_m = '';
        prefs.setString('tokenM', _token_m);
        print(_token_m);
        print('noooo token');
        prefs.setString('isLoginM', 'true');
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
    return _isLoggedin;
  }

  Future<bool> sendSms(String phoneNumber) async {
    final url = Urls.rootUrl + Urls.sendSMSEndPoint + '?mobile=$phoneNumber';
    print(url);

    try {
      if (_credential_access_token.isEmpty) {
        await getCredetialToken();
      }
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_credential_access_token',
          'Accept': 'application/json'
        },
      );

//      final responseData = json.decode(response.body);
//      print(responseData);

    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    _token_m = prefs.getString('tokenM');

    notifyListeners();
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('tokenM');
    _token_m = '';
    print('toookeeen');
    print(prefs.getString('tokenM'));
    notifyListeners();
  }

//  Future<bool> tryAutoLogin() async {
//    final prefs = await SharedPreferences.getInstance();
//    if (!prefs.containsKey('userData')) {
//      return false;
//    }
//    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
//    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
//
//    if (expiryDate.isBefore(DateTime.now())) {
//      return false;
//    }
//    _token = extractedUserData['token'];
//    _userId = extractedUserData['userId'];
//    _expiryDate = expiryDate;
//    notifyListeners();
//    _autoLogout();
//    return true;
//  }
//
//  Future<void> logout() async {
//    _token = null;
//    _userId = null;
//    _expiryDate = null;
//    if (_authTimer != null) {
//      _authTimer.cancel();
//      _authTimer = null;
//    }
//    notifyListeners();
//    final prefs = await SharedPreferences.getInstance();
//    // prefs.remove('userData');
//    prefs.clear();
//  }
//
//  void _autoLogout() {
//    if (_authTimer != null) {
//      _authTimer.cancel();
//    }
//    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
//    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
//  }
}
