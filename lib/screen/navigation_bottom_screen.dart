import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/strings.dart';
import 'package:tapsalon_manager/provider/auth_manager.dart';
import 'package:tapsalon_manager/provider/cities.dart';
import 'package:tapsalon_manager/provider/manager_info.dart';
import 'package:tapsalon_manager/widget/badge.dart';
import 'package:tapsalon_manager/widget/select_city_dialog.dart';

import '../screen/favorite_screen.dart';
import '../screen/home_screen.dart';
import '../widget/main_drawer.dart';
import 'manager_profile/manager_profile_view.dart';
import 'notification_screen.dart';
import 'reserve_detail_screen.dart';

class NavigationBottomScreen extends StatefulWidget {
  static const routeName = '/navigationScreen';

  @override
  _NavigationBottomScreenState createState() => _NavigationBottomScreenState();
}

class _NavigationBottomScreenState extends State<NavigationBottomScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final List<Map<String, Object>> _pages = [
    {
      'page': ReserveDetailScreen(),
      'title': Strings.navReservse,
    },
    {
      'page': ReserveDetailScreen(),
      'title': Strings.naveNearby,
    },
    {
      'page': ManagerProfileView(),
      'title': Strings.navProfile,
    },
    {
      'page': HomeScreeen(),
      'title': Strings.navHome,
    },
    {
      'page': FavoriteScreen(),
      'title': Strings.naveFavorite,
    },
  ];

  int _selectedPageIndex = 2;

  void _selectBNBItem(int index) {
    setState(
      () {
        _selectedPageIndex = index;
      },
    );
  }

  bool _isInit = true;
  var _isLoading;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      try {
        await Provider.of<AuthManager>(context, listen: false)
            .getCredetialToken();
      } catch (_) {}
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppTheme.appBarColor,
          centerTitle: true,
          actions: <Widget>[
            Consumer<ManagerInfo>(
              builder: (_, notification, ch) => Badge(
                color: notification.notificationItems.length == 0
                    ? Colors.grey
                    : Colors.green,
                value: notification.notificationItems.length.toString(),
                child: ch,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(NotificationScreen.routeName);
                },
                color: AppTheme.appBarIconColor,
                icon: Icon(
                  Icons.notifications_none,
                ),
              ),
            ),
          ],
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors
                .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),
        body: _pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 1,
          selectedLabelStyle: TextStyle(
              color: AppTheme.darkText,
              fontFamily: 'Iransans',
              fontSize: MediaQuery.of(context).textScaleFactor * 10.0),
          onTap: _selectBNBItem,
          backgroundColor: AppTheme.BNbgColor,
          unselectedItemColor: AppTheme.darkText,
          selectedItemColor: AppTheme.BNbSelectedItemColor,
          currentIndex: _selectedPageIndex,
          // type: BottomNavigationBarType.fixed,

          items: [
            BottomNavigationBarItem(
              backgroundColor: AppTheme.BNbgColor,
              icon: Icon(Icons.date_range),
              title: Text(
                Strings.navReservse,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: AppTheme.BNbgColor,
              icon: Icon(Icons.near_me),
              title: Text(
                Strings.naveNearby,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: AppTheme.BNbgColor,
              icon: Icon(Icons.account_circle),
              title: Text(
                Strings.navProfile,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: AppTheme.BNbgColor,
              icon: Icon(Icons.home),
              title: Text(
                Strings.navHome,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: AppTheme.BNbgColor,
              icon: Icon(Icons.favorite),
              title: Text(
                Strings.naveFavorite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
