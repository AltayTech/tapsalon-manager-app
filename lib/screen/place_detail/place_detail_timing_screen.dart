import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/classes/timing_table.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/provider/places.dart';
import 'package:tapsalon_manager/screen/place_detail/place_detail_timing_edit_screen.dart';

import '../../provider/app_theme.dart';

class PlaceDetailTimingScreen extends StatefulWidget {

  @override
  _PlaceDetailTimingScreenState createState() =>
      _PlaceDetailTimingScreenState();
}

class _PlaceDetailTimingScreenState extends State<PlaceDetailTimingScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;
  bool _isInit = true;

  Place loadedPlace;

  double h;
  double w;

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
//    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
//    final placeId = arguments != null ? arguments['placeId'] : 0;
//    title = arguments != null ? arguments['name'] : '';
//    imageUrl = arguments != null ? arguments['imageUrl'] : '';
//    stars = arguments != null ? arguments['stars'] : '';
//
//    await Provider.of<Places>(context, listen: false).retrievePlace(placeId);
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
    loadedPlace = Provider.of<Places>(context).itemPlace;

    return _isLoading
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
        : Stack(
          children: [
            Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: deviceWidth * 0.93,
                          height: deviceWidth * 0.13,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 3, top: 4, bottom: 4),
                                child: Text(
                                  'زمانبندی',
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    color: AppTheme.black,
                                    fontSize: textScaleFactor * 18.0,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: deviceWidth * 0.05,
                                width: deviceWidth * 0.05,
                                decoration: BoxDecoration(
                                  color: AppTheme.femaleColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 5, left: 10, top: 1, bottom: 4),
                                child: Text(
                                  'خانم ها',
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    color: AppTheme.grey,
                                    fontSize: textScaleFactor * 16.0,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: deviceWidth * 0.05,
                                width: deviceWidth * 0.05,
                                decoration: BoxDecoration(
                                  color: AppTheme.maleColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 5, left: 10, top: 1, bottom: 4),
                                child: Text(
                                  'آقایان',
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    color: AppTheme.grey,
                                    fontSize: textScaleFactor * 16.0,
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Container(
                          width: deviceWidth,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0, left: 16),
                            child: Container(
                              width: deviceWidth * 0.9,
                              child: TimingTable(
                                timeStep: 60,
                                headerHeight: 50,
                                timingList: loadedPlace.timings,
                                rowHeight: 40,
                                titleWidth: 70,
                                initialHour: 9,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16, top: 8),
                          child: Container(
                            width: deviceWidth * 0.93,
                            decoration: BoxDecoration(
                                color: AppTheme.white,
                                border: Border.all(width: 5, color: AppTheme.bg),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 8.0, top: 16),
                                  child: Container(
                                    width: deviceWidth * 0.8,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 1,
                                              left: 3.0,
                                              top: 1,
                                              bottom: 4),
                                          child: Icon(
                                            Icons.star,
                                            color: AppTheme.iconColor,
                                            size: 25,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5,
                                              left: 10,
                                              top: 4,
                                              bottom: 1),
                                          child: Text(
                                            'توضیحات',
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: 'Iransans',
                                              color: AppTheme.grey,
                                              fontSize: textScaleFactor * 16.0,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 16.0,
                                  ),
                                  child: Container(
                                    width: deviceWidth * 0.8,
                                    decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        border: Border.all(
                                            width: 5, color: AppTheme.white),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        loadedPlace.timings_excerpt != ''
                                            ? loadedPlace.timings_excerpt
                                            : 'توضیحی ارائه نشده است',
                                        style: TextStyle(
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14.0,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 20,
              left: 20,
              bottom: 20,
              height: 60,
              child: RaisedButton(
                color: AppTheme.buttonColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      PlaceDetailTimingEditScreen.routeName,
                      arguments: {
                        'place': loadedPlace,
                      });
                },
                child: Text(
                  'ویرایش زمان بندی',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Iransans',
                    color: AppTheme.white,
                    fontSize: textScaleFactor * 14.0,
                  ),
                ),
              ),
            ),
          ],
        );
  }
}
