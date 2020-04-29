import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/user.dart';
import 'package:tapsalon_manager/provider/manager_info.dart';
import 'manager_detail_info_edit_screen.dart';

class ManagerDetailInfoScreen extends StatefulWidget {
  final User user;

  ManagerDetailInfoScreen({this.user});

  @override
  _ManagerDetailInfoScreenState createState() =>
      _ManagerDetailInfoScreenState();
}

class _ManagerDetailInfoScreenState extends State<ManagerDetailInfoScreen> {
  User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    user = Provider.of<ManagerInfo>(context).user;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  String genderRetrieve(int genderId) {
    String genderName = '';
    if (genderId == 2) {
      genderName = 'زن';
    } else if (genderId == 1) {
      genderName = 'مرد';
    } else {
      genderName = 'نامشخص';
    }
    return genderName;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'اطلاعات کاربری',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 14.0,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  FittedBox(
                    child: FlatButton(
                      color: Colors.green,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ManagerDetailInfoEditScreen.routeName);
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
              Divider(),
              Container(
                color: Color(0xffFFF2F2),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    InfoItem(
                      title: 'نام',
                      text: user.fname,
                      bgColor: Color(0xffFFF2F2),
                      iconColor: Color(0xffA67FEC),
                    ),
                    InfoItem(
                      title: 'نام خانوادگی',
                      text: user.lname,
                      bgColor: Color(0xffFFF2F2),
                      iconColor: Color(0xffA67FEC),
                    ),
                    InfoItem(
                      title: 'جنسیت',
                      text:
                          genderRetrieve(user.gender != null ? user.gender : 0),
                      bgColor: Color(0xffFFF2F2),
                      iconColor: Color(0xffA67FEC),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              Text(
                'اطلاعات تماس',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontFamily: 'Iransans',
                  fontSize: textScaleFactor * 14.0,
                ),
                textAlign: TextAlign.right,
              ),
              Container(
                color: Color(0xffF1F5FF),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    InfoItem(
                      title: 'استان',
                      text: user.ostan.name != null ? user.ostan.name : '',
                      bgColor: Color(0xffF1F5FF),
                      iconColor: Color(0xff4392F1),
                    ),
                    InfoItem(
                      title: 'شهر',
                      text: user.city.name != null ? user.city.name : '',
                      bgColor: Color(0xffF1F5FF),
                      iconColor: Color(0xff4392F1),
                    ),
                    InfoItem(
                      title: 'موبایل',
                      text: user.mobile != null ? user.mobile : '',
                      bgColor: Color(0xffF1F5FF),
                      iconColor: Color(0xff4392F1),
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
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
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
                  fontSize: textScaleFactor * 14.0,
                ),
              ),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }
}

class InfoItem2 extends StatelessWidget {
  const InfoItem2({
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
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
                  fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
                ),
              ),
              Wrap(
                children: <Widget>[
                  Text(text),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
