import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/strings.dart';
import 'package:tapsalon_manager/provider/auth_manager.dart';
import 'package:tapsalon_manager/widget/MainTopicItem.dart';
import 'package:tapsalon_manager/widget/horizontal_list.dart';

class HomeScreeen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreeenState createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  bool _isInit = true;
  var _isLoading;
  var _searchTextController = TextEditingController();

  var loadedSalon;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies()async {
    if (_isInit) {
      try {
       await Provider.of<AuthManager>(context, listen: false).getCredetialToken();
      } catch (_) {}
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: deviceHeight * 0.32,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromRGBO(133, 183, 216, 1.0),
                          Color.fromRGBO(71, 147, 197, 1.0),
                          Color.fromRGBO(133, 183, 216, 1.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(deviceHeight * 0.05),
                      child: Container(
                        height: deviceHeight * 0.05,
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _searchTextController,
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 12.0,
                                  ),
                                  hintText: 'جستجوی مجموعه ...',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 10.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.15,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: () {},
                            child: MainTopicItem(
                              number: 1,
                              title: Strings.titleSalons,
                              bgColor: Color(0xffFB8C00),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: MainTopicItem(
                              number: 1,
                              title: Strings.titlClubs,
                              bgColor: Color(0xffFFB300),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: MainTopicItem(
                              number: 1,
                              title: Strings.titleEntertainment,
                              bgColor: Color(0xffFE5E2B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          new HorizontalList(
            list: loadedSalon,
            listTitle: 'سالن های محبوب',
          ),
          new HorizontalList(
            list: loadedSalon,
            listTitle: 'سالن های جدید',
          ),
          new HorizontalList(
            list: loadedSalon,
            listTitle: 'سالن های محبوب',
          ),
        ],
      ),
    );
  }
}
