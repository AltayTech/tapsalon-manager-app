import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/image.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/provider/auth.dart';
import 'package:tapsalon_manager/screen/place_detail/place_detail_info_edit_screen.dart';
import 'package:tapsalon_manager/screen/place_detail/place_detail_info_screen.dart';

import '../../provider/app_theme.dart';
import '../../provider/places.dart';
import '../../widget/main_drawer.dart';

class PlaceDetailScreen extends StatefulWidget {
  static const routeName = '/PlaceDetailScreen';

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading;

  bool _isInit = true;

  Place loadedPlace;

  int _current = 0;

  List<ImageObj> gallery = [];

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);

    _tabController.addListener(_handleTabSelection);

    super.initState();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      int tabIndex = 0;
      _tabController.index = tabIndex;

      ImageObj placeDefaultImage =
          Provider.of<Places>(context, listen: false).placeDefaultImage;
      var gymDefaultImage =
          Provider.of<Places>(context, listen: false).gymDefaultImage;
      var entDefaultImage =
          Provider.of<Places>(context, listen: false).entDefaultImage;

      await searchItems();

      if (loadedPlace.gallery.length < 1) {
        gallery.clear();
        gallery.add(loadedPlace.placeType.id == 2
            ? gymDefaultImage
            : loadedPlace.placeType.id == 4
                ? entDefaultImage
                : placeDefaultImage);
      } else {
        gallery = loadedPlace.gallery;
      }

      setState(() {});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final placeId = arguments != null ? arguments['placeId'] : 0;

    await Provider.of<Places>(context, listen: false).retrievePlace(placeId);
    loadedPlace = Provider.of<Places>(context, listen: false).itemPlace;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    bool isLogin = Provider.of<Auth>(context, listen: false).isAuth;
    final List<Tab> myTabs = <Tab>[
      Tab(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '??????????????',
            style: TextStyle(
                fontFamily: 'Iransans', fontSize: textScaleFactor * 16.0),
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '????????????????',
            style: TextStyle(
                fontFamily: 'Iransans', fontSize: textScaleFactor * 16.0),
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '??????????',
            style: TextStyle(
                fontFamily: 'Iransans', fontSize: textScaleFactor * 16.0),
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '??????????????',
            style: TextStyle(
                fontFamily: 'Iransans', fontSize: textScaleFactor * 16.0),
          ),
        ),
      ),
    ];
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: _isLoading
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
          : Container(
              height: deviceHeight * 0.9,
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TabBar(
                        indicator: BoxDecoration(
                          color: AppTheme.white,
                        ),
                        indicatorWeight: 0,
                        unselectedLabelColor: AppTheme.grey,
                        labelColor: AppTheme.black,
                        labelPadding: EdgeInsets.only(top: 2, left: 4),
                        labelStyle: TextStyle(
                          fontFamily: 'Iransans',
                          fontWeight: FontWeight.w500,
                          fontSize: textScaleFactor * 15.0,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                        controller: _tabController,
                        tabs: myTabs),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        PlaceDetailInfoScreen(loadedPlace),
                        Container(
                          child: Text('2'),
                        ),
                        Container(
                          child: Text('3'),
                        ),
                        Container(
                          child: Text('4'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(PlaceDetailInfoEditScreen.routeName, arguments: {
            'place': loadedPlace,
          });
        },
        backgroundColor: AppTheme.buttonColor,
        child: Icon(
          Icons.check,
          color: AppTheme.white,
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors.white),
        child: MainDrawer(),
      ),
    );
  }
}
