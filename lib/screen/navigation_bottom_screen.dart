import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tapsalon_manager/screen/calendar_screen.dart';

import '../provider/app_theme.dart';
import '../provider/strings.dart';
import '../screen/home_screen.dart';
import '../screen/map_screen.dart';
import '../screen/user_profile/profile_view.dart';
import '../widget/dialogs/custom_dialog_enter.dart';
import '../widget/main_drawer.dart';

class NavigationBottomScreen extends StatefulWidget {
  static const routeName = '/NavigationBottomScreen';

  @override
  _NavigationBottomScreenState createState() => _NavigationBottomScreenState();
}

class _NavigationBottomScreenState extends State<NavigationBottomScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DateTime currentBackPressTime;

  final List<Map<String, Object>> _pages = [
    {
      'page': CalendarScreen(),
      'title': Strings.naveCalendar,
    },
    {
      'page': HomeScreen(),
      'title': Strings.navHome,
    },
    {
      'page': ProfileView(),
      'title': Strings.navProfile,
    }
  ];

  int _selectedPageIndex = 1;

  void _selectBNBItem(int index) {
    setState(
      () {
        _selectedPageIndex = index;
      },
    );
  }

  void _showLoginDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialogEnter(
              title: 'ورود',
              buttonText: 'صفحه ورود ',
              description: 'برای ادامه باید وارد شوید',
            ));
  }

  Future<bool> onWillPop() async {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      Navigator.pop(context);

      return false;
    } else {
      DateTime now = DateTime.now();

      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;

        FToast(context).showToast(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "برای خروج دوباره فشار دهید",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppTheme.black,
                    fontFamily: 'Iransans',
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).textScaleFactor * 14.0),
              ),
            ),
          ),
        );

        return Future.value(false);
      }

      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: AppTheme.appBarColor,
            elevation: 0,
            iconTheme: IconThemeData(color: AppTheme.appBarIconColor),
          ),
          drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: AppTheme.white,
            ),
            child: MainDrawer(),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: _pages[_selectedPageIndex]['page'],
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 2,
            selectedLabelStyle: TextStyle(
                color: AppTheme.darkText,
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 10.0),
            onTap: _selectBNBItem,
            backgroundColor: AppTheme.white,
            unselectedItemColor: AppTheme.grey,
            selectedItemColor: AppTheme.BNbSelectedItemColor,
            currentIndex: _selectedPageIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                backgroundColor: AppTheme.white,
                icon: Icon(
                  Icons.calendar_today,
                ),
                title: Text(
                  Strings.naveCalendar,
                ),
              ),
              BottomNavigationBarItem(
                backgroundColor: AppTheme.white,
                icon: Icon(Icons.home),
                title: Text(
                  Strings.navHome,
                ),
              ),
              BottomNavigationBarItem(
                backgroundColor: AppTheme.white,
                icon: Icon(Icons.account_circle),
                title: Text(
                  Strings.navProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
