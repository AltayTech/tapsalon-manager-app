import 'package:flutter/material.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';

class ContactWithUs extends StatefulWidget {
  static const routeName = '/ContactWithUs';

  @override
  _ContactWithUsState createState() => _ContactWithUsState();
}

class _ContactWithUsState extends State<ContactWithUs> {


  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تماس با ما',
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 100, bottom: 30),
                    child: Text(
                      'موبایل سعید',
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Iransans',
                        fontSize: textScaleFactor * 24.0,
                      ),
                    ),
                  ),
                  Text(
                    'محصولات اصل، با کیفیت و روش های متفاوت خرید در کنار شما با موبایل سعید',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  Column(
                    children: <Widget>[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.indigoAccent,
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  'تبریز، اول ششگلان، موبایل سعید',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 18,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Icon(
                                  Icons.call,
                                  color: Colors.indigoAccent,
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  '04135267485',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 18,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: deviceHeight * 0.18,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child: Image.asset(
                                      'assets/images/instagram.png'),
                                ),
                                Expanded(
                                  flex: 8,
                                  child:
                                      Image.asset('assets/images/telegram.png'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
          canvasColor: Colors.transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child:MainDrawer(),

      ),
    );
  }
}
