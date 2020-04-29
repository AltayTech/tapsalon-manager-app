import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/complex.dart';
import 'package:tapsalon_manager/screen/complex_detail/complex_detail_add_place.dart';
import 'package:tapsalon_manager/widget/place_item.dart';

class ComplexDetailPlaceListScreen extends StatelessWidget {
  final Complex complex;

  ComplexDetailPlaceListScreen({this.complex});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'لیست سالن',
                style: TextStyle(
                  fontFamily: 'Iransans',
                  fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
                ),
              ),
              FittedBox(
                child: FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      ComplexDetailAddPlace.routeName,
                      arguments: {
                        'complexId': complex.id,
                      },
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                      Text(
                        'اضافه کردن',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: complex.placeList.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: complex.placeList[i],
              child: Container(
                height: deviceHeight * 0.3,
                child: PlaceItem(
                  place: complex.placeList[i],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
