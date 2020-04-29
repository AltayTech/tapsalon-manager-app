import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/provider/auth_manager.dart';
import 'package:tapsalon_manager/screen/about_us_screen.dart';
import 'package:tapsalon_manager/screen/contact_with_us_screen.dart';
import 'package:tapsalon_manager/screen/favorite_screen.dart';
import 'package:tapsalon_manager/screen/manager_profile/login_screen_manager.dart';
import 'package:tapsalon_manager/screen/manager_profile/manager_profile_screen.dart';
import 'package:tapsalon_manager/screen/rules_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    Color textColor = Colors.white;
    Color iconColor = Colors.white38;
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
              ),

              Wrap(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
//                      Image.asset(
////                        'assets/images/drawer_header.jpg',
////                        fit: BoxFit.fill,
////                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.center,
                        color: Colors.purpleAccent.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'تاپ سالن',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Consumer<AuthManager>(
                    builder: (_, auth, ch) => ListTile(
                      title: Text(
                        auth.isAuthM ? 'پروفایل مدیر' : 'ورود مدیر',
                        style: TextStyle(
                          fontFamily: "Iransans",
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
                        auth.isAuthM
                            ? Navigator.of(context)
                                .pushNamed(ManagerProfileScreen.routeName)
                            : Navigator.of(context)
                                .pushNamed(LoginScreenManager.routeName);
                      },
                    ),
                  ),
                  Divider(
                    thickness: 2,
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
                                fontSize: 16,
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

                              Navigator.of(context)
                                  .pushNamed('/navigationScreen');
                            },
                          ),
                          ListTile(
                            title: Text(
                              'مجموعه های مورد علاقه',
                              style: TextStyle(
                                fontFamily: "Iransans",
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              Icons.favorite,
                              color: iconColor,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                              Navigator.of(context)
                                  .pushNamed(FavoriteScreen.routeName);
                            },
                          ),
                          ListTile(
                            title: Text(
                              'راهنما',
                              style: TextStyle(
                                fontFamily: "Iransans",
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              Icons.help,
                              color: iconColor,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                              Navigator.of(context)
                                  .pushNamed(RulesScreen.routeName);
                            },
                          ),
                          ListTile(
                            title: Text(
                              'تماس با ما',
                              style: TextStyle(
                                fontFamily: "Iransans",
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              Icons.contact_phone,
                              color: iconColor,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                              Navigator.of(context)
                                  .pushNamed(ContactWithUs.routeName);
                            },
                          ),
                          ListTile(
                            title: Text(
                              'درباره ما',
                              style: TextStyle(
                                fontFamily: "Iransans",
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              Icons.account_balance,
                              color: iconColor,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                              Navigator.of(context)
                                  .pushNamed(AboutUsScreen.routeName);
                            },
                          ),
                          Divider(
                            height: 1,
                            color: AppTheme.grey.withOpacity(0.6),
                          ),
                          ListTile(
                            title: Text(
                              'خروج',
                              style: TextStyle(
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 13.0,
                                color: textColor,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              Icons.power_settings_new,
                              color: Colors.red,
                            ),
                            onTap: () async {
//                              Provider.of<CustomerInfo>(context).customer =
//                                  Provider.of<CustomerInfo>(context)
//                                      .customer_zero;
//
                              Provider.of<AuthManager>(context, listen: false)
                                  .tokenM = '';

                              await Provider.of<AuthManager>(context,
                                      listen: false)
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
//        ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black54,
                  child: Column(
                    children: <Widget>[
                      Divider(
                        height: 1,
                        color: AppTheme.grey.withOpacity(0.6),
                      ),
                      Text(
                        'طراحی شده در تبریزاپس ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          color: textColor,
                          fontSize: textScaleFactor * 11.0,
                        ),
                      ),
                      Text(
                        'www.tabrizapps.ir',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          color: Colors.green,
                          fontSize: textScaleFactor * 11.0,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
