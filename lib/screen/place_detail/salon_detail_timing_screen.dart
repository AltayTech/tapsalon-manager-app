import 'package:flutter/material.dart';
import 'package:tapsalon_manager/classes/table_sticky_header.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/place.dart';
class SalonDetailTimingScreen extends StatefulWidget {
  final Place place;

  SalonDetailTimingScreen({this.place});

  @override
  _SalonDetailTimingScreenState createState() =>
      _SalonDetailTimingScreenState();
}

class _SalonDetailTimingScreenState extends State<SalonDetailTimingScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 5),
            child: Text(
              'زمان بندی',
              style: TextStyle(
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'جهت رزرو بر روی تایم های آزاد کلیک کرده و هزینه و مدت زمان را در پایین مشاهده کنید',
              style: TextStyle(
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 9.0,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 3),
          Container(
            height: 250,
            child: StickyHeadersTable(
              columnsLength: 12,
              rowsLength: 7,
              columnsTitleBuilder: (i) => Text(
                2.toString(),
                style: TextStyle(
                  fontFamily: 'Iransans',
                  fontSize: MediaQuery.of(context).textScaleFactor * 8.0,
                ),
              ),
              rowsTitleBuilder: (i) => Card(
                elevation: 2,
                child: Container(
                  height: 50,
                  width: 60,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'شنبه',
                        style: TextStyle(
                          color: AppTheme.textColorMainColor,
                          fontFamily: 'Iransans',
                          fontSize:
                              MediaQuery.of(context).textScaleFactor * 8.0,
                        ),
                      ),
                      Text(
                        '122',
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          fontSize:
                              MediaQuery.of(context).textScaleFactor * 8.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              contentCellBuilder: (i, j) => ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Container(
                  height: 27,
                  width: 37,
//                  color: widget.salon.times[i][j] == '1'
//                      ? Colors.green
//                      : Colors.red,
                  child: (Stack(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'd',
                          style: TextStyle(
                            fontFamily: 'Iransans',
                            fontSize:
                                MediaQuery.of(context).textScaleFactor * 8.0,
                          ),
                        ),
                        onPressed: () {
//                          changenumber(i, j);
                          print('tapped');
                        },
                      ),
                    ],
                  )),
                ),
              ),
              legendCell: Text(
                'دی 96',
                style: TextStyle(
                  color: AppTheme.textColorMainColor,
                  fontFamily: 'Iransans',
                  fontSize: MediaQuery.of(context).textScaleFactor * 9.0,
                ),
              ),
              cellDimensions: CellDimensions(
                  contentCellHeight: 50,
                  contentCellWidth: 60,
                  stickyLegendHeight: 50,
                  stickyLegendWidth: 60),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: AppTheme.appBarColor,
                width: double.infinity,
                child: FlatButton(
                  color: AppTheme.appBarColor,
                  onPressed: () {},
                  child: Text(
                    'پرداخت و رزرو',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
