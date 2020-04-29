import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/user.dart';
import 'package:tapsalon_manager/provider/auth_manager.dart';
import 'package:tapsalon_manager/provider/manager_info.dart';
import 'package:tapsalon_manager/widget/en_to_ar_number_convertor.dart';
import 'login_screen_manager.dart';
import 'manager_profile_detail_tabbar.dart';

class ManagerProfileView extends StatefulWidget {
  @override
  _ManagerProfileViewState createState() => _ManagerProfileViewState();
}

class _ManagerProfileViewState extends State<ManagerProfileView> {
  var _isLoading = false;
  bool _isInit = true;

  Future<void> cashOrder() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<ManagerInfo>(context, listen: false).getUser();
    print(_isLoading.toString());

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      cashOrder();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = Provider.of<AuthManager>(context).isAuthM;

    double deviceSizeWidth = MediaQuery.of(context).size.width;
    double deviceSizeHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    User user = Provider.of<ManagerInfo>(context).user;
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
                      Navigator.of(context)
                          .pushNamed(LoginScreenManager.routeName);
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
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: deviceSizeWidth,
              height: deviceSizeHeight,
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
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: deviceSizeHeight * 0.06,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.2)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        user.fname + ' ' + user.lname,
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 12,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        'اعتبار',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 12,
                                        ),
                                      ),
                                      Text(
                                        user.wallet.isNotEmpty
                                            ? EnArConvertor().replaceArNumber(
                                                currencyFormat
                                                    .format(double.parse(
                                                        user.wallet))
                                                    .toString())
                                            : EnArConvertor()
                                                    .replaceArNumber('0') +
                                                'تومان',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 18,
                                        ),
                                      ),
                                      Text(
                                        'تومان',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ManagerProfileDetailTabBar(
                                  user: user,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          );
  }
}
