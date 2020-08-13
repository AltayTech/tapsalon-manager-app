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
  bool _isInit = true;

  @override
  void didChangeDependencies() {
//    if (_isInit) {
//      Provider.of<Products>(context, listen: false).fetchAndSetHomeData();
//    }
//    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: NavigationBottomScreen(),
      title: Text(
        'تاپ سالن',
        style: AppTheme.textTheme.headline4.copyWith(color: Color(0xff149D49),
        fontWeight: FontWeight.bold),
//        TextStyle(
//          fontFamily: 'Iransans',
//          fontSize: MediaQuery.of(context).textScaleFactor * 30,
//          color: Color(0xff149D49),
//        ),
        textAlign: TextAlign.center,
      ),
      subtitle:Text(
        'مرجع اماکن ورزشی',
        style: TextStyle(
          fontFamily: 'Iransans',
          fontSize: MediaQuery.of(context).textScaleFactor * 20,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ) ,
      loadingText: Text(
        EnArConvertor().replaceArNumber('نسخه 4.0.18'),
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
//      gradientBackground: LinearGradient(
//          begin: Alignment.topRight,
//          end: Alignment.bottomLeft,
//          colors: [Color(0xff006DB5), Color(0xff008AB5), Color(0xff01A89E)]),
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 70.0,
      onClick: () => print("Flutter Egypt"),
    );
  }
}
