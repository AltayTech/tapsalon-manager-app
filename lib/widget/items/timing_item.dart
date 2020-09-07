import 'package:flutter/material.dart';
import 'package:tapsalon_manager/models/timing.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog_select_discounted.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog_select_gender.dart';

import '../en_to_ar_number_convertor.dart';

class TimingItem extends StatelessWidget {
  const TimingItem({
    Key key,
    @required this.timing,
    @required this.dateTime,
    @required this.removeTime,
    @required this.updateStart,
    @required this.updateEnd,
    @required this.updateGender,
    @required this.updateDiscount,
  }) : super(key: key);

  final Timing timing;

  final DateTime dateTime;

  final Function removeTime;
  final Function updateStart;
  final Function updateEnd;
  final Function updateGender;
  final Function updateDiscount;

  DateTime setDataTime(TimeOfDay timeOfDay) {
    DateTime time = DateTime.now();

    time = DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour,
        timeOfDay.minute);

    return time;
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 280,
        decoration: BoxDecoration(
            color:
                timing.gender == 'male' ? Colors.blue[100] : Colors.orange[100],
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showTimePicker(
                    context: context,
                    cancelText: 'لغو',
                    confirmText: 'تایید',
                    initialTime: TimeOfDay(
                        hour: (DateTime.parse(timing.date_start)).hour,
                        minute: (DateTime.parse(timing.date_start)).minute),
                    builder: (BuildContext context, Widget child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child,
                      );
                    },
                  ).then((value) {
                    DateTime startTime = setDataTime(value);
                    updateStart(startTime);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        EnArConvertor().replaceArNumber(
                          '${(DateTime.parse(timing.date_start)).hour}:${(DateTime.parse(timing.date_start)).minute}',
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showTimePicker(
                    context: context,
                    cancelText: 'لغو',
                    confirmText: 'تایید',
                    initialTime: TimeOfDay(
                        hour: (DateTime.parse(timing.date_end)).hour,
                        minute: (DateTime.parse(timing.date_end)).minute),
                    builder: (BuildContext context, Widget child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child,
                      );
                    },
                  ).then((value) {
                    DateTime endTime = setDataTime(value);
                    updateEnd(endTime);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(

                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        EnArConvertor().replaceArNumber(
                          '${(DateTime.parse(timing.date_end)).hour}:${(DateTime.parse(timing.date_end)).minute}',
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await showDialog(
                          context: context,
                          builder: (ctx) => CustomDialogSelectGender())
                      .then((value) {
                    updateGender(value);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(

                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        timing.gender == 'male' ? 'آقایان' : 'خانم ها',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await showDialog(
                          context: context,
                          builder: (ctx) => CustomDialogSelectDiscounted())
                      .then((value) {
                    updateDiscount(value);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(

                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        EnArConvertor().replaceArNumber(
                          '% ${timing.discount}',
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: removeTime,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Icon(Icons.clear),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
