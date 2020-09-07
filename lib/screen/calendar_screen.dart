import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  static const routeName = '/CalendarScreen';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    print(deviceHeight.toString());
    print(deviceWidth.toString());
    print(MediaQuery.of(context).size.toString());
    print(MediaQuery.of(context).devicePixelRatio.toString());
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height:
                  deviceHeight * 0.93 - Scaffold.of(context).appBarMaxHeight,
              width: deviceWidth,
              child: Column(
                children: [
                  Expanded(
                    child: TableCalendar(
                      locale: 'fa_IR',
//                      startDay: DateTime.now(),
                      calendarStyle: CalendarStyle(),
                      headerVisible: true,
                      weekendDays: [5],
                      startingDayOfWeek: StartingDayOfWeek.saturday,

                      calendarController: _calendarController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
