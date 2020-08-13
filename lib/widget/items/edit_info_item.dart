import 'package:flutter/material.dart';

class EditInfoItem extends StatelessWidget {
  const EditInfoItem({
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
            color: Colors.white,
            child: TextField(
              keyboardType: keybordType,
              onEditingComplete: () {},
              maxLines: null,

              textInputAction: TextInputAction.none,
              controller: controller,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Iransans',
                fontSize: textScaleFactor * 14.0,
              ),
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
        ],
      ),
    );
  }
}
