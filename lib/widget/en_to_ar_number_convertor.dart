import 'package:flutter/material.dart';

class EnArConvertor with ChangeNotifier {
  static const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  static const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  String replaceArNumber(String input) {
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], farsi[i]);
    }

    return input;
  }
}
