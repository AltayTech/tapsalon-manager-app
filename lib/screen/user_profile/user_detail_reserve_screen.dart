import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/user_models/user.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/provider/user_info.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';

class UserDetailReserveScreen extends StatefulWidget {
  static const routeName = '/UserDetailReserveScreen';

  final User user;

  UserDetailReserveScreen({this.user});

  @override
  _UserDetailReserveScreenState createState() =>
      _UserDetailReserveScreenState();
}

class _UserDetailReserveScreenState extends State<UserDetailReserveScreen> {
  User user;
  var _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      cashOrder();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> cashOrder() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<UserInfo>(context, listen: false).getUser();
    user = Provider.of<UserInfo>(context, listen: false).user;

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appBarColor,
          elevation: 0,
          iconTheme: IconThemeData(color: AppTheme.appBarIconColor),

        ),
        endDrawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: AppTheme
                .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),
        body: _isLoading
            ? Align(
                alignment: Alignment.center,
                child: SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index.isEven ? Colors.grey : Colors.grey,
                      ),
                    );
                  },
                ),
              )
//            : UserDetailReserveView(user: user,),
            : Center(
              child: Container(
                  width: deviceWidth * 0.75,
                  child: Text(
                    'فعلا امکان روزرو آنلاین مکان ها وجود ندارد برای رزرو سالن ها میتوانید با شماره تماس قرارد داده شده در هر سالن تماس بگیرید',
                    softWrap: true,
                    style: TextStyle(
                        color: AppTheme.black,
                        fontFamily: 'Iransans',
                        fontSize: textScaleFactor * 16.0),
                  ),
                ),
            ),
      ),
    );
  }
}
