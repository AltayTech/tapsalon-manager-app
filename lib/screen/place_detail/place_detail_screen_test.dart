import 'package:flutter/material.dart';

import '../../provider/app_theme.dart';
import '../../widget/main_drawer.dart';

class PlaceDetailScreenTest extends StatefulWidget {
  static const routeName = '/PlaceDetailScreenTest';

  @override
  _PlaceDetailScreenTestState createState() => _PlaceDetailScreenTestState();
}

class _PlaceDetailScreenTestState extends State<PlaceDetailScreenTest>
    with SingleTickerProviderStateMixin {
  bool _isInit = true;

  double dy;

  double dx;

  double h;

  double w;

  double wFinal;

  double hFinal;

  double xFinal;

  double yFinal;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      dy = 0;

      dx = 0;

      xFinal = 0;

      yFinal = 0;

      h = 50;

      w = 50;

      wFinal = 0;

      hFinal = 0;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 8),
        child: Container(
          width: deviceWidth * 0.93,
          height: deviceHeight * 0.5,
          decoration: BoxDecoration(
              color: AppTheme.white,
              border: Border.all(width: 5, color: AppTheme.bg),
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Positioned(
                top: dy,
                right: dx,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    dx = -details.localPosition.translate(xFinal, yFinal).dx;
                    dy = details.localPosition.translate(xFinal, yFinal).dy;
                    setState(() {});
                  },
                  onPanEnd: (details) {
                    xFinal = -dx - 25;
                    yFinal = dy - 25;
                  },
                  child: Row(
                    children: [
                      GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          w = -details.localPosition.dx;

                          setState(() {});
                        },
                        onHorizontalDragEnd: (details) {
                          wFinal = !(wFinal + w).isNegative
                              ? (wFinal + w).abs().toDouble()
                              : 0;
                        },
                        child: Container(
                          color: Colors.black,
                          child: SizedBox(
                            height: 15,
                            width: 15,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onVerticalDragUpdate: (details) {
                              h = details.localPosition.dy;

                              setState(() {});
                            },
                            onVerticalDragEnd: (details) {
//                              wFinal = !(wFinal + w).isNegative
//                                  ? (wFinal + w).abs().toDouble()
//                                  : 0;
                              hFinal = !(hFinal + h).isNegative
                                  ? (hFinal + h).abs().toDouble()
                                  : 0;
                            },
                            child: Container(
                              color: Colors.black,
                              child: SizedBox(
                                height: 15,
                                width: 15,
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.red,
                            child: SizedBox(
                              height: !(hFinal + h).isNegative
                                  ? (hFinal + h).abs().toDouble()
                                  : 0,
                              width: !(wFinal + w).isNegative
                                  ? (wFinal + w).abs().toDouble()
                                  : 0,
                            ),
                          ),
                          GestureDetector(
                            onVerticalDragUpdate: (details) {
                              h = details.localPosition.dy;

                              setState(() {});
                            },
                            onVerticalDragEnd: (details) {
//                              wFinal = !(wFinal + w).isNegative
//                                  ? (wFinal + w).abs().toDouble()
//                                  : 0;
                              hFinal = !(hFinal + h).isNegative
                                  ? (hFinal + h).abs().toDouble()
                                  : 0;
                            },
                            child: Container(
                              color: Colors.black,
                              child: SizedBox(
                                height: 15,
                                width: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          w = -details.localPosition.dx;

                          setState(() {});
                        },
                        onHorizontalDragEnd: (details) {
                          wFinal = !(wFinal + w).isNegative
                              ? (wFinal + w).abs().toDouble()
                              : 0;
                        },
                        onPanUpdate: (details) {
                          dx = -details.localPosition.translate(xFinal, yFinal).dx;
                          dy = details.localPosition.translate(xFinal, yFinal).dy;
                          setState(() {});
                        },
                        onPanEnd: (details) {
                          xFinal = -dx - 25;
                          yFinal = dy - 25;
                        },
                        child: Container(
                          color: Colors.black,
                          child: SizedBox(
                            height: 15,
                            width: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors.white),
        child: MainDrawer(),
      ),
    );
  }
}
