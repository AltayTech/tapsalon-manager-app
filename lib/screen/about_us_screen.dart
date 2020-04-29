import 'package:flutter/material.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';
class AboutUsScreen extends StatefulWidget {
  static const routeName = '/AboutUsScreen';

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'درباره ما',
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'درباره ما:',
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 18.0,
                    ),
                  ),
                  Text(
                    'موبایل سعید با بیش از 15 سال سابقه در فروش موبایل، تبلت و تجهیزات جانبی افتخار خدمت رسانی به مردم عزیزمان را دارد. محصولات با کیفیت، انواع برند و پشتیبانی عالی و اولویت در پاسخ گویی به مشتریان از نقاط قوتی است که باعث شده هر روز بهتر از دیروز باشیم. موبایل سعید تجربه لذت بخشی از خرید را برای شما آرزومند است',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 14.0,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  Divider(),
                  Card(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: deviceWidth,
                              child: Text(
                                'اهداف ما:',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 18,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_right,
                                  color: Colors.indigoAccent,
                                ),
                                Expanded(
                                  child: Text(
                                    'ارائه انواع برندهای موبایل، تبلت و تجهیزات جانبی',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 14,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_right,
                                  color: Colors.indigoAccent,
                                ),
                                Expanded(
                                  child: Text(
                                    'سهولت در خرید محصولات با ارائه انواع روش های خرید',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 14,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_right,
                                  color: Colors.indigoAccent,
                                ),
                                Expanded(
                                  child: Text(
                                    'مشتری مداری و ارائه پشتیبانی قوی',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 14,
                                    ),
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_right,
                                  color: Colors.indigoAccent,
                                ),
                                Expanded(
                                  child: Text(
                                    'خدمات پس از فروش',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 14,
                                    ),
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}
