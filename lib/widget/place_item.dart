import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/place_in_complex.dart';
import 'package:tapsalon_manager/screen/place_detail/salon_detail_screen.dart';

import 'en_to_ar_number_convertor.dart';

class PlaceItem extends StatelessWidget {
  final PlaceInComplex place;

  PlaceItem({this.place});

  @override
  Widget build(BuildContext context) {
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return LayoutBuilder(
      builder: (context, constraint) => InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(SalonDetailScreen.routeName,
              arguments: {'placeId': place.id, 'title': place.title});
        },
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: constraint.maxHeight * 0.6,
                      child: FadeInImage(
                        placeholder:
                            AssetImage('assets/images/tapsalon_icon_200.png'),
                        image: NetworkImage(place.img_url.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: constraint.maxHeight * 0.05,
                    ),
                    Container(
                      width: double.infinity,
                      height: constraint.maxHeight * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          place.title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Iransans',
                            fontSize:
                                MediaQuery.of(context).textScaleFactor * 12.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,

                      height: constraint.maxHeight * 0.2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          place.excerpt,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Iransans',
                            fontSize:
                                MediaQuery.of(context).textScaleFactor * 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: constraint.maxHeight * 0.05,
              left: -1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: AppTheme.discountBgColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Text(
                      'تخفیف 20%',
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: constraint.maxHeight * 0.20,
              left: -1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: AppTheme.priceBgColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Text(
                      'قابل روزرو',
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: constraint.maxHeight * 0.550,
              left: constraint.maxWidth * 0.05,
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: AppTheme.priceBgColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: Text(
                          place.price != null
                              ? EnArConvertor()
                                  .replaceArNumber(currencyFormat
                                      .format(double.parse(place.price))
                                      .toString())
                                  .toString()
                              : EnArConvertor().replaceArNumber('0'),
                          style: TextStyle(
                            fontFamily: 'Iransans',
                            fontSize:
                                MediaQuery.of(context).textScaleFactor * 10.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'تومان',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 7.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
