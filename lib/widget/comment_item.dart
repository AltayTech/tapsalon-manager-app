import 'package:flutter/material.dart';
import 'package:tapsalon_manager/models/comment.dart';
import 'package:tapsalon_manager/screen/place_detail/salon_detail_screen.dart';

import 'en_to_ar_number_convertor.dart';
class CommentItem extends StatelessWidget {
  final Comment comment;

  CommentItem({this.comment});

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().toString());
    print(DateTime.now()
        .difference(DateTime.parse(comment.created_at))
        .inDays
        .toString());
    print(DateTime.now()
        .compareTo(DateTime.parse(comment.created_at))
        .toString());
    print(DateTime.now().timeZoneName.toString());
    print(DateTime.now().timeZoneOffset.toString());
    print(DateTime.now().toIso8601String().toString());
    print(DateTime.now()
        .subtract(DateTime.now().difference(DateTime.parse(comment.created_at)))
        .toString());
    print(DateTime.now().toLocal().toString());
    print(DateTime.now()..toString());

    return LayoutBuilder(
      builder: (context, constraint) => InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(SalonDetailScreen.routeName, arguments: {
            'commentId': comment.id,
          });
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.account_circle,
                        color: Colors.blue,
                        size: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${comment.user.fname} ${comment.user.lname}',
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Iransans',
                            fontSize:
                                MediaQuery.of(context).textScaleFactor * 13.0,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        EnArConvertor().replaceArNumber(DateTime.now()
                            .difference(DateTime.parse(comment.created_at))
                            .inDays
                            .toString())
                         +
                            ' روز پیش',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          color: Colors.grey,
                          fontSize:
                              MediaQuery.of(context).textScaleFactor * 12.0,
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
                      bottom: 15,
                    ),
                    child: Text(
                      comment.content,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).textScaleFactor * 12.0,
                      ),
                    ),
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
