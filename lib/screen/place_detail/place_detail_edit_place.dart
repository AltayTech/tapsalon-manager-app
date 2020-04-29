import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/facility.dart';
import 'package:tapsalon_manager/models/field.dart';
import 'package:tapsalon_manager/models/place.dart';
import 'package:tapsalon_manager/provider/complexes.dart';
import 'package:tapsalon_manager/provider/salons.dart';
import 'package:tapsalon_manager/screen/complex_detail/complex_detail_screen.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';

class PlaceDetailEditPlace extends StatefulWidget {
  static const routeName = '/placeDetaileditPlace';

  @override
  _PlaceDetailEditPlaceState createState() => _PlaceDetailEditPlaceState();
}

enum GenderSelection { male, female }

class _PlaceDetailEditPlaceState extends State<PlaceDetailEditPlace> {
  final nameController = TextEditingController();
  final excerptController = TextEditingController();
  final aboutController = TextEditingController();
  final priceController = TextEditingController();

  bool _isLoading = false;

  bool _isInit = true;
  var fieldValue;

  List<String> fieldValueList = [];
  List<Field> selectedFieldValueList = [];
  List<Facility> selectedFacilitiesValueList = [];
  var facilitiesValue;

  List<String> facilitiesValueList = [];

  List<Field> fieldList = [];

  List<Facility> facilitiesList = [];

  List<int> selectedFacilitiesId = [];
  List<int> selectedFieldId = [];

  int complex_id;

  Place place;

  @override
  void initState() {
//    complex_id = ModalRoute.of(context).settings.arguments as int;

    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final Map arguments = ModalRoute.of(context).settings.arguments as Map;
      place = arguments != null ? arguments['place'] : 0;
      complex_id = place.complexInPlace.id;
      await retrieveFields();
      await retrieveFacilities();
      for (int i = 0; i < place.fields.length; i++) {
        selectedFieldValueList.add(place.fields[i]);
      }

      for (int i = 0; i < place.facilities.length; i++) {
        selectedFacilitiesValueList.add(place.facilities[i]);
      }
      nameController.text = place.title;
      excerptController.text = place.excerpt;
      aboutController.text = place.about;
      priceController.text = place.price;

      setState(() {});
      _isInit = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> retrieveFields() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Complexes>(context, listen: false).retrieveFields();
    fieldList = Provider.of<Complexes>(context, listen: false).itemsFields;

    for (int i = 0; i < fieldList.length; i++) {
      print(i.toString());
      fieldValueList.add(fieldList[i].name);
    }

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> retrieveFacilities() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Complexes>(context, listen: false).retrievefacilities();
    facilitiesList =
        Provider.of<Complexes>(context, listen: false).itemsFacilities;

    for (int i = 0; i < facilitiesList.length; i++) {
      print(i.toString());
      facilitiesValueList.add(facilitiesList[i].name);
    }
    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> editPlace(
    String name,
    String excerpt,
    String about,
    String price,
    List<int> fields,
    List<int> facilities,
    int place_type_id,
  ) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Salons>(context, listen: false).editPlace(
        place_id: place.id,
        title: name,
        excerpt: excerpt,
        about: about,
        price: price,
        fields: fields,
        facilities: facilities,
        place_type: place_type_id);

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  List<int> addFieldIdToList(List<int> firstList, List<Field> secondList) {
    firstList.clear();
    for (int i = 0; i < secondList.length; i++) {
      firstList.add(secondList[i].id);
    }
    return firstList;
  }

  List<int> addFacilitiesIdToList(
      List<int> firstList, List<Facility> secondList) {
    firstList.clear();
    for (int i = 0; i < secondList.length; i++) {
      firstList.add(secondList[i].id);
    }
    return firstList;
  }

  @override
  void dispose() {
    nameController.dispose();
    excerptController.dispose();
    aboutController.dispose();
    priceController.dispose();

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
                              'اطلاعات سالن',
                              textAlign: TextAlign.right,
                            ),
                            Container(
                              color: Color(0xffFFF2F2),
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: <Widget>[
                                  InfoEditItem(
                                    title: 'عنوان',
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
                                  InfoEditItem(
                                    title: 'قیمت',
                                    controller: priceController,
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
                                              'رشته : ',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Wrap(
                                                children: selectedFieldValueList
                                                    .map(
                                                      (item) => Chip(
                                                        label: Text(item.name),
                                                        deleteIcon: Icon(
                                                          Icons.clear,
                                                        ),
                                                        deleteIconColor:
                                                            Colors.black,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        onDeleted: () {
                                                          selectedFieldValueList
                                                              .removeAt(
                                                                  selectedFieldValueList
                                                                      .indexOf(
                                                                          item));
                                                          setState(() {});
                                                        },
                                                      ),
                                                    )
                                                    .toList()
                                                    .cast<Widget>(),
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
                                                    value: fieldValue,
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: Colors.orange,
                                                    ),
                                                    hint: Text(
                                                      'لطفا رشته های مورد نظر را انتخاب نمایید',
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
                                                      setState(() {});
                                                      selectedFieldValueList
                                                          .add(fieldList[
                                                              fieldValueList
                                                                  .indexOf(
                                                                      newValue)]);
//
                                                    },
                                                    items: fieldValueList.map<
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
                                              'امکانات : ',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Wrap(
                                                children:
                                                    selectedFacilitiesValueList
                                                        .map(
                                                          (item) => Chip(
                                                            label:
                                                                Text(item.name),
                                                            deleteIcon: Icon(
                                                              Icons.clear,
                                                            ),
                                                            deleteIconColor:
                                                                Colors.black,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            onDeleted: () {
                                                              selectedFacilitiesValueList.removeAt(
                                                                  selectedFacilitiesValueList
                                                                      .indexOf(
                                                                          item));
                                                              setState(() {});
                                                            },
                                                          ),
                                                        )
                                                        .toList()
                                                        .cast<Widget>(),
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
                                                    value: facilitiesValue,
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: Colors.orange,
                                                    ),
                                                    hint: Text(
                                                      'لطفا امکانات سالن را انتخاب نمایید',
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
                                                      setState(() {});
                                                      selectedFacilitiesValueList
                                                          .add(facilitiesList[
                                                              facilitiesValueList
                                                                  .indexOf(
                                                                      newValue)]);
                                                    },
                                                    items: facilitiesValueList
                                                        .map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
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
                        selectedFieldId = addFieldIdToList(
                            selectedFieldId, selectedFieldValueList);
                        selectedFacilitiesId = addFacilitiesIdToList(
                            selectedFacilitiesId, selectedFacilitiesValueList);
                        print(nameController.text);
                        print(excerptController.text);
                        print(aboutController.text);
                        editPlace(
                          nameController.text,
                          excerptController.text,
                          aboutController.text,
                          priceController.text,
                          selectedFieldId,
                          selectedFacilitiesId,
                          1,
                        ).then((v) {
                          Scaffold.of(context).showSnackBar(addToCartSnackBar);
                          Navigator.of(context)
                              .popAndPushNamed(ComplexDetailScreen.routeName);
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
