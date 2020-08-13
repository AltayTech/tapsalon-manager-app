import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tapsalon_manager/widget/en_to_ar_number_convertor.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/app_theme.dart';

class AboutUsScreen extends StatefulWidget {
  static const routeName = '/AboutUsScreen';

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'درباره ما',
          style: TextStyle(
            color: AppTheme.grey,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: deviceWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: deviceWidth * 0.20,
                          height: deviceWidth * 0.20,
                          color: AppTheme.white,
                          child: FadeInImage(
                            placeholder: AssetImage('assets/images/circle.gif'),
                            image: AssetImage(
                                'assets/images/tapsalon_icon_200.png'),
                            fit: BoxFit.contain,
                            height: deviceWidth * 0.5,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          'تاپ سالن',
                          style: TextStyle(
                            color: Color(0xff149D49),
                            fontFamily: 'Iransans',
                            fontWeight: FontWeight.bold,
                            fontSize: textScaleFactor * 24.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'درباره تاپ سالن',
                    style: AppTheme.textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: AppTheme.bg),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'تاپ سالن یک پلتفرم اطلاع رسانی و رزرو سالن های ورزشی، تفریحی، باشگاه ها می باشد.  تاپسالن درصدد است با تحت پوشش قرار دادن تمامی اماکن ورزشی و تفریحی سراسر کشور بتواند خدمات جامعی در زمینه اطلاعات اماکن ورزشی ارائه بدهد',
                      style: AppTheme.textTheme.bodyText2.copyWith(height: 2),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'تماس با ما',
                    style: AppTheme.textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _launchURL('https://goo.gl/maps/jFWrYRBtBYARzRWEA');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff00A8CC),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 5),
                            child: Text(
                              EnArConvertor().replaceArNumber(
                                'دفتر مرکزی: تبریز، میدان ساعت، خیابان ارتش شمالی، جنب اتاق بازرگانی، ساختمان 49',
                              ),
                              style: AppTheme.textTheme.bodyText2
                                  .copyWith(height: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _launchURL('tel:04135265197');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff00A8CC),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12, right: 5),
                            child: Text(
                              EnArConvertor().replaceArNumber(
                                '04135265197',
                              ),
                              style: AppTheme.textTheme.subtitle1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            _launchURL(
                                'https://www.instagram.com/tapsalon.ir/');
                          },
                          child: Image.asset('assets/images/instagram.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                        ),
                        InkWell(
                            onTap: () {
                              _launchURL(
                                  'https://t.me/tapsalon');
                            },
                            child: Image.asset('assets/images/telegram.png')),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: deviceWidth,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 8, bottom: 20),
                    child: InkWell(
                      onTap: () {
                        _launchURL('https://tapsalon.ir/');
                      },
                      child: Text(
                        'www.tapsalon.ir',
                        textAlign: TextAlign.center,
                        style: AppTheme.textTheme.subtitle1
                            .copyWith(color: Colors.blue),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                ),
//                  Container(
//                    height: deviceHeight * 0.7,
//                    width: deviceWidth,
//                    child: ListView.builder(
//                      shrinkWrap: true,
//                      primary: false,
//                      itemCount: shopData.features_list.length,
//                      itemBuilder: (BuildContext context, int index) {
//                        return Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Row(
//                            children: <Widget>[
//                              Icon(Icons.arrow_right,color: AppTheme.secondary,),
//                              Text(
//                                shopData.features_list[index].feature,
//                                style: TextStyle(
//                                  color: AppTheme.h1,
//                                  fontFamily: 'Iransans',
//                                  fontStyle: FontStyle.italic,
//                                  fontSize: textScaleFactor * 15.0,
//                                ),
//                                textAlign: TextAlign.center,
//                              ),
//                            ],
//                          ),
//                        );
//                      },
//                    ),
//                  ),
              ],
            ),
          ),
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}
