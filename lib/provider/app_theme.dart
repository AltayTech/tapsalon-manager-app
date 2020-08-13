import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xffF1F9FF);
  static const Color secondary = Color(0xffF6F6F6);
  static const Color bg = Color(0xffF6F6F6);
  static const Color h1 = Color(0xff687466);
  static Color accent = Color(0xffFBC490);
  static const Color white = Colors.white;
  static Color black = Colors.black;
  static Color grey = Colors.grey;
  static const Color iconColor = Color(0xffFFA41B);
  static const Color maleColor = Color(0xff00A8CC);
  static const Color femaleColor = Color(0xffFFA41B);
  static const Color buttonColor = Color(0xff3F9B12);
  static Color mainPageColor = Colors.red[700];

  // dependent colors
  static const Color appBarColor = white;
  static const Color spinerColor = Colors.grey;

  static const Color appBarIconColor = Color(0xff545454);
  static const Color BNbgColor = Colors.white70;
  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color BNbSelectedItemColor = Color(0xFFED8A19);
  static const Color bgColor = Colors.black54;
  static const Color textColorMainColor = Color(0xffFF8E00);

  static const Color discountBgColor = Color(0xFF55CC1B);
  static const Color priceBgColor = Color(0xFFFE5E2B);

  static TextTheme textTheme = TextTheme(
    headline1: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 96,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
    ),
    headline2: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 60,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
    ),
    headline3: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 48,
      fontWeight: FontWeight.w400,
    ),
    headline4: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 34,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    headline5: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    headline6: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    subtitle1: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    subtitle2: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyText1: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyText2: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    button: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    caption: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    overline: TextStyle(
      fontFamily: 'Iransans',
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
    ),
  );
}
