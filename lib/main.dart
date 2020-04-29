import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/screen/complex_detail/complex_detail_add_place.dart';
import 'package:tapsalon_manager/screen/complex_detail/complex_detail_edit_complex.dart';
import 'package:tapsalon_manager/screen/complex_detail/complex_gallery_edit_screen.dart';
import 'package:tapsalon_manager/screen/manager_profile/manager_profile_screen.dart';
import 'package:tapsalon_manager/screen/place_detail/place_gallery_edit_screen.dart';

import 'models/strings.dart';
import 'provider/auth_manager.dart';
import 'provider/cities.dart';
import 'provider/complexes.dart';
import 'provider/manager_info.dart';
import 'provider/salons.dart';
import 'screen/about_us_screen.dart';
import 'screen/complex_detail/comment_create_screen.dart';
import 'screen/complex_detail/complex_detail_add_complex.dart';
import 'screen/complex_detail/complex_detail_screen.dart';
import 'screen/contact_with_us_screen.dart';
import 'screen/favorite_screen.dart';
import 'screen/home_screen.dart';
import 'screen/manager_profile/login_screen_manager.dart';
import 'screen/manager_profile/manager_detail_info_edit_screen.dart';
import 'screen/navigation_bottom_screen.dart';
import 'screen/notification_screen.dart';
import 'screen/place_detail/place_detail_edit_place.dart';
import 'screen/place_detail/salon_detail_screen.dart';
import 'screen/reserve_detail_screen.dart';
import 'screen/splash_Screen.dart';
import 'package:google_map_location_picker/generated/i18n.dart' as location_picker;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
          create: (ctx) => AuthManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Complexes(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ManagerInfo(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Salons(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cities(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Complexes(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ManagerInfo(),
        ),
      ],
      child: MaterialApp(
        title: Strings.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.amber,
          textTheme: ThemeData.light().textTheme.copyWith(
                body1: TextStyle(
                  fontFamily: 'Iransans',
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                body2: TextStyle(
                  fontFamily: 'Iransans',
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                title: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Iransans',
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        // home: CategoriesScreen(),
        localizationsDelegates: const [
          location_picker.S.delegate,
          location_picker.GeneratedLocalizationsDelegate(),

        ],
        supportedLocales: const <Locale>[
          Locale('en', ''),
        ],
        home: Directionality(
          child: SplashScreens(),
          textDirection: TextDirection.rtl, // setting rtl
        ),
        routes: {
          // '/': (ctx) => NavigationBottomScreen(),
          HomeScreeen.routeName: (ctx) => HomeScreeen(),
          FavoriteScreen.routeName: (ctx) => FavoriteScreen(),
          ComplexDetailScreen.routeName: (ctx) => ComplexDetailScreen(),
          SalonDetailScreen.routeName: (ctx) => SalonDetailScreen(),
          LoginScreenManager.routeName: (ctx) => LoginScreenManager(),
          ManagerDetailInfoEditScreen.routeName: (ctx) =>
              ManagerDetailInfoEditScreen(),

          ManagerProfileScreen.routeName: (ctx) => ManagerProfileScreen(),
          AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
          ContactWithUs.routeName: (ctx) => ContactWithUs(),
          NavigationBottomScreen.routeName: (ctx) => NavigationBottomScreen(),
          ReserveDetailScreen.routeName: (ctx) => ReserveDetailScreen(),
          NotificationScreen.routeName: (ctx) => NotificationScreen(),

          CommentCreateScreen.routeName: (ctx) => CommentCreateScreen(),
          ComplexGalleryEditScreen.routeName: (ctx) =>
              ComplexGalleryEditScreen(),
          ComplexDetailAddComplex.routeName: (ctx) => ComplexDetailAddComplex(),
          ComplexDetailAddPlace.routeName: (ctx) => ComplexDetailAddPlace(),
          ComplexDetailEditComplex.routeName: (ctx) => ComplexDetailEditComplex(),
          PlaceDetailEditPlace.routeName: (ctx) => PlaceDetailEditPlace(),
          PlaceGalleryEditScreen.routeName: (ctx) => PlaceGalleryEditScreen(),
        },
      ),
    );
  }
}
