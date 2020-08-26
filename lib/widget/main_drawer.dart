import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/screen/navigation_bottom_screen.dart';
import 'package:tapsalon_manager/screen/place_detail/place_create_screen.dart';
import 'package:tapsalon_manager/screen/place_detail/place_detail_info_screen.dart';
import 'package:tapsalon_manager/screen/place_detail/place_detail_screen_test.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/app_theme.dart';
import '../provider/auth.dart';
import '../screen/about_us_screen.dart';
import '../screen/user_profile/login_screen.dart';
import '../screen/user_profile/profile_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    Color textColor = Colors.black;
    Color iconColor = AppTheme.grey;

    return Drawer(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          child: Stack(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Container(
                    height: deviceHeight * 0.20,
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            alignment: Alignment.center,
//                          color: Colors.purpleAccent.withOpacity(0.1),
                            child: Image.asset(
                              'assets/images/login_header_pic.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )),
                        Positioned(
                          top: deviceHeight * 0.080,
                          right: 0,
                          left: 0,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'تاپ سالن',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: textScaleFactor * 26,
                                  fontFamily: "BFarnaz",
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Consumer<Auth>(
                    builder: (_, auth, ch) => ListTile(
                      title: Text(
                        auth.isAuth ? 'پروفایل' : 'ورود',
                        style: TextStyle(
                          fontFamily: "Iransans",
                          fontSize: textScaleFactor * 15,
                          color: textColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      trailing: Icon(
                        Icons.account_circle,
                        color: iconColor,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        auth.isAuth
                            ? Navigator.of(context)
                                .pushNamed(ProfileScreen.routeName)
                            : Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                      },
                    ),
                  ),
                  Container(
                    height: deviceHeight * 0.64,
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'خانه',
                              style: TextStyle(
                                fontFamily: "Iransans",
                                fontWeight: FontWeight.w500,
                                fontSize: textScaleFactor * 15,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              Icons.home,
                              color: iconColor,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  NavigationBottomScreen.routeName,
                                  (Route<dynamic> route) => false);
                            },
                          ),
                          ListTile(
                            title: Text(
                              'تست',
                              style: TextStyle(
                                fontFamily: "Iransans",
                                fontWeight: FontWeight.w500,
                                fontSize: textScaleFactor * 15,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              Icons.home,
                              color: iconColor,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(
                                PlaceDetailScreenTest.routeName,
                              );
                            },
                          ),
                          ListTile(
                            title: Text(
                              'ایجاد مکان های ورزشی',
                              style: TextStyle(
                                fontFamily: "Iransans",
                                fontWeight: FontWeight.w500,
                                fontSize: textScaleFactor * 15,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              Icons.search,
                              color: iconColor,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                              Navigator.of(context).pushNamed(
                                PlaceCreateScreen.routeName,
                              );
                            },
                          ),
                          ListTile(
                            title: Text(
                              'معرفی مکان ورزشی',
                              style: TextStyle(
                                fontFamily: "Iransans",
                                fontWeight: FontWeight.w500,
                                fontSize: textScaleFactor * 15,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              Icons.store,
                              color: iconColor,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                              _launchURL(
                                  'https://tapsalon.ir/%d8%ab%d8%a8%d8%aa-%d9%85%da%a9%d8%a7%d9%86-%d9%88%d8%b1%d8%b2%d8%b4%db%8c/');
                            },
                          ),
                          ListTile(
                            title: Text(
                              'درباره ما',
                              style: TextStyle(
                                fontFamily: "Iransans",
                                fontWeight: FontWeight.w500,
                                fontSize: textScaleFactor * 15,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              Icons.info,
                              color: iconColor,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                              Navigator.of(context)
                                  .pushNamed(AboutUsScreen.routeName);
                            },
                          ),
                          ListTile(
                            title: Text(
                              'خروج از حساب کاربری',
                              style: TextStyle(
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 15.0,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              Icons.power_settings_new,
                              color: iconColor,
                            ),
                            onTap: () async {
                              await Provider.of<Auth>(context, listen: false)
                                  .removeToken();
                              Navigator.of(context).pushNamed('/');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
