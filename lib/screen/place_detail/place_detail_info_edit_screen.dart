import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/city.dart';
import 'package:tapsalon_manager/models/facility.dart';
import 'package:tapsalon_manager/models/field.dart';
import 'package:tapsalon_manager/models/image.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/models/places_models/place_in_send.dart';
import 'package:tapsalon_manager/models/province.dart';
import 'package:tapsalon_manager/models/region.dart';
import 'package:tapsalon_manager/provider/auth.dart';
import 'package:tapsalon_manager/provider/cities.dart';
import 'package:tapsalon_manager/screen/place_detail/place_gallery_edit_screen.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog_show_picture.dart';
import 'package:tapsalon_manager/widget/dialogs/location_pick_dialog.dart';
import 'package:tapsalon_manager/widget/items/edit_info_item.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';
import 'package:tapsalon_manager/widget/place_location_widget.dart';

import '../../provider/app_theme.dart';
import '../../provider/places.dart';

class PlaceDetailInfoEditScreen extends StatefulWidget {
  static const routeName = '/PlaceDetailInfoEditScreen';

  @override
  _PlaceDetailInfoEditScreenState createState() =>
      _PlaceDetailInfoEditScreenState();
}

class _PlaceDetailInfoEditScreenState extends State<PlaceDetailInfoEditScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;

  bool _isInit = true;

  int _current = 0;

  List<ImageObj> gallery = [];

  final nameController = TextEditingController();

  final aboutController = TextEditingController();

  final expertController = TextEditingController();

  final timingExpertController = TextEditingController();

  final priceController = TextEditingController();

  final addressController = TextEditingController();

  final mobileController = TextEditingController();

  final phoneController = TextEditingController();

  var provinceValue;

  List<String> provinceValueList = [];

  List<Province> provinceList = [];

  int provinceId;

  var citiesValue;

  List<String> citiesValueList = [];

  List<City> citiesList = [];

  int cityId;

  var regionValue;

  List<String> regionValueList = [];

  List<Region> regionList = [];

  int regionId;

  var fieldValue;

  List<String> fieldValueList = [];

  List<Field> fieldList = [];

  int fieldId;

  var facilityValue;

  List<String> facilityValueList = [];

  List<Facility> facilityList = [];

  int facilityId;

  PlaceInSend placeInSend;

  Place loadedPlace;

  List<Facility> placeFacilitiesList = [];

  List<Field> placeFieldsList = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      ImageObj placeDefaultImage =
          Provider.of<Places>(context, listen: false).placeDefaultImage;

      var gymDefaultImage =
          Provider.of<Places>(context, listen: false).gymDefaultImage;

      var entDefaultImage =
          Provider.of<Places>(context, listen: false).entDefaultImage;

      final Map arguments = ModalRoute.of(context).settings.arguments as Map;

      loadedPlace = arguments['place'];

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

      nameController.text = loadedPlace.name;

      aboutController.text = loadedPlace.about;

      expertController.text = loadedPlace.excerpt;

      timingExpertController.text = loadedPlace.timings_excerpt;

      priceController.text = loadedPlace.price.toString();

      addressController.text = loadedPlace.address;

      mobileController.text = loadedPlace.mobile;

      phoneController.text = loadedPlace.phone;

      await retrieveProvince();

      if (loadedPlace.province != null && loadedPlace.province.id != 0) {
        provinceValue = loadedPlace.province.name;
        provinceId = loadedPlace.province.id;
      }

      if (loadedPlace.province != null && loadedPlace.province.id != 0) {
        await retrieveCities(loadedPlace.province.id);

        if (loadedPlace.city != null && loadedPlace.city.id != 0) {
          citiesValue = loadedPlace.city.name;

          cityId = loadedPlace.city.provinceId;
        }
      }

      if (loadedPlace.city != null && loadedPlace.city.id != 0) {
        await retrieveRegions(loadedPlace.city.id);

        if (loadedPlace.region != null && loadedPlace.region.id != 0) {
          regionValue = loadedPlace.region.name;

          regionId = loadedPlace.region.id;
        }
      }

      await retrieveFields();

      await retrieveFacilities();

      placeInSend = convertPlace(loadedPlace);

      placeFacilitiesList = loadedPlace.facilities;

      placeFieldsList = loadedPlace.fields;

      setState(() {});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameController.dispose();

    aboutController.dispose();

    expertController.dispose();

    timingExpertController.dispose();

    priceController.dispose();

    addressController.dispose();

    mobileController.dispose();

    phoneController.dispose();

    super.dispose();
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialogShowPicture(
              image: gallery[_current],
            ));
  }

  Future<void> sendChange(PlaceInSend placeInSend) async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Places>(context, listen: false)
        .modifyPlace(placeInSend)
        .then((value) async {
      if (value != 0) {
        _showLoginDialog();
      } else {}
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _showLoginDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialog(
              title: '????????',
              buttonText: '????',
              description:
                  ' ?????????????? ???? ???????????? ?????? ????\n ?????? ???? ?????????? ?????????? ???????? ?????????? ????',
            ));
  }

  List<int> getIdList(List<dynamic> list) {
    List<int> idList = [];

    for (int i = 0; i < list.length; i++) {
      idList.add(list[i].id);
    }

    return idList;
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

  Future<void> createSendPlace() {
    placeInSend.name = nameController.text;

    placeInSend.about = aboutController.text;

    placeInSend.excerpt = expertController.text;

    placeInSend.timings_excerpt = timingExpertController.text;

    placeInSend.price = int.parse(priceController.text);

    placeInSend.phone = phoneController.text;

    placeInSend.mobile = mobileController.text;

    placeInSend.province = provinceId;

    placeInSend.city = cityId;

    placeInSend.region = regionId;

    print('placeInSend.region.toString()');
    print(placeInSend.region.toString());
    print(placeInSend.city.toString());
    print(placeInSend.province.toString());

    placeInSend.fields = getIdList(placeFieldsList);

    placeInSend.facilities = getIdList(placeFacilitiesList);

    print(placeInSend.fields.toString());
    print(placeInSend.facilities.toString());
  }

  Future<void> retrieveProvince() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Cities>(context, listen: false).retrieveProvince();

    provinceList = Provider.of<Cities>(context, listen: false).provincesItems;

    for (int i = 0; i < provinceList.length; i++) {
      provinceValueList.add(provinceList[i].name);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> retrieveCities(int provinceId) async {
    setState(() {
      _isLoading = true;
    });

    citiesList.clear();

    await Provider.of<Cities>(context, listen: false)
        .retrieveOstanCities(provinceId);

    citiesList = Provider.of<Cities>(context, listen: false).citiesItems;

    citiesValue = null;

    setState(() {});

    citiesValueList.clear();

    for (int i = 0; i < citiesList.length; i++) {
      citiesValueList.add(citiesList[i].name);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> retrieveRegions(int cityId) async {
    setState(() {
      _isLoading = true;
    });

    regionList.clear();

    await Provider.of<Cities>(context, listen: false).retrieveRegions(cityId);

    regionList = Provider.of<Cities>(context, listen: false).itemsRegions;

    regionValue = null;

    setState(() {});

    regionValueList.clear();

    for (int i = 0; i < regionList.length; i++) {
      regionValueList.add(regionList[i].name);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> retrieveFields() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Places>(context, listen: false).retrieveFields();

    fieldList = Provider.of<Places>(context, listen: false).itemsFields;

    for (int i = 0; i < fieldList.length; i++) {
      fieldValueList.add(fieldList[i].name);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> retrieveFacilities() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Places>(context, listen: false).retrieveFacilities();

    facilityList = Provider.of<Places>(context, listen: false).itemsFacilities;

    for (int i = 0; i < facilityList.length; i++) {
      facilityValueList.add(facilityList[i].name);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    double deviceWidth = MediaQuery.of(context).size.width;

    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    var currencyFormat = intl.NumberFormat.decimalPattern();

    bool isLogin = Provider.of<Auth>(context, listen: false).isAuth;

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
      body: Container(
        color: AppTheme.white,
        child: Stack(
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
                                    borderRadius: BorderRadius.circular(10)),
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
                                                    .startsWith('assets/images')
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
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0.0,
                                right: 0.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: gallery.map<Widget>(
                                    (index) {
                                      return Container(
                                        width: 10.0,
                                        height: 10.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 20.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppTheme.h1, width: 0.4),
                                          color:
                                              _current == gallery.indexOf(index)
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
                      EditInfoItem(
                        title: '?????? ????????',
                        controller: nameController,
                        keybordType: TextInputType.text,
                      ),
                      EditInfoItem(
                        title: '????????????',
                        controller: aboutController,
                        keybordType: TextInputType.text,
                      ),
                      EditInfoItem(
                        title: '?????????? (??????????)',
                        controller: priceController,
                        keybordType: TextInputType.number,
                      ),
                      EditInfoItem(
                        title: '????????',
                        controller: addressController,
                        keybordType: TextInputType.text,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          child: Wrap(
                            children: <Widget>[
                              Text(
                                '??????????: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 13.0,
                                ),
                              ),
                              Container(
                                width: deviceWidth,
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.grey,
                                        )),
                                    child: DropdownButton<String>(
                                      value: provinceValue,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.orange,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          provinceValue = newValue;

                                          provinceId = provinceList[
                                                  provinceValueList
                                                      .indexOf(newValue)]
                                              .id;

                                          citiesValue = null;

                                          cityId = null;

                                          regionValue = null;

                                          regionId = null;

                                          retrieveCities(provinceId);
                                        });
                                      },
                                      underline: Container(
                                        color: AppTheme.white,
                                      ),
                                      items: provinceValueList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                            width: deviceWidth * 0.6,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              '??????: ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 13.0,
                              ),
                            ),
                            Container(
                              width: deviceWidth,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.grey,
                                      )),
                                  child: DropdownButton<String>(
                                    value: citiesValue,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.orange,
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 13.0,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        citiesValue = newValue;

                                        cityId = citiesList[citiesValueList
                                                .indexOf(newValue)]
                                            .id;

                                        regionValue = null;

                                        regionId = null;

                                        retrieveRegions(cityId);
                                      });
                                    },
                                    underline: Container(
                                      color: AppTheme.white,
                                    ),
                                    items: citiesValueList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                          width: deviceWidth * 0.6,
                                          child: Text(
                                            value,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 13.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                          ),
                          child: Wrap(
                            children: <Widget>[
                              Text(
                                '??????????',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 13.0,
                                ),
                              ),
                              Container(
                                width: deviceWidth,
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.grey,
                                        )),
                                    child: DropdownButton<String>(
                                      value: regionValue,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.orange,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          regionValue = newValue;

                                          regionId = regionList[regionValueList
                                                  .indexOf(newValue)]
                                              .id;
                                        });
                                      },
                                      underline: Container(
                                        color: AppTheme.white,
                                      ),
                                      items: regionValueList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                            width: deviceWidth * 0.6,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      EditInfoItem(
                        title: '????????',
                        controller: phoneController,
                        keybordType: TextInputType.phone,
                      ),
                      EditInfoItem(
                        title: '????????????',
                        controller: mobileController,
                        keybordType: TextInputType.phone,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 8),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppTheme.white,
                              border:
                                  Border.all(width: 2, color: AppTheme.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 6,
                                ),
                                child: Text(
                                  '???????? ????',
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    color: AppTheme.grey,
                                    fontSize: textScaleFactor * 14.0,
                                  ),
                                ),
                              ),
                              Container(
                                width: deviceWidth,
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.grey,
                                        )),
                                    child: DropdownButton<String>(
                                      value: fieldValue,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.orange,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          placeFieldsList.add(fieldList[
                                              fieldValueList
                                                  .indexOf(newValue)]);
                                        });
                                      },
                                      underline: Container(
                                        color: AppTheme.white,
                                      ),
                                      items: fieldValueList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                            width: deviceWidth * 0.6,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  children: placeFieldsList
                                      .map((e) => ChangeNotifierProvider.value(
                                            value: e,
                                            child: Chip(
                                              onDeleted: () {
                                                placeFieldsList.removeAt(
                                                    placeFieldsList.indexOf(e));
                                                setState(() {});
                                              },
                                              deleteIcon: Center(
                                                child: Icon(
                                                  Icons.clear,
                                                  size: 20,
                                                ),
                                              ),
                                              label: Text(
                                                e.name,
                                                style: TextStyle(
                                                  fontFamily: 'Iransans',
                                                  color: Colors.black,
                                                  fontSize:
                                                      textScaleFactor * 14.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
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
                              border:
                                  Border.all(width: 2, color: AppTheme.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 6,
                                ),
                                child: Text(
                                  '??????????????',
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    color: AppTheme.grey,
                                    fontSize: textScaleFactor * 14.0,
                                  ),
                                ),
                              ),
                              Container(
                                width: deviceWidth,
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.grey,
                                        )),
                                    child: DropdownButton<String>(
                                      value: facilityValue,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.orange,
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          placeFacilitiesList.add(facilityList[
                                              facilityValueList
                                                  .indexOf(newValue)]);
                                        });
                                      },
                                      underline: Container(
                                        color: AppTheme.white,
                                      ),
                                      items: facilityValueList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                            width: deviceWidth * 0.6,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  children: placeFacilitiesList
                                      .map(
                                        (e) => ChangeNotifierProvider.value(
                                          value: e,
                                          child: Chip(
                                            onDeleted: () {
                                              placeFacilitiesList.removeAt(
                                                  placeFacilitiesList
                                                      .indexOf(e));
                                              setState(() {});
                                            },
                                            deleteIcon: Center(
                                              child: Icon(
                                                Icons.clear,
                                                size: 20,
                                              ),
                                            ),
                                            label: Text(
                                              e.name,
                                              style: TextStyle(
                                                fontFamily: 'Iransans',
                                                color: Colors.black,
                                                fontSize:
                                                    textScaleFactor * 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )
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
                              border:
                                  Border.all(width: 2, color: AppTheme.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      PlaceGalleryEditScreen.routeName, arguments: {
                                        'place': loadedPlace,
                                      } );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 6,
                                  ),
                                  child: Text(
                                    '??????????',
                                    style: TextStyle(
                                      fontFamily: 'Iransans',
                                      color: AppTheme.grey,
                                      fontSize: textScaleFactor * 14.0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  children: loadedPlace.gallery
                                      .map(
                                        (e) => ChangeNotifierProvider.value(
                                            value: e,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.network(
                                                e.url.medium,
                                                height: 60,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      )
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
                              border:
                                  Border.all(width: 2, color: AppTheme.white),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  await showDialog<String>(
                                      context: context,
                                      builder: (ctx) => LocationPickDialog(
                                            place: loadedPlace,
                                          ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 6,
                                  ),
                                  child: Text(
                                    '???????? ???? ?????? ????????',
                                    style: TextStyle(
                                      fontFamily: 'Iransans',
                                      color: AppTheme.grey,
                                      fontSize: textScaleFactor * 14.0,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 300,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: loadedPlace.latitude != 0 &&
                                          loadedPlace.longitude != 0
                                      ? PlaceLocationWidget(
                                          place: loadedPlace,
                                        )
                                      : Center(
                                          child: Text(
                                            '???????????? ?????? ????????',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Iransans',
                                              color: AppTheme.grey,
                                              fontSize: textScaleFactor * 12.0,
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
            _isLoading
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
                : Container(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await createSendPlace();
          await sendChange(placeInSend);
        },
        backgroundColor: AppTheme.buttonColor,
        child: Icon(
          Icons.check,
          color: AppTheme.white,
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
