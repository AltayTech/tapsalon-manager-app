import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/provider/places.dart';

import '../../models/comment.dart';
import '../en_to_ar_number_convertor.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;

  CommentItem({this.comment});

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  var _isLoading = false;

  String getDuration(String time) {
    String duration = EnArConvertor().replaceArNumber(
            DateTime.now().difference(DateTime.parse(time)).inDays.toString()) +
        ' روز پیش';
    Duration timeDuration = DateTime.now().difference(DateTime.parse(time));
    if (timeDuration.inDays > 0) {
      duration = EnArConvertor().replaceArNumber(DateTime.now()
              .difference(DateTime.parse(time))
              .inDays
              .toString()) +
          ' روز پیش';
    } else {
      if (timeDuration.inHours > 0) {
        duration = EnArConvertor().replaceArNumber(DateTime.now()
                .difference(DateTime.parse(time))
                .inHours
                .toString()) +
            ' ساعت پیش';
      } else {
        if (timeDuration.inMinutes > 0) {
          duration = EnArConvertor().replaceArNumber(DateTime.now()
                  .difference(DateTime.parse(time))
                  .inMinutes
                  .toString()) +
              ' دقیقه پیش';
        } else {
          duration = EnArConvertor().replaceArNumber(DateTime.now()
                  .difference(DateTime.parse(time))
                  .inSeconds
                  .toString()) +
              ' ثانیه پیش';
        }
      }
    }
    return duration;
  }

  Future<void> reportComment() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Places>(context, listen: false)
        .sendCommentReport(widget.comment.place_id, widget.comment.id);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return LayoutBuilder(
      builder: (context, constraint) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 2, color: AppTheme.primary, spreadRadius: 2),
              ],
              color: AppTheme.white,
//                          border: Border.all(width: 5, color: AppTheme.bg),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            color: Colors.blue,
                            size: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:5,right: 5),
                            child: Text(
                              '${widget.comment.user.fname}',
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 13.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            getDuration(widget.comment.createdAt),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Iransans',
                              color: Colors.grey,
                              fontSize: textScaleFactor * 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 30.0,
                          left: 30,
                          bottom: 15,
                        ),
                        child: Text(
                          widget.comment.content,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Iransans',
                            color: AppTheme.black,
                            fontSize: textScaleFactor * 14.0,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                             left: 10, top: 1),
                          child: InkWell(
                            onTap: () async{
                              SnackBar sendReportSnackBar = SnackBar(
                                content: Text(
                                  'گزارش شما ارسال شد',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 14.0,
                                  ),
                                ),
                                action: SnackBarAction(
                                  label: 'متوجه شدم',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              await reportComment();
                              Scaffold.of(context).showSnackBar(sendReportSnackBar);


                            },
                            child: Text(
                              'گزارش نظر',
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Iransans',
                                color: AppTheme.iconColor,
                                fontSize: textScaleFactor * 12.0,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 1, left: 3.0, top: 1,),
                          child: Icon(
                            Icons.star,
                            color: AppTheme.iconColor,
                            size: 25,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 5, top: 8),
                          child: Text(
                            EnArConvertor().replaceArNumber(
                              widget.comment.rate.toString(),
                            ),

                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(

                              fontFamily: 'Iransans',
                              color: AppTheme.grey,
                              fontSize: textScaleFactor * 16.0,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: _isLoading
                        ? SpinKitFadingCircle(
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
                          )
                        : Container(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
