import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/models/places_models/place_in_send.dart';
import 'package:tapsalon_manager/models/timing.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog.dart';
import 'package:tapsalon_manager/widget/items/WeekDayRow.dart';
import 'package:tapsalon_manager/widget/items/edit_info_item.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';

import '../../provider/app_theme.dart';
import '../../provider/places.dart';

class PlaceDetailTimingEditScreen extends StatefulWidget {
  static const routeName = '/PlaceDetailTimingEditScreen';

  @override
  _PlaceDetailTimingEditScreenState createState() =>
      _PlaceDetailTimingEditScreenState();
}

class _PlaceDetailTimingEditScreenState
    extends State<PlaceDetailTimingEditScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;
  bool _isInit = true;

  Place loadedPlace;

  List<Timing> timingList = [];

  List<List<Timing>> timingListTable = [[]];

  PlaceInSend placeInSend;

  final timeExplanationController = TextEditingController();

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      timingListTable = [[], [], [], [], [], [], []];

      loadedPlace = Provider.of<Places>(context).itemPlace;

      placeInSend = convertPlace(loadedPlace);

      Provider.of<Places>(context, listen: false).placeInSend = placeInSend;

      print(timingListTable.length);

      await convertToTimingTable();

      timeExplanationController.text = loadedPlace.timings_excerpt;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timeExplanationController.dispose();

    super.dispose();
  }

  Future<void> updateTimingTable() async {
    setState(() {
      _isLoading = true;
    });

    await convertFromTimingTable().then((value) {
      Provider.of<Places>(context, listen: false).placeInSend.timings =
          timingList;
    });

//    await sendChange();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> convertFromTimingTable() async {
    timingListTable =
        Provider.of<Places>(context, listen: false).timingListTable;
    timingList.clear();
    for (int i = 0; i < timingListTable.length; i++) {
      for (int j = 0; j < timingListTable[i].length; j++) {
        timingList.add(timingListTable[i][j]);
      }
    }
  }

  Future<void> convertToTimingTable() async {
    timingList = loadedPlace.timings;

    timingListTable = [[], [], [], [], [], [], []];
    for (int i = 0; i < timingList.length; i++) {
      DateTime startTime = DateTime.parse(timingList[i].date_start);

      timingListTable[startTime.weekday - 1].add(timingList[i]);
    }
    Provider.of<Places>(context, listen: false).timingListTable =
        timingListTable;
  }

  Future<int> sendChange() async {
    setState(() {
      _isLoading = true;
    });

    int placeId =
        await Provider.of<Places>(context, listen: false).modifyPlace();

    if (placeId != 0) {
      _showLoginDialog();
    } else {}

    setState(() {
      _isLoading = false;
    });
    return placeId;
  }

  void _showLoginDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialog(
              title: 'تشکر',
              buttonText: 'خب',
              description:
                  ' تغییرات با موفقیت ثبت شد\n بعد از تایید نمایش داده خواهد شد',
            ));
  }

  PlaceInSend convertPlace(Place place) {
    PlaceInSend placeInSend;

    placeInSend = PlaceInSend(
      id: place.id,
      name: place.name,
      about: place.about,
      excerpt: place.excerpt,
      timings_excerpt: place.timings_excerpt,
      price: place.price,
      phone: place.phone,
      mobile: place.mobile,
      address: place.address,
      longitude: place.longitude,
      latitude: place.latitude,
      fields: getIdList(place.fields),
      facilities: getIdList(place.facilities),
      city: place.city.id,
      province: place.province.id,
      image: place.image.id,
      region: place.region.id,
      gallery: getIdList(place.gallery),
      placeType: place.placeType.id,
    );

    return placeInSend;
  }

  List<int> getIdList(List<dynamic> list) {
    List<int> idList = [];

    for (int i = 0; i < list.length; i++) {
      idList.add(list[i].id);
    }

    return idList;
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    loadedPlace = Provider.of<Places>(context).itemPlace;

    timingListTable = Provider.of<Places>(context).timingListTable;

    print('timingListTable' + timingListTable.length.toString());

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
              height: deviceHeight * 0.95,
              child: Stack(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: <Widget>[
                                WeekDayRow(
                                  weekDay: 6,
                                ),
                                WeekDayRow(
                                  weekDay: 7,
                                ),
                                WeekDayRow(
                                  weekDay: 1,
                                ),
                                WeekDayRow(
                                  weekDay: 2,
                                ),
                                WeekDayRow(
                                  weekDay: 3,
                                ),
                                WeekDayRow(
                                  weekDay: 4,
                                ),
                                WeekDayRow(
                                  weekDay: 5,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: EditInfoItem(
                              title: 'توضیحات زمانبندی',
                              controller: timeExplanationController,
                              keybordType: TextInputType.text,
                            ),
                          ),
                          SizedBox(
                            height: 80,
                          ),
                        ],
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
                      onPressed: () async {
                        Provider.of<Places>(context, listen: false)
                            .placeInSend
                            .timings_excerpt = timeExplanationController.text;

                        await updateTimingTable();

                        await sendChange();
                      },
                      child: Text(
                        'تایید تغییرات',
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
