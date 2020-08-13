import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../models/city.dart';
import '../provider/app_theme.dart';
import '../provider/cities.dart';
import '../provider/strings.dart';
import '../screen/home_screen.dart';
import '../screen/map_screen.dart';
import '../screen/user_profile/profile_view.dart';
import '../widget/dialogs/custom_dialog_enter.dart';
import '../widget/main_drawer.dart';
import '../widget/dialogs/select_city_dialog.dart';

class NavigationBottomScreen extends StatefulWidget {
  static const routeName = '/NavigationBottomScreen';

  @override
  _NavigationBottomScreenState createState() => _NavigationBottomScreenState();
}

class _NavigationBottomScreenState extends State<NavigationBottomScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var init = true;
  DateTime currentBackPressTime;

  final List<Map<String, Object>> _pages = [
    {
      'page': HomeScreen(),
      'title': Strings.navHome,
    },
    {
      'page': MapScreen(),
      'title': Strings.naveNearby,
    },

    {
      'page': ProfileView(),
      'title': Strings.navProfile,
    }
  ];

  int _selectedPageIndex = 0;

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

  @override
  void didChangeDependencies() async {
    if (init) {
      await Provider.of<Cities>(context, listen: false).getSelectedCity();
      City selectedCity =
          Provider.of<Cities>(context, listen: false).selectedCity;
      if (selectedCity.id == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showDialog<String>(
              context: context, builder: (ctx) => SelectCityDialog());
        });
      }
      init = false;
    }
    super.didChangeDependencies();
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
    var currencyFormat = intl.NumberFormat.decimalPattern();

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
            actions: <Widget>[
              Consumer<Cities>(
                builder: (_, cities, ch) => Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => SelectCityDialog());
                    },
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            cities.selectedCity.name,
                            softWrap: true,
                            style: TextStyle(
                                color: AppTheme.black,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 12.0),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
            items: [
              BottomNavigationBarItem(
                backgroundColor: AppTheme.white,
                icon: Icon(Icons.home),
                title: Text(
                  Strings.navHome,
                ),
              ),
              BottomNavigationBarItem(
                backgroundColor: AppTheme.white,
                icon: Icon(
                  Icons.map,
                ),
                title: Text(
                  Strings.naveNearby,
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
