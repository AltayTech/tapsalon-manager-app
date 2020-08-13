import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/user_models/user.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/provider/cities.dart';
import 'package:tapsalon_manager/provider/user_info.dart';
import 'package:tapsalon_manager/screen/user_profile/user_detail_info_edit_screen.dart';
import 'package:tapsalon_manager/widget/dialogs/select_city_dialog.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';

class UserDetailInfoScreen extends StatefulWidget {
  static const routeName = '/UserDetailInfoScreen';

  final User customer;

  UserDetailInfoScreen({this.customer});

  @override
  _UserDetailInfoScreenState createState() => _UserDetailInfoScreenState();
}

class _UserDetailInfoScreenState extends State<UserDetailInfoScreen> {
  User customer;
  var _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      cashOrder();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> cashOrder() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<UserInfo>(context, listen: false).getUser();
    customer = Provider.of<UserInfo>(context, listen: false).user;

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appBarColor,
          elevation: 0,
          iconTheme: IconThemeData(color: AppTheme.appBarIconColor),
          actions: <Widget>[
            Consumer<Cities>(
              builder: (_, cities, ch) => Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context, builder: (ctx) => SelectCityDialog());
                  },
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          cities.selectedCity.name,
                          softWrap: true,
                          style: TextStyle(
                              color: AppTheme.black,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 12.0),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: AppTheme
                .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),
        body: _isLoading
            ? Align(
                alignment: Alignment.center,
                child: SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index.isEven ? Colors.grey : Colors.grey,
                      ),
                    );
                  },
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8,
                              top: 8,
                            ),
                            child: Image.asset(
                              'assets/images/user_Icon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'اطلاعات شخصی',
                              style: TextStyle(
                                color: AppTheme.h1,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 18.0,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'مشخصات',
                                style: TextStyle(
                                  color: AppTheme.black,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 14.0,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              FittedBox(
                                child: FlatButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        UserDetailInfoEditScreen.routeName);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      Text(
                                        ' ویرایش',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              InfoItem(
                                title: 'نام',
                                text: customer.fname,
                                bgColor: Colors.white,
                                iconColor: Color(0xffA67FEC),
                              ),
                              InfoItem(
                                title: 'نام خانوادگی',
                                text: customer.lname,
                                bgColor: Colors.white,
                                iconColor: Color(0xffA67FEC),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                          Container(
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                InfoItem(
                                  title: 'ایمیل',
                                  text: customer.email,
                                  bgColor: Colors.white,
                                  iconColor: Color(0xffA67FEC),
                                ),
                                InfoItem(
                                  title: 'استان',
                                  text: customer.ostan != null
                                      ? customer.ostan.name
                                      : '',
                                  bgColor: Colors.white,
                                  iconColor: Color(0xff4392F1),
                                ),
                                InfoItem(
                                  title: 'شهر',
                                  text: customer.city != null
                                      ? customer.city.name
                                      : '',
                                  bgColor: Colors.white,
                                  iconColor: Color(0xff4392F1),
                                ),
                                InfoItem(
                                  title: 'آدرس',
                                  text: customer.address != null
                                      ? customer.address
                                      : '',
                                  bgColor: Colors.white,
                                  iconColor: Color(0xff4392F1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: deviceHeight * 0.02,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  const InfoItem({
    Key key,
    @required this.title,
    @required this.text,
    @required this.bgColor,
    @required this.iconColor,
  }) : super(key: key);

  final String title;
  final String text;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$title : ',
            style: TextStyle(
              color: AppTheme.grey,
              fontFamily: 'Iransans',
              fontSize: textScaleFactor * 14.0,
            ),
          ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(
                    color: Colors.grey.withOpacity(
                  0.0,
                )),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: AppTheme.black,
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 14.0,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
