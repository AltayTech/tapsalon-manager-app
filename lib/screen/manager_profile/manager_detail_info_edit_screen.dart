import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/city.dart';
import 'package:tapsalon_manager/models/ostan.dart';
import 'package:tapsalon_manager/models/user.dart';
import 'package:tapsalon_manager/provider/cities.dart';
import 'package:tapsalon_manager/provider/manager_info.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';

import 'manager_profile_screen.dart';

class ManagerDetailInfoEditScreen extends StatefulWidget {
  static const routeName = '/managerDetailInfoEditScreen';

  @override
  _ManagerDetailInfoEditScreenState createState() =>
      _ManagerDetailInfoEditScreenState();
}

enum GenderSelection { male, female }

class _ManagerDetailInfoEditScreenState
    extends State<ManagerDetailInfoEditScreen> {
  final nameController = TextEditingController();
  final familyController = TextEditingController();
  final genderController = TextEditingController();
  final mobileController = TextEditingController();

  GenderSelection _character = GenderSelection.male;
  bool _isLoading;

  bool _isInit = true;
  var ostanValue;

  List<String> ostanValueList = [];
  var citiesValue;

  List<String> citiesValueList = [];

  List<Ostan> ostanList;

  List<City> citiesList;

  int cityId;

  int ostanId;

  User user;

  @override
  void initState() {
    user = Provider.of<ManagerInfo>(context, listen: false).user;

    nameController.text = user.fname;
    familyController.text = user.lname;
    genderController.text = user.gender.toString();
    mobileController.text = user.mobile;

    // TODO: implement initState
    super.initState();
  }

  Future<void> retrieveOstans() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Cities>(context, listen: false).retrieveOstans();
    ostanList = Provider.of<Cities>(context, listen: false).ostansItems;

    for (int i = 0; i < ostanList.length; i++) {
      print(i.toString());
      ostanValueList.add(ostanList[i].name);
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

    for (int i = 0; i < citiesList.length; i++) {
      print(i.toString());
      citiesValueList.add(citiesList[i].name);
    }
    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await retrieveOstans();
      user.gender == 1
          ? _character = GenderSelection.male
          : GenderSelection.female;
      setState(() {});
      _isInit = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameController.dispose();
    familyController.dispose();
    genderController.dispose();
    mobileController.dispose();
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
                                    title: 'نام خانوادگی',
                                    controller: familyController,
                                    bgColor: Color(0xffFFF2F2),
                                    iconColor: Color(0xffA67FEC),
                                    keybordType: TextInputType.text,
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
                                                border: Border.all(
                                                    color: Colors.grey),
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
                                                        retrieveCities(ostanId);
                                                      });
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
                                  InfoEditItem(
                                    title: 'موبایل',
                                    controller: mobileController,
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

                        Provider.of<ManagerInfo>(context, listen: false).fname =
                            nameController.text;
                        Provider.of<ManagerInfo>(context, listen: false).lname =
                            familyController.text;
                        Provider.of<ManagerInfo>(context, listen: false)
                                .gender =
                            _character == GenderSelection.male ? 1 : 2;

                        Provider.of<ManagerInfo>(context, listen: false)
                            .ostanId = ostanId;
                        Provider.of<ManagerInfo>(context, listen: false)
                            .cityId = cityId;
                        Provider.of<ManagerInfo>(context, listen: false)
                            .mobile = mobileController.text;
                        Provider.of<ManagerInfo>(context, listen: false)
                            .endBuilder();
                        _isLoading = true;
                        setState(() {});
                        Provider.of<ManagerInfo>(context, listen: false)
                            .sendCustomer()
                            .then((v) {
                          _isLoading = false;
                          setState(() {});
                          Scaffold.of(context).showSnackBar(addToCartSnackBar);
                          Navigator.of(context)
                              .popAndPushNamed(ManagerProfileScreen.routeName);
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
