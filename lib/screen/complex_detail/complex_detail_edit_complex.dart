import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/city.dart';
import 'package:tapsalon_manager/models/complex.dart';
import 'package:tapsalon_manager/models/ostan.dart';
import 'package:tapsalon_manager/models/region.dart';
import 'package:tapsalon_manager/models/user.dart';
import 'package:tapsalon_manager/provider/cities.dart';
import 'package:tapsalon_manager/provider/complexes.dart';
import 'package:tapsalon_manager/provider/manager_info.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';

import 'complex_detail_screen.dart';

class ComplexDetailEditComplex extends StatefulWidget {
  static const routeName = '/complexDetailEditComplex';

  @override
  _ComplexDetailEditComplexState createState() =>
      _ComplexDetailEditComplexState();
}

enum GenderSelection { male, female }

class _ComplexDetailEditComplexState extends State<ComplexDetailEditComplex> {
  final nameController = TextEditingController();
  final excerptController = TextEditingController();
  final aboutController = TextEditingController();
  final phoneController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  GenderSelection _character = GenderSelection.male;
  bool _isLoading;
  Complex complex;

  bool _isInit = true;
  var ostanValue;
  var citiesValue;
  var regionsValue;

  List<String> ostanValueList = [];
  List<String> citiesValueList = [];
  List<String> regionsValueList = [];

  List<Ostan> ostanList;
  List<City> citiesList;
  List<Region> regionList;

  int cityId;
  int ostanId;
  int regionId;

  User user;

  Completer<GoogleMapController> _controller = Completer();

  String apiKey = 'AIzaSyAZU0fLfsuVinIskarXUEpcrMBxtQf7Dd0';

