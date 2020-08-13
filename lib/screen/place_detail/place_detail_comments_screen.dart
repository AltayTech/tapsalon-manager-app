import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/comment.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/models/searchDetails.dart';
import 'package:tapsalon_manager/provider/auth.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog_enter.dart';
import 'package:tapsalon_manager/widget/en_to_ar_number_convertor.dart';
import 'package:tapsalon_manager/widget/items/comment_item.dart';

import '../../provider/app_theme.dart';
import '../../provider/places.dart';
import '../../widget/main_drawer.dart';
import 'comment_create_screen.dart';

class PlaceDetailCommentsScreen extends StatefulWidget {
  static const routeName = '/PlaceDetailCommentsScreen';

  @override
  _PlaceDetailCommentsScreenState createState() =>
      _PlaceDetailCommentsScreenState();
}

class _PlaceDetailCommentsScreenState extends State<PlaceDetailCommentsScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading;
  bool _isInit = true;

  Place loadedPlace;

  List<Comment> loadedComment = [];

  SearchDetails loadedCommentsDetail;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await searchItems();

      commentItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> commentItems() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Places>(context, listen: false)
        .retrieveComment(loadedPlace.id);
    loadedComment = Provider.of<Places>(context, listen: false).itemsComments;
    loadedCommentsDetail =
        Provider.of<Places>(context, listen: false).commentsSearchDetails;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    loadedPlace = arguments['place'];
//    loadedPlace = Provider.of<Places>(context, listen: false).itemPlace;
    setState(() {
      _isLoading = false;
    });
  }

  void _showLoginDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialogEnter(
              title: 'ورود',
              buttonText: 'صفحه ورود ',
              description: 'برای ادامه باید وارد شوید',
            ));
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    bool isLogin = Provider.of<Auth>(context, listen: false).isAuth;

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
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: _isLoading
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
          : Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.grey.withOpacity(0.3),
                                blurRadius: 6,
                                spreadRadius: 3,
                                offset: Offset(
                                  0,
                                  0,
                                ),
                              ),
                            ]),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 10),
                                child: Text(
                                  loadedPlace.name.isNotEmpty
                                      ? loadedPlace.name
                                      : '',
                                  style: TextStyle(
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: deviceWidth * 0.75,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 1,
                                          left: 3.0,
                                          top: 1,
                                          bottom: 4),
                                      child: Icon(
                                        Icons.star,
                                        color: AppTheme.iconColor,
                                        size: 25,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 5,
                                          left: 10,
                                          top: 1,
                                          bottom: 4),
                                      child: Text(
                                        EnArConvertor().replaceArNumber(
                                          loadedPlace.rate.toString(),
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
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 1,
                                          left: 3.0,
                                          top: 1,
                                          bottom: 4),
                                      child: Icon(
                                        Icons.comment,
                                        color: AppTheme.iconColor,
                                        size: 25,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 5,
                                          left: 10,
                                          top: 4,
                                          bottom: 1),
                                      child: Text(
                                        EnArConvertor().replaceArNumber(
                                          loadedPlace.comments_count.toString(),
                                        ),
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Iransans',
                                          color: AppTheme.grey,
                                          fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                              16.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: deviceWidth * 0.92,
                      height: deviceHeight * 0.69,
                      decoration: BoxDecoration(
                          color: AppTheme.bg,
                          borderRadius: BorderRadius.circular(10)),
                      child: Consumer<Places>(
                        builder: (context, value, child) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: value.itemsComments.length,
                            itemBuilder: (ctx, i) =>
                                ChangeNotifierProvider.value(
                              value: value.itemsComments[i],
                              child: CommentItem(
                                comment: value.itemsComments[i],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.buttonColor,
        child: Icon(
          Icons.add,
          color: AppTheme.white,
        ),
        onPressed: () {
          if (isLogin) {
            Navigator.pushNamed(context, CommentCreateScreen.routeName,
                arguments: loadedPlace.id);
          } else {
            _showLoginDialog();
          }
        },
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
