import 'package:flutter/material.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/widget/en_to_ar_number_convertor.dart';

class TextInfoItem extends StatelessWidget {
  const TextInfoItem({
    Key key,
    @required this.title,
    this.content,
  }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                '$title : ',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Iransans',
                  fontSize: textScaleFactor * 13.0,
                ),
              ),
              Spacer(),
            ],
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                EnArConvertor().replaceArNumber(content),
                softWrap: true,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Iransans',
                  fontSize: textScaleFactor * 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
