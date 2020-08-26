import 'package:flutter/material.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';

class ButtonBottom extends StatelessWidget {
  const ButtonBottom({
    Key key,
    this.width,
    this.height,
    @required this.text,
    this.isActive = false,
  }) : super(key: key);

  final double width;
  final double height;
  final String text;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            // has the effect of softening the shadow
            spreadRadius: 1,
            // has the effect of extending the shadow
            offset: Offset(
              1.0, // horizontal, move right 10
              1.0, // vertical, move down 10
            ),
          )
        ],
        color: isActive ? AppTheme.primary : AppTheme.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 18.0,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
