import 'package:flutter/material.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';

class MainTopicItem extends StatelessWidget {
  const MainTopicItem({
    Key key,
    @required this.title,
    @required this.number,
    @required this.bgColor,
    @required this.icon,
    @required this.iconColor,
  }) : super(key: key);

  final int number;
  final String title;
  final Color bgColor;
  final String icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.29,
      height: MediaQuery.of(context).size.width * 0.29,
      decoration: BoxDecoration(
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.grey.withOpacity(0.2),
              blurRadius: 0,
              spreadRadius: 0,
              offset: Offset(
                0,
                0,
              ),
            ),

          ],
          borderRadius: new BorderRadius.all(Radius.circular(25))),
      child: LayoutBuilder(
        builder: (_, constraint) => Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.bottomCenter,

                child: SizedBox(
                  height: constraint.maxHeight * 0.45,
                  width: constraint.maxWidth * 0.45,
                  child: Image.asset(
                    icon,
                    fit: BoxFit.contain,
                    color: iconColor,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(top:12.0),
                    child: Text(
                      title,
                        style:AppTheme.textTheme.subtitle1


//                      TextStyle(
//                        color: AppTheme.black.withOpacity(0.7),
//                        fontFamily: 'Iransans',
//                        fontWeight: FontWeight.w600,
//                        fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
//                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
