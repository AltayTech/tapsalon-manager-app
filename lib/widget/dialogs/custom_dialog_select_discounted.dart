import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../en_to_ar_number_convertor.dart';

class CustomDialogSelectDiscounted extends StatefulWidget {
  @override
  _CustomDialogSelectDiscountedState createState() =>
      _CustomDialogSelectDiscountedState();
}

class _CustomDialogSelectDiscountedState
    extends State<CustomDialogSelectDiscounted> {
  var _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) => Stack(
        children: <Widget>[
          Container(
            height: 270,

            padding: EdgeInsets.only(
              top: Consts.avatarRadius + Consts.padding,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberPicker.integer(
                        initialValue: _currentValue,
                        minValue: 0,
                        maxValue: 100,
                        onChanged: (newValue) =>
                            setState(() => _currentValue = newValue)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    EnArConvertor().replaceArNumber(
                      'میزان تخفیف: $_currentValue',
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Iransans',
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: InkWell(
                      onTap: () {
                        return Navigator.of(context).pop(_currentValue);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            'تایید',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Iransans',
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 10;
}
