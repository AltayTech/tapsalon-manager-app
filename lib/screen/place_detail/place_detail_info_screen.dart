import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/imageObj.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog_show_picture.dart';
import 'package:tapsalon_manager/widget/en_to_ar_number_convertor.dart';
import 'package:tapsalon_manager/widget/items/text_info_item.dart';
import 'package:tapsalon_manager/widget/place_location_widget.dart';

import '../../provider/app_theme.dart';
import '../../provider/places.dart';
import 'place_detail_info_edit_screen.dart';

class PlaceDetailInfoScreen extends StatefulWidget {
  static const routeName = '/PlaceDetailScreen';

  @override
  _PlaceDetailInfoScreenState createState() => _PlaceDetailInfoScreenState();
}

class _PlaceDetailInfoScreenState extends State<PlaceDetailInfoScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;

  bool _isInit = true;

  int _current = 0;

  List<ImageObj> gallery = [];

  Place loadedPlace;

  ImageObj placeDefaultImage;

  ImageObj gymDefaultImage;

  ImageObj entDefaultImage;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      placeDefaultImage =
          Provider.of<Places>(context, listen: false).placeDefaultImage;

      gymDefaultImage =
          Provider.of<Places>(context, listen: false).gymDefaultImage;

      entDefaultImage =
          Provider.of<Places>(context, listen: false).entDefaultImage;

      setState(() {});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialogShowPicture(image: gallery[_current]));
  }

  Future<void> getGallery() {
    if (loadedPlace.gallery.length < 1) {
      gallery.clear();
      gallery.add(loadedPlace.placeType.id == 2
          ? gymDefaultImage
          : loadedPlace.placeType.id == 4
              ? entDefaultImage
              : placeDefaultImage);
    } else {
      gallery = loadedPlace.gallery;
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    double deviceWidth = MediaQuery.of(context).size.width;

    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    var currencyFormat = intl.NumberFormat.decimalPattern();

    loadedPlace = Provider.of<Places>(context).itemPlace;

    getGallery();

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
                                  CarouselSlider(
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
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
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
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          TextInfoItem(
                            title: 'نام مکان',
                            content: loadedPlace.name,
                          ),
                          TextInfoItem(
                            title: 'درباره',
                            content: loadedPlace.about,
                          ),
                          TextInfoItem(
                            title: 'هزینه (تومان)',
                            content: EnArConvertor()
                                .replaceArNumber(currencyFormat
                                    .format(double.parse(
                                        loadedPlace.price.toString()))
                                    .toString())
                                .toString(),
                          ),
                          TextInfoItem(
                            title: 'آدرس',
                            content: loadedPlace.address,
                          ),
                          TextInfoItem(
                            title: 'استان',
                            content: loadedPlace.province.name,
                          ),
                          TextInfoItem(
                            title: 'شهر',
                            content: loadedPlace.city.name,
                          ),
                          TextInfoItem(
                            title: 'منطقه',
                            content: loadedPlace.region.name,
                          ),
                          TextInfoItem(
                            title: 'تلفن',
                            content: loadedPlace.phone,
                          ),
                          TextInfoItem(
                            title: 'موبایل',
                            content: loadedPlace.mobile,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'رشته ها',
                                          style: TextStyle(
                                            fontFamily: 'Iransans',
                                            color: AppTheme.grey,
                                            fontSize: textScaleFactor * 14.0,
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6.0, bottom: 6),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      children: loadedPlace.fields
                                          .map((e) =>
                                              ChangeNotifierProvider.value(
                                                value: e,
                                                child: Text(
                                                  loadedPlace.fields
                                                              .indexOf(e) <
                                                          (loadedPlace.fields
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'امکانات',
                                          style: TextStyle(
                                            fontFamily: 'Iransans',
                                            color: AppTheme.grey,
                                            fontSize: textScaleFactor * 14.0,
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6.0, bottom: 6),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.start,
                                      children: loadedPlace.facilities
                                          .map((e) =>
                                              ChangeNotifierProvider.value(
                                                value: e,
                                                child: Text(
                                                  loadedPlace.facilities
                                                              .indexOf(e) <
                                                          (loadedPlace
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'گالری',
                                          style: TextStyle(
                                            fontFamily: 'Iransans',
                                            color: AppTheme.grey,
                                            fontSize: textScaleFactor * 14.0,
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 6.0, bottom: 6),
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        alignment: WrapAlignment.start,
                                        children: loadedPlace.gallery
                                            .map((e) =>
                                                ChangeNotifierProvider.value(
                                                    value: e,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.network(
                                                        e.url.medium,
                                                        height: 80,
                                                        width: 120,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )))
                                            .toList(),
                                      ),
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
                                      bottom: 4
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'مکان بر روی نقشه',
                                          style: TextStyle(
                                            fontFamily: 'Iransans',
                                            color: AppTheme.grey,
                                            fontSize: textScaleFactor * 14.0,
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 300,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: loadedPlace.latitude != 0 &&
                                              loadedPlace.longitude != 0
                                          ? PlaceLocationWidget(
                                              id: loadedPlace.id,
                                              name: loadedPlace.name,
                                              typeId: loadedPlace.placeType.id,
                                              latitude: loadedPlace.latitude,
                                              longitude: loadedPlace.longitude,
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
                          SizedBox(
                            height: 50,
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
                          PlaceDetailInfoEditScreen.routeName,
                          arguments: {
                            'place': loadedPlace,
                          });
                    },
                    child: Text(
                      'ویرایش اطلاعات',
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
    );
  }
}