  LatLng _center;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  void initState() {
    user = Provider.of<ManagerInfo>(context, listen: false).user;

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final Map arguments = ModalRoute.of(context).settings.arguments as Map;
      complex = arguments != null ? arguments['complex'] : 0;
      await retrieveLocation(LatLng(
        complex.latitude != null ? complex.latitude : 36.0,
        complex.latitude != null ? complex.longitude : 48.0,
      ));
      nameController.text = complex.name;
      excerptController.text = complex.excerpt;
      aboutController.text = complex.about;
      phoneController.text = complex.phone;
      mobileController.text = complex.mobile;
      addressController.text = complex.address;

      ostanId = complex.ostan.id;
      ostanValue = complex.ostan.name;
      cityId = complex.city.id;
      citiesValue = complex.city.name;
      regionId = complex.region.id;
      regionsValue = complex.region.name;

      await retrieveOstans();
      await retrieveCities(ostanId);
      await retrieveRegions(cityId);

      user.gender == 1
          ? _character = GenderSelection.male
          : GenderSelection.female;
      setState(() {});
      _isInit = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> retrieveOstans() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Cities>(context, listen: false).retrieveOstans();
    ostanList = Provider.of<Cities>(context, listen: false).ostansItems;
    ostanValueList.clear();

    if (ostanList.length != 0) {
      for (int i = 0; i < ostanList.length; i++) {
        print(i.toString());
        ostanValueList.add(ostanList[i].name);
      }
      print(ostanValueList);

      var distinctIds = ostanValueList.toSet().toList();
      ostanValueList = distinctIds;
      print(ostanValueList);
    } else {
      ostanValueList = [];
    }

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> retrieveCities(int ostanId) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Cities>(context, listen: false)
        .retrieveOstanCities(ostanId);
    citiesList = Provider.of<Cities>(context, listen: false).citiesItems;

    citiesValueList.clear();

    if (citiesList.length != 0) {
      for (int i = 0; i < citiesList.length; i++) {
        print(i.toString());
        citiesValueList.add(citiesList[i].name);
      }
      var distinctIds = citiesValueList.toSet().toList();
      citiesValueList = distinctIds;
      print(citiesValueList);
    } else {
      citiesValueList = [];
    }

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> retrieveRegions(int cityId) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Cities>(context, listen: false)
        .retrieveCityRegions(cityId);
    regionList = Provider.of<Cities>(context, listen: false).regionsItems;
    regionsValueList.clear();

    if (regionList.length != 0) {
      for (int i = 0; i < regionList.length; i++) {
        print(i.toString());
        regionsValueList.add(regionList[i].name);
      }
      var distinctIds = regionsValueList.toSet().toList();
      regionsValueList = distinctIds;
      print(regionsValueList);
    } else {
      regionsValueList = [];
    }
    _center = LatLng(
      complex.latitude != null ? complex.latitude : 36.10,
      complex.longitude != null ? complex.longitude : 48.10,
    );
    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> retrieveLocation(LatLng latLng) async {
    setState(() {
      _isLoading = true;
    });

    _center = latLng;
    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> editComplex(
    int ostan_id,
    int city_id,
    int region_id,
    String name,
    String excerpt,
    String about,
    String address,
    String phone,
    String mobile,
    double latitude,
    double longitude,
  ) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Complexes>(context, listen: false).editComplex(
      complex_id: complex.id,
      ostan_id: complex.ostan.id,
      city_id: complex.city.id,
      region_id: complex.region.id,
      name: complex.name,
      excerpt: complex.excerpt,
      about: complex.about,
      address: complex.address,
      phone: complex.phone,
      mobile: complex.mobile,
      latitude: complex.latitude,
      longitude: complex.longitude,
    );

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    excerptController.dispose();
    aboutController.dispose();
    phoneController.dispose();
    mobileController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void showPlacePicker() async {
    LocationResult result = await showLocationPicker(context, apiKey,
        myLocationButtonEnabled: true,
        appBarColor: Colors.orange,
        initialCenter: _center,
        requiredGPS: true,
        layersButtonEnabled: true);
    _center = result.latLng;
    updatePinOnMap(_center);
    print(_center);
    _markers.clear();
    _markers.add(Marker(markerId: MarkerId('myLocation'), position: _center));
    setState(() {});
  }

  void updatePinOnMap(LatLng latLng) async {
    CameraPosition cPosition = CameraPosition(
      zoom: 13,
      bearing: 13,
      target: latLng,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
        ),

        drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors
                .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ), // resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: deviceHeight * 0.9,
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'اطلاعات کاربر',
                              textAlign: TextAlign.right,
                            ),
                            Container(
                              color: Color(0xffFFF2F2),
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: <Widget>[
                                  InfoEditItem(
                                    title: 'نام',
                                    controller: nameController,
                                    bgColor: Color(0xffFFF2F2),
                                    iconColor: Color(0xffA67FEC),
                                    keybordType: TextInputType.text,
                                  ),
                                  InfoEditItem(
                                    title: 'خلاصه',
                                    controller: excerptController,
                                    bgColor: Color(0xffFFF2F2),
                                    iconColor: Color(0xffA67FEC),
                                    keybordType: TextInputType.text,
                                  ),
                                  InfoEditItem(
                                    title: 'درباره',
                                    controller: aboutController,
                                    bgColor: Color(0xffFFF2F2),
                                    iconColor: Color(0xffA67FEC),
                                    keybordType: TextInputType.text,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Text(
                              'اطلاعات تماس',
                              textAlign: TextAlign.right,
                            ),
                            Container(
                              color: Color(0xffF1F5FF),
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: deviceWidth * 0.8,
                                      decoration: BoxDecoration(
                                        color: Color(0xffFFF2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Container(
                                        child: Wrap(
                                          children: <Widget>[
                                            Icon(
                                              Icons.arrow_right,
                                              color: Color(0xffA67FEC),
                                            ),
                                            Text(
                                              'استان : ',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                            Container(
                                              width: deviceWidth,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.ltr,
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: DropdownButton<String>(
                                                    value: ostanValue,
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.orange,
                                                    ),
                                                    hint: Text(
                                                      'لطفا استان را انتخاب نمایید',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: 'Iransans',
                                                        fontSize:
                                                            textScaleFactor *
                                                                13.0,
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor *
                                                              13.0,
                                                    ),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        ostanValue = newValue;
                                                        ostanId = ostanList[
                                                                ostanValueList
                                                                    .indexOf(
                                                                        newValue)]
                                                            .id;
                                                      });
                                                      retrieveCities(ostanId);
                                                    },
                                                    items: ostanValueList.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Iransans',
                                                            fontSize:
                                                                textScaleFactor *
                                                                    13.0,
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: deviceWidth * 0.8,
                                      decoration: BoxDecoration(
                                        color: Color(0xffFFF2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Container(
                                        child: Wrap(
                                          children: <Widget>[
                                            Icon(
                                              Icons.arrow_right,
                                              color: Color(0xffA67FEC),
                                            ),
                                            Text(
                                              'شهر : ',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                            Container(
                                              width: deviceWidth,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.ltr,
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: DropdownButton<String>(
                                                    value: citiesValue,
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.orange,
                                                    ),
                                                    hint: Text(
                                                      'لطفا شهر را انتخاب نمایید',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: 'Iransans',
                                                        fontSize:
                                                            textScaleFactor *
                                                                13.0,
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor *
                                                              13.0,
                                                    ),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        citiesValue = newValue;

                                                        cityId = citiesList[
                                                                citiesValueList
                                                                    .indexOf(
                                                                        newValue)]
                                                            .id;
                                                      });
                                                      retrieveRegions(cityId);
                                                    },
                                                    items: citiesValueList.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Iransans',
                                                            fontSize:
                                                                textScaleFactor *
                                                                    13.0,
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: deviceWidth * 0.8,
                                      decoration: BoxDecoration(
                                        color: Color(0xffFFF2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Container(
                                        child: Wrap(
                                          children: <Widget>[
                                            Icon(
                                              Icons.arrow_right,
                                              color: Color(0xffA67FEC),
                                            ),
                                            Text(
                                              'منطقه : ',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                            Container(
                                              width: deviceWidth,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.ltr,
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: DropdownButton<String>(
                                                    value: regionsValue,
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.orange,
                                                    ),
                                                    hint: Text(
                                                      'لطفا منطقه را انتخاب نمایید',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: 'Iransans',
                                                        fontSize:
                                                            textScaleFactor *
                                                                13.0,
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor *
                                                              13.0,
                                                    ),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        regionsValue = newValue;

                                                        regionId = regionList[
                                                                regionsValueList
                                                                    .indexOf(
                                                                        newValue)]
                                                            .id;
                                                      });
                                                    },
                                                    items: regionsValueList.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Iransans',
                                                            fontSize:
                                                                textScaleFactor *
                                                                    13.0,
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
                                  ),
                                  InfoEditItem(
                                    title: 'موبایل',
                                    controller: mobileController,
                                    bgColor: Color(0xffFFF2F2),
                                    iconColor: Color(0xffA67FEC),
                                    keybordType: TextInputType.phone,
                                  ),
                                  InfoEditItem(
                                    title: 'شماره ثابت',
                                    controller: phoneController,
                                    bgColor: Color(0xffFFF2F2),
                                    iconColor: Color(0xffA67FEC),
                                    keybordType: TextInputType.phone,
                                  ),
                                  InfoEditItem(
                                    title: 'آدرس',
                                    controller: addressController,
                                    bgColor: Color(0xffFFF2F2),
                                    iconColor: Color(0xffA67FEC),
                                    keybordType: TextInputType.phone,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Container(
                              height: deviceWidth * 0.7,
                              width: double.infinity,
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: _center,
                                  zoom: 13.0,
                                ),
                                compassEnabled: true,
                                mapType: MapType.normal,
                                markers: _markers,
                                onCameraMove: _onCameraMove,
                                scrollGesturesEnabled: true,
                                myLocationEnabled: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: RaisedButton(
                                    color: Colors.green,
                                    onPressed: () async {
                                      await showPlacePicker();
                                    },
                                    child: Text(
                                      'انتخاب مکان',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Iransans',
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            18.0,
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: deviceHeight * 0.02,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
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
                          : Container(),
                    ),
                  ),
                  Positioned(
                    bottom: 18,
                    left: 18,
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {});
                        var _snackBarMessage = 'اطلاعات ویرایش شد.';
                        final addToCartSnackBar = SnackBar(
                          content: Text(
                            _snackBarMessage,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 14.0,
                            ),
                          ),
                        );
                        print(ostanId);
                        print(cityId);
                        print(regionId);
                        print(nameController.text);
                        print(excerptController.text);
                        print(aboutController.text);
                        print(addressController.text);
                        print(phoneController.text);
                        print(mobileController.text);
                        print(ostanId);
                        print(_center.latitude);
                        print(_center.longitude);
                        editComplex(
                                ostanId,
                                cityId,
                                regionId,
                                nameController.text,
                                excerptController.text,
                                aboutController.text,
                                addressController.text,
                                phoneController.text,
                                mobileController.text,
                                _center.latitude,
                                _center.longitude)
                            .then((v) {
                          Scaffold.of(context).showSnackBar(addToCartSnackBar);
                          Navigator.of(context).popAndPushNamed(
                              ComplexDetailScreen.routeName,
                              arguments: {
                                'complexId': complex.id,
                                'title': complex.name,
                                'imageUrl': complex.img_url,
                                'stars': complex.stars.toString()
                              });
                        });
                      },
                      backgroundColor: Color(0xff3F9B12),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoEditItem extends StatelessWidget {
  const InfoEditItem({
    Key key,
    @required this.title,
    @required this.controller,
    @required this.keybordType,
    @required this.bgColor,
    @required this.iconColor,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final TextInputType keybordType;

  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: deviceWidth * 0.8,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: Wrap(
              children: <Widget>[
                Icon(
                  Icons.arrow_right,
                  color: iconColor,
                ),
                Text(
                  '$title : ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 13.0,
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Form(
                    child: Container(
                      height: deviceHeight * 0.05,
                      child: TextFormField(
                        keyboardType: keybordType,
                        onEditingComplete: () {},
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'لطفا مقداری را وارد نمایید';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.none,
                        controller: controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 10.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
