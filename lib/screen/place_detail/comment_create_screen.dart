import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/comment.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog.dart';

import '../../models/user_models/user.dart';
import '../../provider/app_theme.dart';
import '../../provider/places.dart';
import '../../provider/user_info.dart';
import '../../widget/main_drawer.dart';

class CommentCreateScreen extends StatefulWidget {
  static const routeName = '/comment-CommentCreateScreen';

  @override
  _CommentCreateScreenState createState() => _CommentCreateScreenState();
}

class _CommentCreateScreenState extends State<CommentCreateScreen> {
  final reviewTextController = TextEditingController();
  var _isLoading = false;

  User user;

  Place loadedPlace;

  Comment comment;

  @override
  void initState() {
    user = Provider.of<UserInfo>(context, listen: false).user;

    reviewTextController.text = '';

    super.initState();
  }

  @override
  void dispose() {
    reviewTextController.dispose();

    super.dispose();
  }

  Future<void> createCommentReply(
      int placeId, String content, int parentId) async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Places>(context, listen: false)
        .sendCommentReply(placeId, content, parentId)
        .then((value) async {
      await Provider.of<Places>(context, listen: false)
          .retrieveComment(placeId);
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _showLoginDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialog(
              title: 'تشکر',
              buttonText: 'خب',
              description:
                  'نظر شما با موفقیت ثبت شد\n بعد از تایید نمایش داده خواهد شد',
            ));
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    double deviceHeight = MediaQuery.of(context).size.height;

    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    loadedPlace = Provider.of<Places>(context).itemPlace;

    comment = ModalRoute.of(context).settings.arguments as Comment;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
        ),

        endDrawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors
                .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),
        // resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: deviceHeight * 0.9,
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 35),
                              child: Container(
                                color: Colors.white,
                                child: Form(
                                  child: Container(
                                    height: deviceHeight * 0.3,
                                    child: TextFormField(
                                        maxLines: 10,
                                        controller: reviewTextController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          alignLabelWithHint: true,
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 15.0,
                                          ),
                                          labelText:
                                              'نظر خود را در اینجا بنویسید',
//                                      hintText: 'نظر خود را در اینجا بنویسید'
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                            : Container()),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createCommentReply(
                    loadedPlace.parent_id == null
                        ? loadedPlace.id
                        : loadedPlace.parent_id,
                    reviewTextController.text,
                    comment.id)
                .then((_) {
              Navigator.of(context).pop();

              _showLoginDialog();
            });
          },
          backgroundColor: AppTheme.buttonColor,
          child: Icon(
            Icons.check,
            color: AppTheme.white,
          ),
        ),
      ),
    );
  }
}

// class InfoEditItem extends StatelessWidget {
//   const InfoEditItem({
//     Key key,
//     @required this.title,
//     @required this.controller,
//     @required this.keybordType,
//     @required this.bgColor,
//     @required this.iconColor,
//   }) : super(key: key);
//
//   final String title;
//   final TextEditingController controller;
//   final TextInputType keybordType;
//
//   final Color bgColor;
//   final Color iconColor;
//
//   @override
//   Widget build(BuildContext context) {
//     double deviceHeight = MediaQuery.of(context).size.height;
//     double deviceWidth = MediaQuery.of(context).size.width;
//     var textScaleFactor = MediaQuery.of(context).textScaleFactor;
//
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         width: deviceWidth * 0.8,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Container(
//             child: Wrap(
//               children: <Widget>[
//                 Icon(
//                   Icons.arrow_right,
//                   color: iconColor,
//                 ),
//                 Text(
//                   '$title : ',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontFamily: 'Iransans',
//                     fontSize: textScaleFactor * 13.0,
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   child: Form(
//                     child: Container(
//                       height: deviceHeight * 0.05,
//                       child: TextFormField(
//                         keyboardType: keybordType,
//                         onEditingComplete: () {},
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'لطفا مقداری را وارد نمایید';
//                           }
//                           return null;
//                         },
//                         textInputAction: TextInputAction.none,
//                         controller: controller,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           labelStyle: TextStyle(
//                             color: Colors.blue,
//                             fontFamily: 'Iransans',
//                             fontSize: textScaleFactor * 10.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
