import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/provider/places.dart';


class CustomDialogSelectImagePicker extends StatefulWidget {
  @override
  _CustomDialogSelectImagePickerState createState() =>
      _CustomDialogSelectImagePickerState();
}

class _CustomDialogSelectImagePickerState
    extends State<CustomDialogSelectImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) => Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: Consts.avatarRadius + Consts.padding,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  '',
                  style: TextStyle(
                    color: Color(0xff0197F6),
                    fontSize: MediaQuery.of(context).textScaleFactor * 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'لطفا انتخاب کنید',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: MediaQuery.of(context).textScaleFactor * 14,
                  ),
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () async {
                             Provider.of<Places>(context,
                                    listen: false)
                                .imageSource = ImageSource.gallery;
                            return
                              Navigator.of(context).pop();
                          },
                          child: Container(
                            height: constraint.maxHeight * 0.08,
                            width: constraint.maxWidth * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Wrap(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3.0, right: 5),
                                    child: Text(
                                      'گالری',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Iransans',
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            16,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () {
                            Provider.of<Places>(context,
                                listen: false)
                                .imageSource = ImageSource.camera;
                            return
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: constraint.maxHeight * 0.08,
                            width: constraint.maxWidth * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Wrap(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, right: 10),
                                    child: Text(
                                      'دوربین',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Iransans',
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            16,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 10;
}
