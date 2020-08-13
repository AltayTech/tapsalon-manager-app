import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/places_models/place_in_search.dart';
import 'package:tapsalon_manager/models/searchDetails.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/provider/strings.dart';
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
  var _searchTextController = TextEditingController();
  int page = 1;

  SearchDetails searchDetails;

  List<PlaceInSearch> loadedPlaces = [];
  List<PlaceInSearch> loadedPlacesToList = [];

  ScrollController _scrollController = new ScrollController();

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
    print('deviceHeight' + deviceHeight.toString());
    print('deviceWidth' + deviceWidth.toString());

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
//                height: deviceHeight * 0.18,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: AppTheme.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MainTopicItem(
                            number: 1,
                            title: Strings.titleSalons,
                            icon: 'assets/images/main_page_salon_ic.png',
                            bgColor: AppTheme.bg,
                            iconColor: AppTheme.mainPageColor,
                          ),
                          MainTopicItem(
                            number: 1,
                            title: Strings.titlClubs,
                            icon: 'assets/images/main_page_gym_ic.png',
                            bgColor: AppTheme.bg,
                            iconColor: AppTheme.mainPageColor,
                          ),
                          MainTopicItem(
                            number: 1,
                            title: Strings.titleEntertainment,
                            icon: 'assets/images/main_page_ent_ic.png',
                            bgColor: AppTheme.bg,
                            iconColor: AppTheme.mainPageColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: deviceHeight * 0.67,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemCount: loadedPlacesToList.length,
                      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                        value: loadedPlacesToList[i],
                        child: Container(
                          height: 280,
                          child: PlaceItem(
                            place: loadedPlacesToList[i],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                : Container(),
          ),
        ),
      ],
    );
  }
}
