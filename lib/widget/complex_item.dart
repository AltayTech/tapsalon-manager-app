import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tapsalon_manager/models/complex_search.dart';
import 'package:tapsalon_manager/provider/manager_info.dart';
import 'package:tapsalon_manager/screen/complex_detail/complex_detail_screen.dart';

import 'badge.dart';

class ComplexItem extends StatelessWidget {
  final ComplexSearch loadedComplex;

  ComplexItem({this.loadedComplex});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) => InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ComplexDetailScreen.routeName, arguments: {
            'complex': loadedComplex,

          });
        },
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: constraint.maxWidth * 0.3,
                height: constraint.maxHeight,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/tapsalon_icon_200.png'),
                  image: NetworkImage(loadedComplex.featured.url.thumb.toString()),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: constraint.maxHeight,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: constraint.maxWidth * 0.3,
                              child: Text(
                                loadedComplex.name,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Iransans',
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          12.0,
                                ),
                              ),
                            ),
                            Container(
                              width: constraint.maxWidth * 0.3,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: SmoothStarRating(
                                    allowHalfRating: false,
                                    onRatingChanged: (v) {},
                                    starCount: 5,
                                    rating: loadedComplex.stars,
                                    size: constraint.maxWidth * 0.05,
                                    color: Colors.green,
                                    borderColor: Colors.green,
                                    spacing: 0.0),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Consumer<ManagerInfo>(
                              builder: (_, notification, ch) => Badge(
                                    color:
                                        notification.notificationItems.length ==
                                                0
                                            ? Colors.grey
                                            : Colors.green,
                                    value: notification.notificationItems.length
                                        .toString(),
                                    child: ch,
                                  ),
                              child: Container(
                                width: 60,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      loadedComplex.likes_no.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            12.0,
                                      ),
                                    ),
                                    Text(
                                      'نظرات',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          VerticalDivider(),
                          Consumer<ManagerInfo>(
                              builder: (_, notification, ch) => Badge(
                                    color:
                                        notification.notificationItems.length ==
                                                0
                                            ? Colors.grey
                                            : Colors.green,
                                    value: notification.notificationItems.length
                                        .toString(),
                                    child: ch,
                                  ),
                              child: Container(
                                width: 60,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                     loadedComplex.likes_no.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            12.0,
                                      ),
                                    ),
                                    Text(
                                      'دنبال کننده',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          VerticalDivider(),
                          Consumer<ManagerInfo>(
                              builder: (_, notification, ch) => Badge(
                                    color:
                                        notification.notificationItems.length ==
                                                0
                                            ? Colors.grey
                                            : Colors.green,
                                    value: notification.notificationItems.length
                                        .toString(),
                                    child: ch,
                                  ),
                              child: Container(
                                width: 60,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      loadedComplex.visits_no.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            12.0,
                                      ),
                                    ),
                                    Text(
                                      'رزرو',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
