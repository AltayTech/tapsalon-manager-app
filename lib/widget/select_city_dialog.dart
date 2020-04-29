import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/city.dart';
import 'package:tapsalon_manager/models/ostan.dart';
import 'package:tapsalon_manager/provider/cities.dart';

class SelectCityDialog extends StatefulWidget {
  @override
  _SelectCityDialogState createState() => _SelectCityDialogState();
}

class _SelectCityDialogState extends State<SelectCityDialog> {
  bool _isInit = true;
  var _isLoading;

  List<String> ostanValueList = [];
  var ostanValue;
  List<Ostan> ostanList = [];
  int ostanId;

  var citiesValue;
  List<String> citiesValueList = [];
  List<City> citiesList = [];
  int cityId;

  City selectedCity;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      loadOstan();
      setState(() {});
      _isInit = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> loadOstan() async {
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

  Future<void> loadCities() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Cities>(context, listen: false)
          .retrieveOstanCities(ostanId);
      citiesList = Provider.of<Cities>(context, listen: false).citiesItems;

      for (int i = 0; i < ostanList.length; i++) {
        print(i.toString());
        citiesValueList.add(citiesList[i].name);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        print(_isLoading.toString());
      });
    }
    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: Consts.avatarRadius + Consts.padding,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: deviceWidth * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Container(
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
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Container(
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    border: Border.all(color: Colors.grey)),
                                child: DropdownButton<String>(
                                  hint: Text(
                                    _isLoading
                                        ? 'لطفا صبر نمایید'
                                        : 'استان مورد نظر را انتخاب نمایید',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 11.0,
                                    ),
                                  ),
                                  value: ostanValue,
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
                                      ostanValue = newValue;
                                      ostanId = ostanList[ostanValueList
                                              .lastIndexOf(newValue)]
                                          .id;
                                    });
                                    loadCities();
                                  },
                                  items: ostanValueList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 13.0,
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
                Divider(thickness: 1,),
                Text(
                  'شهر : ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 13.0,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: deviceHeight * 0.5,
                    minWidth: deviceHeight * 0.010,
                  ),
                  child: ListView.builder(
                      itemCount: citiesList.length,
                      itemBuilder: (ctx, i) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Container(
                            color: selectedCity != null
                                ? selectedCity.id != citiesList[i].id
                                    ? Colors.white
                                    : Colors.grey.withOpacity(0.2)
                                : Colors.white,
                            child: ListTile(
                              title: Text(
                                citiesList[i].name,
                                style: TextStyle(
                                  fontFamily: "Iransans",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              onTap: () {
                                selectedCity = citiesList[i];
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      onTap: () {
                        Provider.of<Cities>(context, listen: false)
                            .setSelectedCity(selectedCity);
                        return selectedCity == null
                            ? null
                            : Navigator.of(context).pop();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: selectedCity == null
                              ? Colors.grey
                              : Color(0xffFF6D6B),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            'تایید',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Iransans',
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                                color: index.isEven ? Colors.grey : Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container()))
        ],
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 10;
}
