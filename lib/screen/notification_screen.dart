import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/searchDetails.dart';
import 'package:tapsalon_manager/provider/auth_manager.dart';
import 'package:tapsalon_manager/provider/manager_info.dart';
import 'package:tapsalon_manager/widget/en_to_ar_number_convertor.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';
import 'package:tapsalon_manager/widget/notification_item.dart';
import '../models/notification.dart' as notification;


import '../widget/custom_dialog_enter.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notification_screen';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  bool _isInit = true;
  var _isLoading;
  List<notification.Notification> loadedNotifications = [];
  List<notification.Notification> loadedNotificationstolist = [];

  SearchDetails searchDetails;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      searchItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    searchDetails =
        Provider.of<ManagerInfo>(context).notificationSearchDetails;
    await Provider.of<ManagerInfo>(context, listen: false).getNotification();


    loadedNotifications.clear();
    loadedNotifications =
        Provider.of<ManagerInfo>(context, listen: false).notificationItems;
    loadedNotificationstolist.addAll(loadedNotifications);
    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  void _showLogindialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialogEnter(
              title: 'ورود',
              buttonText: 'صفحه ورود ',
              description: 'برای ادامه باید وارد شوید',
            ));
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    bool isLogin = Provider.of<AuthManager>(context).isAuthM;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Builder(builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: <Widget>[
                Container(
                  color: Color(0xffF9F9F9),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: deviceHeight * 0.07,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey, width: 0.2)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'تعداد: ' +
                                    EnArConvertor()
                                        .replaceArNumber(
                                            searchDetails.total != null
                                                ? searchDetails.total.toString()
                                                : '0')
                                        .toString(),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: Colors.grey, width: 0.2)),
                          height: deviceHeight * 0.68,
                          child: (loadedNotificationstolist.length != 0)
                              ? ListView.builder(
                                  key: listKey,
                                  itemCount: loadedNotificationstolist.length,
                                  itemBuilder: (ctx, i) => NotificationItem(
                                    notification: loadedNotificationstolist[i],
                                  ),
                                )
                              : Center(child: Text('نوتیفیکیشنی موجود نیست')),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
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
                            : Container()))
              ],
            ),
          ),
        );
      }),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}
