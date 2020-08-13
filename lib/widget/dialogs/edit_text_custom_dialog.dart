import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/provider/places.dart';

import '../main_drawer.dart';
import 'custom_dialog.dart';

class EditTextCustomDialog extends StatefulWidget {
  final String title;
  final String content;

  EditTextCustomDialog({
    this.title,
    this.content,
  });

  @override
  _EditTextCustomDialogState createState() => _EditTextCustomDialogState();
}

class _EditTextCustomDialogState extends State<EditTextCustomDialog> {
  final contentTextController = TextEditingController();
  var _isLoading = false;
  bool _isInit = true;

  var title = '';

  var content = '';

  @override
  void didChangeDependencies() async {
    if (_isInit) {
//      final Map arguments = ModalRoute.of(context).settings.arguments as Map;
      title = widget.title;
      content = widget.content;
      contentTextController.text = content;

      setState(() {});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    contentTextController.dispose();

    super.dispose();
  }

  Future<void> createComment(
      int placeId, String content, double rate, String subject) async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Places>(context, listen: false)
        .sendComment(placeId, content, rate, subject)
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
                            Wrap(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 13.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 35),
                              child: Container(
                                color: Colors.white,
                                child: Form(
                                  child: Container(
                                    height: deviceHeight * 0.3,
                                    child: TextFormField(
                                        maxLines: 10,
                                        controller: contentTextController,
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
            Navigator.of(context).pop(contentTextController.text);

            _showLoginDialog();
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

class InfoEditItem extends StatelessWidget {
  const InfoEditItem({
    Key key,
    @required this.title,
    @required this.controller,
    @required this.keybordType,
    @required this.bgColor,
    @required this.iconColor,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final TextInputType keybordType;

  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: deviceWidth * 0.8,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: Wrap(
              children: <Widget>[
                Icon(
                  Icons.arrow_right,
                  color: iconColor,
                ),
                Text(
                  '$title : ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 13.0,
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Form(
                    child: Container(
                      height: deviceHeight * 0.05,
                      child: TextFormField(
                        keyboardType: keybordType,
                        onEditingComplete: () {},
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'لطفا مقداری را وارد نمایید';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.none,
                        controller: controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 10.0,
                          ),
                        ),
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

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 10;
}
