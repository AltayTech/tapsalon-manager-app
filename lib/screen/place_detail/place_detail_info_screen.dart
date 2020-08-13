import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/image.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/provider/auth.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog_show_picture.dart';
import 'package:tapsalon_manager/widget/en_to_ar_number_convertor.dart';
import 'package:tapsalon_manager/widget/items/text_info_item.dart';
import 'package:tapsalon_manager/widget/place_location_widget.dart';

import '../../provider/app_theme.dart';
import '../../provider/places.dart';

class PlaceDetailInfoScreen extends StatefulWidget {
  static const routeName = '/PlaceDetailScreen';

  final Place loadedPlace;

  PlaceDetailInfoScreen(this.loadedPlace);

  @override
  _PlaceDetailInfoScreenState createState() => _PlaceDetailInfoScreenState();
}

class _PlaceDetailInfoScreenState extends State<PlaceDetailInfoScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;

  bool _isInit = true;

  int _current = 0;

  List<ImageObj> gallery = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      ImageObj placeDefaultImage =
          Provider.of<Places>(context, listen: false).placeDefaultImage;
      var gymDefaultImage =
          Provider.of<Places>(context, listen: false).gymDefaultImage;
      var entDefaultImage =
          Provider.of<Places>(context, listen: false).entDefaultImage;

      if (widget.loadedPlace.gallery.length < 1) {
        gallery.clear();
        gallery.add(widget.loadedPlace.placeType.id == 2
            ? gymDefaultImage
            : widget.loadedPlace.placeType.id == 4
                ? entDefaultImage
                : placeDefaultImage);
      } else {
        gallery = widget.loadedPlace.gallery;
      }

      setState(() {});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialogShowPicture(
              image: gallery[_current],
            ));
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    bool isLogin = Provider.of<Auth>(context, listen: false).isAuth;

    return Container(
      color: AppTheme.white,
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
          : Stack(
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _showImageDialog();
                            },
                            child: Container(
                              height: deviceWidth * 0.6,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        border: Border.all(
                                            width: 5, color: AppTheme.bg),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                        viewportFraction: 1.0,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay:
                                            gallery.length == 1 ? true : false,
                                        height: double.infinity,
                                        autoPlayInterval: Duration(seconds: 5),
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 800),
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index, _) {
                                          _current = index;
                                          setState(() {});
                                        },
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                      ),
                                      items: gallery.map((gallery) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              width: deviceWidth,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: gallery.url.large
                                                        .startsWith(
                                                            'assets/images')
                                                    ? Image.asset(
                                                        gallery.url.medium,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        gallery.url.medium,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              value: loadingProgress
                                                                          .expectedTotalBytes !=
                                                                      null
                                                                  ? loadingProgress
                                                                          .cumulativeBytesLoaded /
                                                                      loadingProgress
                                                                          .expectedTotalBytes
                                                                  : null,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: gallery.map<Widget>(
                                        (index) {
                                          return Container(
                                            width: 10.0,
                                            height: 10.0,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 20.0,
                                                horizontal: 2.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppTheme.h1,
                                                  width: 0.4),
                                              color: _current ==
                                                      gallery.indexOf(index)
                                                  ? AppTheme.iconColor
                                                  : AppTheme.bg,
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextInfoItem(
                            title: 'نام مکان',
                            content: widget.loadedPlace.name,
                          ),
                          TextInfoItem(
                            title: 'درباره',
                            content: widget.loadedPlace.about,
                          ),
                          TextInfoItem(
                            title: 'هزینه (تومان)',
                            content: EnArConvertor()
                                .replaceArNumber(currencyFormat
                                    .format(double.parse(
                                        widget.loadedPlace.price.toString()))
                                    .toString())
                                .toString(),
                          ),
                          TextInfoItem(
                            title: 'آدرس',
                            content: widget.loadedPlace.address,
                          ),
                          TextInfoItem(
                            title: 'استان',
                            content: widget.loadedPlace.province.name,
                          ),
                          TextInfoItem(
                            title: 'شهر',
                            content: widget.loadedPlace.city.name,
                          ),
                          TextInfoItem(
                            title: 'منطقه',
                            content: widget.loadedPlace.region.name,
                          ),
                          TextInfoItem(
                            title: 'تلفن',
                            content: widget.loadedPlace.phone,
                          ),
                          TextInfoItem(
                            title: 'موبایل',
                            content: widget.loadedPlace.mobile,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  border: Border.all(
                                      width: 2, color: AppTheme.white),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 6,
                                    ),
                                    child: Text(
                                      'رشته ها',
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        color: AppTheme.grey,
                                        fontSize: textScaleFactor * 14.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      children: widget.loadedPlace.fields
                                          .map((e) =>
                                              ChangeNotifierProvider.value(
                                                value: e,
                                                child: Text(
                                                  widget.loadedPlace.fields
                                                              .indexOf(e) <
                                                          (widget
                                                                  .loadedPlace
                                                                  .fields
                                                                  .length -
                                                              1)
                                                      ? (e.name + '، ')
                                                      : e.name + ' ',
                                                  style: TextStyle(
                                                      fontFamily: 'Iransans',
                                                      color: Colors.black,
                                                      fontSize:
                                                          textScaleFactor *
                                                              14.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  border: Border.all(
                                      width: 2, color: AppTheme.white),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 6,
                                    ),
                                    child: Text(
                                      'امکانات',
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        color: AppTheme.grey,
                                        fontSize: textScaleFactor * 14.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      children: widget.loadedPlace.facilities
                                          .map((e) =>
                                              ChangeNotifierProvider.value(
                                                value: e,
                                                child: Text(
                                                  widget.loadedPlace.facilities
                                                              .indexOf(e) <
                                                          (widget
                                                                  .loadedPlace
                                                                  .facilities
                                                                  .length -
                                                              1)
                                                      ? (e.name + '، ')
                                                      : e.name + ' ',
                                                  style: TextStyle(
                                                    fontFamily: 'Iransans',
                                                    color: Colors.black,
                                                    fontSize:
                                                        textScaleFactor * 14.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  border: Border.all(
                                      width: 2, color: AppTheme.white),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 6,
                                    ),
                                    child: Text(
                                      'گالری',
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        color: AppTheme.grey,
                                        fontSize: textScaleFactor * 14.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      children: widget.loadedPlace.gallery
                                          .map((e) =>
                                              ChangeNotifierProvider.value(
                                                  value: e,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Image.network(
                                                      e.url.medium,
                                                      height: 60,
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Container(
                              height: 350,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  border: Border.all(
                                      width: 2, color: AppTheme.white),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 6,
                                    ),
                                    child: Text(
                                      'مکان بر روی نقشه',
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        color: AppTheme.grey,
                                        fontSize: textScaleFactor * 14.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 300,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: widget.loadedPlace.latitude != 0 &&
                                              widget.loadedPlace.longitude != 0
                                          ? PlaceLocationWidget(
                                              place: widget.loadedPlace,
                                            )
                                          : Center(
                                              child: Text(
                                                'موقعیت ثبت نشده',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Iransans',
                                                  color: AppTheme.grey,
                                                  fontSize:
                                                      textScaleFactor * 12.0,
                                                ),
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
              ],
            ),
    );
  }
}
