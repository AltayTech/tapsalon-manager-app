import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tapsalon_manager/models/imageObj.dart';

class CustomDialogShowPicture extends StatelessWidget {
  final ImageObj image;

  CustomDialogShowPicture({
    this.image,
  });

  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: EdgeInsets.all(0),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Hero(
          tag: image.id,
          child: PhotoView(
            imageProvider:image.url.large.startsWith('assets/images')? AssetImage(image.url.large):NetworkImage(image.url.large),
            filterQuality: FilterQuality.high,
            enableRotation: false,
          )),
    );
  }
}
