import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/places_models/place_in_search.dart';
import 'package:tapsalon_manager/models/searchDetails.dart';
import 'package:tapsalon_manager/models/user_models/manager_stats.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/provider/user_info.dart';
import 'package:tapsalon_manager/widget/en_to_ar_number_convertor.dart';
import 'package:tapsalon_manager/widget/items/main_topic_item.dart';
import 'package:tapsalon_manager/widget/items/place_item.dart';

import '../provider/places.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;

  var _isLoading;

  int page = 1;

  SearchDetails searchDetails;

  List<PlaceInSearch> loadedPlaces = [];

  List<PlaceInSearch> loadedPlacesToList = [];

  ScrollController _scrollController = new ScrollController();

  ManagerStats managerStats = ManagerStats(
    places: 0,
    comments: 0,
    likes: 0,
    visits: 0,
  );

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page = page + 1;

        Provider.of<Places>(context, listen: false).sPage = page;

        searchItems();
      }
    });

    super.initState();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<UserInfo>(context, listen: false).getManagerStat();

    managerStats = Provider.of<UserInfo>(context, listen: false).managerStats;

    await Provider.of<Places>(context, listen: false).searchItem();

    loadedPlaces.clear();

    loadedPlaces = Provider.of<Places>(context, listen: false).items;

    loadedPlacesToList.addAll(loadedPlaces);

    searchDetails =
        Provider.of<Places>(context, listen: false).placeSearchDetails;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Places>(context, listen: false).sPage = page;

      await searchItems();

      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, bottom: 4, left: 4),
                          child: MainTopicItem(
                            number: managerStats.places,
                            title: 'مکان',
                            icon: 'assets/images/main_page_place_ic.png',
                            bgColor: AppTheme.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MainTopicItem(
                            number: managerStats.comments,
                            title: 'نظر',
                            icon: 'assets/images/main_page_comment_ic.png',
                            bgColor: AppTheme.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MainTopicItem(
                            number: managerStats.visits,
                            title: 'بازدید',
                            icon: 'assets/images/main_page_visit_ic.png',
                            bgColor: AppTheme.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, bottom: 4, right: 4),
                          child: MainTopicItem(
                            number: managerStats.likes,
                            title: 'لایک',
                            icon: 'assets/images/main_page_like_ic.png',
                            bgColor: AppTheme.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'مکان های شما',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: textScaleFactor * 16.0,
                        ),
                      ),
                      Text(
                        EnArConvertor().replaceArNumber(
                            loadedPlacesToList.length.toString()),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: textScaleFactor * 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: deviceHeight * 0.6,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: loadedPlacesToList.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: loadedPlacesToList[i],
                      child: Container(
                        height: 240,
                        child: PlaceItem(
                          place: loadedPlacesToList[i],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                : Container(),
          ),
        ),
      ],
    );
  }
}
