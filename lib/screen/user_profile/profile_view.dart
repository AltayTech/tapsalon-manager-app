import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/screen/user_profile/user_detail_info_screen.dart';

import '../../provider/app_theme.dart';
import '../../provider/auth.dart';
import '../../provider/user_info.dart';
import '../../screen/user_profile/login_screen.dart';
import 'user_detail_reserve_screen.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;
  bool _isInit = true;
  TabController _tabController;

  Future<void> getUser() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<UserInfo>(context, listen: false).getUser();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = Provider.of<Auth>(context).isAuth;

    double deviceSizeWidth = MediaQuery.of(context).size.width;
    double deviceSizeHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return !isLogin
        ? Container(
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('شما وارد نشده اید'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'ورود به اکانت کاربری',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  )
                ],
              ),
            ),
          )
        : Container(
            width: deviceSizeWidth,
            height: deviceSizeHeight,
            color: AppTheme.white,
            child: Align(
              alignment: Alignment.center,
              child: _isLoading
                  ? SpinKitFadingCircle(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index.isEven
                                ? AppTheme.spinerColor
                                : AppTheme.spinerColor,
                          ),
                        );
                      },
                    )
                  : SingleChildScrollView(
                      child: Container(
                        width: deviceSizeWidth,
                        height: deviceSizeHeight,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: deviceSizeWidth * 0.6,
                                child: Image.asset(
                                  'assets/images/login_header_pic.png',
                                  width: deviceSizeWidth,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: deviceSizeWidth * 0.2,
                                left: 0,
                                right: 0,
                                child: Text(
                                  'حساب من',
                                  style: TextStyle(
                                    fontFamily: "Iransans",
                                    fontWeight: FontWeight.w600,
                                    fontSize: textScaleFactor * 22,
                                    color: AppTheme.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Positioned(
                                  top: deviceSizeWidth * 0.53,
                                  height: deviceSizeWidth * 0.6,
                                  right: 0,
                                  left: 0,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      width: deviceSizeWidth * 0.9,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.grey
                                                  .withOpacity(0.3),
                                              blurRadius: 6,
                                              spreadRadius: 3,
                                              offset: Offset(
                                                0,
                                                0,
                                              ),
                                            ),
                                          ],
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12,
                                            bottom: 12,
                                            left: 8,
                                            right: 8),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: <Widget>[
                                            ListTile(
                                              leading: Icon(
                                                Icons.account_circle,
                                                color: Colors.blue,
                                              ),
                                              title: Text(
                                                'اطلاعات کاربری',
                                                style: TextStyle(
                                                  fontFamily: "Iransans",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:
                                                      textScaleFactor * 16,
                                                  color: AppTheme.black,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              trailing: Icon(
                                                Icons.arrow_forward_ios,
                                                color: AppTheme.grey
                                                    .withOpacity(0.5),
                                                size: 20,
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    UserDetailInfoScreen
                                                        .routeName,
                                                    arguments: 0);
                                              },
                                            ),

                                            ListTile(
                                              leading: Icon(
                                                Icons.bookmark,
                                                color: Colors.blue,
                                              ),
                                              title: Text(
                                                'رزروها',
                                                style: TextStyle(
                                                  fontFamily: "Iransans",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:
                                                      textScaleFactor * 16,
                                                  color: AppTheme.black,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              trailing: Icon(
                                                Icons.arrow_forward_ios,
                                                color: AppTheme.grey
                                                    .withOpacity(0.5),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    UserDetailReserveScreen
                                                        .routeName,
                                                    arguments: 0);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          );
  }
}
