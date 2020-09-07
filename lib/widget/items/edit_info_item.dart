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
          Padding(
            padding: const EdgeInsets.only( bottom: 8),
            child: Row(
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
                color: Colors.black87,
                fontFamily: 'Iransans',
                fontSize: textScaleFactor * 15.0,
              ),
              textAlign: TextAlign.start,
              decoration: InputDecoration(

//                fillColor: Colors.white,
//                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.green,
                  ),
                ),


                alignLabelWithHint: true,
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Iransans',
                  fontSize: textScaleFactor * 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
