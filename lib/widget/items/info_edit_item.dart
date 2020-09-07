import 'package:flutter/material.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';

class InfoEditItem extends StatelessWidget {
  const InfoEditItem({
    Key key,
    @required this.title,
    @required this.controller,
    @required this.keybordType,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final TextInputType keybordType;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Container(
//      width: deviceWidth * 0.8,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          child: Wrap(
            children: <Widget>[
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
                    contentPadding: EdgeInsets.only(right: 8),
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
            ],
          ),
        ),
      ),
    );
  }
}
