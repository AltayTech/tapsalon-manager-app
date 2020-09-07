import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/screen/user_profile/user_detail_info_screen.dart';
import 'package:tapsalon_manager/widget/items/info_edit_item.dart';

import '../../models/city.dart';
import '../../models/province.dart';
import '../../models/user_models/user.dart';
import '../../provider/app_theme.dart';
import '../../provider/cities.dart';
import '../../provider/user_info.dart';
import '../../widget/main_drawer.dart';

class UserDetailInfoEditScreen extends StatefulWidget {
  static const routeName = '/customerDetailInfoEditScreen';

  @override
  _UserDetailInfoEditScreenState createState() =>
      _UserDetailInfoEditScreenState();
}

enum GenderSelection { male, female }

class _UserDetailInfoEditScreenState extends State<UserDetailInfoEditScreen> {
  final nameController = TextEditingController();
  final familyController = TextEditingController();
  final genderController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  GenderSelection _character = GenderSelection.male;

  bool _isLoading;

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

    nameController.text = user.fname;
    familyController.text = user.lname;
    genderController.text = user.gender.toString();
    mobileController.text = user.mobile;
    addressController.text = user.address;

    super.initState();
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
  void didChangeDependencies() async {
    if (_isInit) {
      await retrieveProvince();

      user.gender == 1
          ? _character = GenderSelection.male
          : GenderSelection.female;
      setState(() {});
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameController.dispose();
    familyController.dispose();
    genderController.dispose();
    mobileController.dispose();
    addressController.dispose();
    super.dispose();
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
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: MainDrawer(),
        ),
        body: Builder(
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              color: AppTheme.white,
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
                            Container(
                              color: AppTheme.white,
                              child: Text(
                                'اطلاعات کاربر',
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Container(
                              color: AppTheme.white,
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: <Widget>[
                                  InfoEditItem(
                                    title: 'نام',
                                    controller: nameController,
                                    keybordType: TextInputType.text,
                                  ),
                                  InfoEditItem(
                                    title: 'نام خانوادگی',
                                    controller: familyController,
                                    keybordType: TextInputType.text,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: deviceWidth * 0.8,
                                      decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Container(
                                        child: Wrap(
                                          children: <Widget>[
                                            Text(
                                              'جنسیت : ',
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
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: deviceWidth * 0.4,
                                                    child: RadioListTile<
                                                        GenderSelection>(
                                                      title: const Text('آقا'),
                                                      value:
                                                          GenderSelection.male,
                                                      groupValue: _character,
                                                      onChanged:
                                                          (GenderSelection
                                                              value) {
                                                        setState(() {
                                                          _character = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    width: deviceWidth * 0.4,
                                                    child: RadioListTile<
                                                        GenderSelection>(
                                                      title: const Text('خانم'),
                                                      value: GenderSelection
                                                          .female,
                                                      groupValue: _character,
                                                      onChanged:
                                                          (GenderSelection
                                                              value) {
                                                        setState(() {
                                                          _character = value;
                                                        });
                                                      },
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
                                  InfoEditItem(
                                    title: 'آدرس',
                                    controller: addressController,
                                    keybordType: TextInputType.text,
                                  ),
                                  InfoEditItem(
                                    title: 'موبایل',
                                    controller: mobileController,
                                    keybordType: TextInputType.phone,
                                  ),
                                ],
                              ),
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

                        Provider.of<UserInfo>(context, listen: false).fname =
                            nameController.text;
                        Provider.of<UserInfo>(context, listen: false).lname =
                            familyController.text;
                        Provider.of<UserInfo>(context, listen: false).gender =
                            _character == GenderSelection.male ? 1 : 2;

                        Provider.of<UserInfo>(context, listen: false).ostanId =
                            provinceId;
                        Provider.of<UserInfo>(context, listen: false).cityId =
                            cityId;
                        Provider.of<UserInfo>(context, listen: false).mobile =
                            mobileController.text;
                        Provider.of<UserInfo>(context, listen: false).address =
                            addressController.text;
                        Provider.of<UserInfo>(context, listen: false)
                            .endBuilder();

                        Provider.of<UserInfo>(context, listen: false)
                            .sendCustomer()
                            .then((v) {
                          Scaffold.of(context).showSnackBar(addToCartSnackBar);
                          Navigator.of(context)
                              .popAndPushNamed(UserDetailInfoScreen.routeName);
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

