import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/screen/place_detail/place_create_screen.dart';
import 'package:tapsalon_manager/screen/place_detail/place_detail_info_edit_screen.dart';
import 'package:tapsalon_manager/screen/place_detail/place_gallery_edit_screen.dart';

import './provider/auth.dart';
import './provider/places.dart';
import './provider/salons.dart';
import './provider/strings.dart';
import './provider/user_info.dart';
import './screen/about_us_screen.dart';
import './screen/home_screen.dart';
import './screen/map_screen.dart';
import './screen/navigation_bottom_screen.dart';
import './screen/splash_Screen.dart';
import './screen/user_profile/login_screen.dart';
import 'models/user_models/user.dart';
import 'najva.dart';
import 'provider/app_theme.dart';
import 'provider/cities.dart';
import 'screen/place_detail/comment_create_screen.dart';
import 'screen/place_detail/place_detail_comments_screen.dart';
import 'screen/place_detail/place_detail_screen.dart';
import 'screen/place_detail/place_detail_timing_screen.dart';
import 'screen/place_detail/place_location_screen.dart';
import 'screen/user_profile/profile_screen.dart';
import 'screen/user_profile/user_detail_info_edit_screen.dart';
import 'screen/user_profile/user_detail_info_screen.dart';
import 'screen/user_profile/user_detail_reserve_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Najva najva;

  @override
  void initState() {
    super.initState();
    najva = new Najva();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Salons(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cities(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Places(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => UserInfo(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => User(),
          ),
        ],
        child:
//      Platform.isAndroid
//          ?
            MaterialApp(
          title: Strings.appTitle,
          theme: ThemeData(
            primaryColor: AppTheme.white,
            backgroundColor: AppTheme.bg,
            textTheme: AppTheme.textTheme,
          ),
          home: Directionality(
            child: SplashScreens(),
            textDirection: TextDirection.rtl, // setting rtl
          ),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            UserDetailInfoEditScreen.routeName: (ctx) =>
                UserDetailInfoEditScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
            NavigationBottomScreen.routeName: (ctx) => NavigationBottomScreen(),
            CommentCreateScreen.routeName: (ctx) => CommentCreateScreen(),
            MapScreen.routeName: (ctx) => MapScreen(),
            UserDetailInfoScreen.routeName: (ctx) => UserDetailInfoScreen(),
            UserDetailReserveScreen.routeName: (ctx) =>
                UserDetailReserveScreen(),
            PlaceDetailTimingScreen.routeName: (ctx) =>
                PlaceDetailTimingScreen(),
            PlaceDetailCommentsScreen.routeName: (ctx) =>
                PlaceDetailCommentsScreen(),
            PlaceLocationScreen.routeName: (ctx) => PlaceLocationScreen(),
            PlaceCreateScreen.routeName: (ctx) => PlaceCreateScreen(),
            PlaceDetailInfoEditScreen.routeName: (ctx) =>
                PlaceDetailInfoEditScreen(),
            PlaceGalleryEditScreen.routeName: (ctx) => PlaceGalleryEditScreen(),
          },
        ));
  }
}
