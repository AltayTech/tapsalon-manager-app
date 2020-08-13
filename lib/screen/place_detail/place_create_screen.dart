import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/city.dart';
import 'package:tapsalon_manager/models/province.dart';
import 'package:tapsalon_manager/provider/cities.dart';
import 'package:tapsalon_manager/screen/place_detail/place_detail_screen.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog.dart';

import '../../models/user_models/user.dart';
import '../../provider/app_theme.dart';
import '../../provider/places.dart';
import '../../provider/user_info.dart';
import '../../widget/main_drawer.dart';

class PlaceCreateScreen extends StatefulWidget {
  static const routeName = '/PlaceCreateScreen';

  @override
  _PlaceCreateScreenState createState() => _PlaceCreateScreenState();
}

class _PlaceCreateScreenState extends State<PlaceCreateScreen> {
  final reviewTextController = TextEditingController();
  final placeNameController = TextEditingController();

  var _isLoading = false;

  bool _isInit = true;

  var provinceValue;

  List<String> provinceValueList = [];

  var citiesValue;

  List<String> citiesValueList = [];

  List<Province> provinceList = [];

  List<City> citiesList = [];

  int cityId;

  int provinceId;

  User user;

  @override
  void initState() {
    user = Provider.of<UserInfo>(context, listen: false).user;

    reviewTextController.text = '';

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await retrieveProvince();

      setState(() {});
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    placeNameController.dispose();

    reviewTextController.dispose();

    super.dispose();
  }

  Future<void> createPlace() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Places>(context, listen: false)
        .sendPlace(placeNameController.text, provinceId, cityId)
        .then((value) async {
      if (value != 0) {
//        await Provider.of<Places>(context, listen: false)
////            .retrieveComment(placeId);
        await Navigator.of(context).pushNamed(
          PlaceDetailScreen.routeName,
          arguments: {
            'placeId': value,
          },
        );
        Navigator.of(context).pop();

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
              title: 'تشکر',
              buttonText: 'خب',
              description:
                  'نظر شما با موفقیت ثبت شد\n بعد از تایید نمایش داده خواهد شد',
            ));
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

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
        ),

        endDrawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors
                .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),
        // resizeToAvoidBottomInset: false,
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
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                height: 200,
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/create_place_header_image.png',
                                  fit: BoxFit.fitHeight,
                                )),
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'ثبت نام اولیه مکان:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                    ),
                                  ),
                                  InfoEditItem(
                                    title: 'نام',
                                    controller: placeNameController,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: deviceWidth * 0.8,
                                      decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Wrap(
                                        children: <Widget>[
                                          Text(
                                            'استان : ',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 13.0,
                                            ),
                                          ),
                                          Container(
                                            width: deviceWidth,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.4),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                decoration: BoxDecoration(
                                                    color: AppTheme.white,
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 0.3)),
                                                child: DropdownButton<String>(
                                                  value: provinceValue,
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.orange,
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Iransans',
                                                    fontSize:
                                                        textScaleFactor * 13.0,
                                                  ),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      provinceValue = newValue;
                                                      provinceId = provinceList[
                                                              provinceValueList
                                                                  .indexOf(
                                                                      newValue)]
                                                          .id;
                                                      retrieveCities(
                                                          provinceId);
                                                    });
                                                  },
                                                  underline: Container(
                                                    color: AppTheme.white,
                                                  ),
                                                  items: provinceValueList.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Container(
                                                        width:
                                                            deviceWidth * 0.6,
                                                        child: Text(
                                                          value,
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Iransans',
                                                            fontSize:
                                                                textScaleFactor *
                                                                    13.0,
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: deviceWidth * 0.8,
                                      decoration: BoxDecoration(
                                        color: AppTheme.white,
                                      ),
                                      child: Wrap(
                                        children: <Widget>[
                                          Text(
                                            'شهر : ',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 13.0,
                                            ),
                                          ),
                                          Container(
                                            width: deviceWidth,
                                            decoration: BoxDecoration(
                                              color: AppTheme.white,
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.4),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                decoration: BoxDecoration(
                                                    color: AppTheme.white,
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 0.4)),
                                                child: DropdownButton<String>(
                                                  value: citiesValue,
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.orange,
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Iransans',
                                                    fontSize:
                                                        textScaleFactor * 13.0,
                                                  ),
                                                  onChanged: (String newValue) {
                                                    setState(() {
                                                      citiesValue = newValue;

                                                      cityId = citiesList[
                                                              citiesValueList
                                                                  .indexOf(
                                                                      newValue)]
                                                          .id;
                                                    });
                                                  },
                                                  underline: Container(
                                                    color: AppTheme.white,
                                                  ),
                                                  items: citiesValueList.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Container(
                                                        width:
                                                            deviceWidth * 0.6,
                                                        child: Text(
                                                          value,
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Iransans',
                                                            fontSize:
                                                                textScaleFactor *
                                                                    13.0,
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
                                ],
                              ),
                            ),
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
                            : Container()),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createPlace();
          },
          backgroundColor: AppTheme.buttonColor,
          child: Icon(
            Icons.check,
            color: AppTheme.white,
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
