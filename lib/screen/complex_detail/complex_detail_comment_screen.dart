import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/comment.dart';
import 'package:tapsalon_manager/models/complex.dart';
import 'package:tapsalon_manager/models/searchDetails.dart';
import 'package:tapsalon_manager/provider/complexes.dart';
import 'package:tapsalon_manager/widget/comment_item.dart';
import 'package:tapsalon_manager/widget/en_to_ar_number_convertor.dart';

import 'comment_create_screen.dart';

class ComplexDetailCommentScreen extends StatefulWidget {
  final Complex complex;

  ComplexDetailCommentScreen({this.complex});

  @override
  _ComplexDetailCommentScreenState createState() =>
      _ComplexDetailCommentScreenState();
}

class _ComplexDetailCommentScreenState
    extends State<ComplexDetailCommentScreen> {
  final double rateRadious = 40;

  final double rateLineWidth = 4.0;

  final int rateAnimDuration = 1200;
  var _isLoading;
  bool _isInit = true;

  List<Comment> loadedComment;

  SearchDetails loadedCommentsDetail;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      commentItems();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> commentItems() async {
    setState(() {
      _isLoading = true;
    });

    print(widget.complex.id);
    await Provider.of<Complexes>(context, listen: false)
        .retrieveComment(widget.complex.id);
    loadedComment =
        Provider.of<Complexes>(context, listen: false).itemsComments;
    loadedCommentsDetail =
        Provider.of<Complexes>(context, listen: false).commentsSearchDetails;

    print(_isLoading.toString());

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final TextStyle rateStyle = TextStyle(
      fontFamily: 'Iransans',
      fontSize: textScaleFactor * 11.0,
    );

    return Stack(
      children: <Widget>[
        _isLoading
            ? Align(
                alignment: Alignment.center,
                child: SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index.isEven
                            ? AppTheme.spinerColor
                            : AppTheme.spinerColor,
                      ),
                    );
                  },
                ),
              )
            : Container(
                child: loadedComment.isEmpty
                    ? Center(
                        child: Text(
                        'نظری ثبت نشده است',
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 15.0,
                        ),
                      ))
                    : Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  ' تعداد نظرات: ',
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 14.0,
                                  ),
                                ),
                                Text(
                                  EnArConvertor().replaceArNumber(
                                      loadedCommentsDetail.total.toString()),
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 14.0,
                                  ),
                                ),
                                Spacer(),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: SmoothStarRating(
                                      allowHalfRating: false,
                                      starCount: 5,
                                      rating: widget.complex.stars,
                                      size: 20.0,
                                      color: Colors.green,
                                      borderColor: Colors.green,
                                      spacing: 0.0),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CircularPercentIndicator(
                                radius: rateRadious,
                                lineWidth: rateLineWidth,
                                percent: widget.complex.stars / 5,
                                animation: true,
                                animationDuration: rateAnimDuration,
                                circularStrokeCap: CircularStrokeCap.round,
                                footer: Text(
                                  'دسترسی',
                                  style: rateStyle,
                                ),
                                center: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    EnArConvertor().replaceArNumber(
                                        widget.complex.stars.toString()),
                                    style: rateStyle,
                                  ),
                                )),
                                progressColor: Colors.purple,
                                addAutomaticKeepAlive: true,
                              ),
                              CircularPercentIndicator(
                                radius: rateRadious,
                                lineWidth: rateLineWidth,
                                percent: widget.complex.stars / 5,
                                animation: true,
                                animationDuration: rateAnimDuration,
                                circularStrokeCap: CircularStrokeCap.round,
                                footer: Text(
                                  'امکانات',
                                  style: rateStyle,
                                ),
                                center: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    EnArConvertor().replaceArNumber(
                                        widget.complex.stars.toString()),
                                    style: rateStyle,
                                  ),
                                )),
                                progressColor: Colors.purple,
                                addAutomaticKeepAlive: true,
                              ),
                              CircularPercentIndicator(
                                radius: rateRadious,
                                lineWidth: rateLineWidth,
                                percent: widget.complex.stars / 5,
                                animation: true,
                                animationDuration: rateAnimDuration,
                                circularStrokeCap: CircularStrokeCap.round,
                                footer: Text(
                                  'تمیزی',
                                  style: rateStyle,
                                ),
                                center: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    EnArConvertor().replaceArNumber(
                                        widget.complex.stars.toString()),
                                    style: rateStyle,
                                  ),
                                )),
                                progressColor: Colors.purple,
                                addAutomaticKeepAlive: true,
                              ),
                              CircularPercentIndicator(
                                radius: rateRadious,
                                lineWidth: rateLineWidth,
                                percent: widget.complex.stars / 5,
                                animation: true,
                                animationDuration: rateAnimDuration,
                                circularStrokeCap: CircularStrokeCap.round,
                                footer: Text(
                                  'برخورد کارکنان',
                                  style: rateStyle,
                                ),
                                center: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    EnArConvertor().replaceArNumber(
                                        widget.complex.stars.toString()),
                                    style: rateStyle,
                                  ),
                                )),
                                progressColor: Colors.purple,
                                addAutomaticKeepAlive: true,
                              ),
                              CircularPercentIndicator(
                                radius: rateRadious,
                                lineWidth: rateLineWidth,
                                percent: widget.complex.stars / 5,
                                animation: true,
                                animationDuration: rateAnimDuration,
                                circularStrokeCap: CircularStrokeCap.round,
                                footer: Text(
                                  'قیمت',
                                  style: rateStyle,
                                ),
                                center: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    EnArConvertor().replaceArNumber(
                                        widget.complex.stars.toString()),
                                    style: rateStyle,
                                  ),
                                )),
                                progressColor: Colors.purple,
                                addAutomaticKeepAlive: true,
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: deviceHeight * 0.8,
                            child: ListView.builder(
//                              shrinkWrap: true,
//                                physics: NeverScrollableScrollPhysics(),

                              scrollDirection: Axis.vertical,
                              itemCount: loadedComment.length,
                              itemBuilder: (ctx, i) =>
                                  ChangeNotifierProvider.value(
                                value: loadedComment[i],
                                child: CommentItem(
                                  comment: loadedComment[i],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
        Positioned(
          bottom: 10,
          left: 10,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CommentCreateScreen.routeName,
                  arguments: widget.complex.id);
            },
            elevation: 3,
            child: Icon(
              Icons.add,
            ),
          ),
        )
      ],
    );
  }
}
