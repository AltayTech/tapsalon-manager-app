import 'package:flutter/material.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';

import '../widget/en_to_ar_number_convertor.dart';
import '../widget/splashscreen.dart';
import 'navigation_bottom_screen.dart';

class SplashScreens extends StatefulWidget {
  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: NavigationBottomScreen(),
      title: Text(
        'تاپ سالن',
        style: AppTheme.textTheme.headline4
            .copyWith(color: Color(0xff149D49), fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      subtitle: Text(
        'اپلیکیشن مدیریت',
        style: TextStyle(
          fontFamily: 'Iransans',
          fontSize: MediaQuery.of(context).textScaleFactor * 20,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
      loadingText: Text(
        EnArConvertor().replaceArNumber('نسخه 1.0.1'),
        style: TextStyle(
          fontFamily: 'Iransans',
          fontWeight: FontWeight.w400,
          fontSize: MediaQuery.of(context).textScaleFactor * 18,
          color: Colors.black,
        ),
      ),
      image: Image.asset(
        'assets/images/tapsalon_icon_200.png',
        fit: BoxFit.cover,
      ),
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 70.0,
      onClick: () => print("Flutter Egypt"),
    );
  }
}
