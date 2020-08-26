import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/models/timing.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/provider/places.dart';

import 'timing_item.dart';

class WeekDayRow extends StatefulWidget {
  const WeekDayRow({
    Key key,
    @required this.weekDay,
  }) : super(key: key);

  final int weekDay;

  @override
  _WeekDayRowState createState() => _WeekDayRowState();
}

class _WeekDayRowState extends State<WeekDayRow> {
  int dayIndex;

  List<List<Timing>> timingListTable = [[]];

  Place loadedPlace;

  String getWeekName() {
    String weekDayName = 'شنبه';

    List<String> weekDays = [
      'شنبه',
      'یکشنبه',
      'دوشنبه',
      'سه شنبه',
      'چهارشنبه',
      'پنج شنبه',
      'جمعه',
    ];

    weekDayName = weekDays[widget.weekDay - 1];

    return weekDayName;
  }

  @override
  void didChangeDependencies() {
    dayIndex = widget.weekDay - 1;

    super.didChangeDependencies();
  }

  Future<void> createTimingItem() {
    Provider.of<Places>(context, listen: false).timingListTable[dayIndex].add(
          Timing(
            id: null,
            discount: 0,
            reservable: 1,
            gender: 'male',
            date_start: DateTime(2020, 1, widget.weekDay + 3, 10).toString(),
            date_end: DateTime(2020, 1, widget.weekDay + 3, 20).toString(),
          ),
        );
    setState(() {});
  }

  Future<void> removeTimingItem(int index) {
    Provider.of<Places>(context, listen: false)
        .timingListTable[dayIndex]
        .removeAt(index);
    setState(() {});
  }

  Future<void> updateStartTime(DateTime startTime, int index) {
    Provider.of<Places>(context, listen: false)
        .timingListTable[dayIndex][index]
        .date_start = startTime.toString();
    setState(() {});
  }

  Future<void> updateEndTime(DateTime endTime, int index) {
    Provider.of<Places>(context, listen: false)
        .timingListTable[dayIndex][index]
        .date_end = endTime.toString();
    setState(() {});
  }

  Future<void> updateGender(String gender, int index) {
    Provider.of<Places>(context, listen: false)
        .timingListTable[dayIndex][index]
        .gender = gender;
    setState(() {});
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

    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5, left: 10, top: 1, bottom: 4),
          child: Container(
            width: 50,
            child: Text(
              getWeekName(),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Iransans',
                color: AppTheme.grey,
                fontSize: textScaleFactor * 14.0,
              ),
            ),
          ),
        ),
        Container(
          width: deviceWidth * 0.80,
          child: SingleChildScrollView(
            primary: true,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 60,
//                                        width: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: timingListTable[dayIndex].length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return TimingItem(
                        timing: timingListTable[dayIndex][index],
                        dateTime: DateTime(2020, 1, dayIndex + 4),
                        removeTime: () {
                          removeTimingItem(index);
                        },
                        updateStart: (value) {
                          updateStartTime(value, index);
                        },
                        updateEnd: (value) {
                          updateEndTime(value, index);
                        },
                        updateGender: (value) {
                          updateGender(value, index);
                        },
                      );
                    },
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    createTimingItem();
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
