import 'package:flutter/material.dart';

class MainTopicItem extends StatelessWidget {
  const MainTopicItem({
    Key key,
    @required this.title,
    @required this.number,
    @required this.bgColor,
  }) : super(key: key);

  final int number;
  final String title;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.width * 0.3,
      child: Card(
        color: bgColor,
        child: Container(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: FittedBox(
                  child: Image.asset(
                    'assets/images/volleyball_player.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 9.0,
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
