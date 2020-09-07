import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/imageObj.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/provider/places.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog.dart';
import 'package:tapsalon_manager/widget/dialogs/custom_dialog_select_image_picker.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';

class PlaceGalleryEditScreen extends StatefulWidget {
  static const routeName = '/PlaceGalleryEditScreen';

  @override
  _PlaceGalleryEditScreenState createState() => _PlaceGalleryEditScreenState();
}

class _PlaceGalleryEditScreenState extends State<PlaceGalleryEditScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;

  var _isLoadingremoveImage = false;

  bool _isInit = true;

  Place place;

  File _image;

  int selectedImageId;

  var placeId;

  List<ImageObj> gallery = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final Map arguments = ModalRoute.of(context).settings.arguments as Map;

      placeId = arguments['placeId'];

      place = arguments['place'];

      await Provider.of<Places>(context, listen: false).retrievePlace(placeId);

      place = Provider.of<Places>(context, listen: false).itemPlace;

      gallery = place.gallery;
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  Future<bool> addPicture(String title) async {
    print('addPicture');

    ImageSource imageSource =
        Provider.of<Places>(context, listen: false).imageSource;

    print('imageSource');

    PickedFile pickedFile = await ImagePicker().getImage(source: imageSource);
    print('pickedFile' + pickedFile.toString());

    if (pickedFile == null) {
      return false;
    } else {
      _image = File(pickedFile.path);

      return true;
    }
  }

  Future<void> selectImageResource() async {
    await showDialog(
        context: context,
        builder: (ctx) => CustomDialogSelectImagePicker()).then((value) async {
      if (value == null) {
        print('null');
        return;
      } else if (value) {
        print('true');
        await getImage();
      } else {
        print('false');
        return;
      }
    });
  }

  Future<void> getImage() async {
    setState(() {
      _isLoading = true;
    });

    await addPicture(place.name).then((value) async {
      print('sdfsdfsdfsdfs' + value.toString());
      if (_image != null) {
        await Provider.of<Places>(context, listen: false).uploadImage(
          _image,
          place.id,
        );
      }
    });
    await Provider.of<Places>(context, listen: false).retrievePlace(placeId);

    place = Provider.of<Places>(context, listen: false).itemPlace;

    gallery = place.gallery;

    Provider.of<Places>(context, listen: false).placeInSend.gallery =
        getIdList(gallery);

    Provider.of<Places>(context, listen: false).placeInSend.id = place.id;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> removeImage(ImageObj image) async {
    setState(() {
      _isLoadingremoveImage = true;
    });

    await Provider.of<Places>(context, listen: false).deleteImage(image.id);

    gallery.removeAt(gallery.indexOf(image));

    Provider.of<Places>(context, listen: false).placeInSend.gallery =
        getIdList(gallery);

    setState(() {
      _isLoadingremoveImage = false;
    });
  }

  List<int> getIdList(List<dynamic> list) {
    List<int> idList = [];

    for (int i = 0; i < list.length; i++) {
      idList.add(list[i].id);
    }

    return idList;
  }

  Future<int> sendChange() async {
    setState(() {
      _isLoading = true;
    });

    int placeId =
        await Provider.of<Places>(context, listen: false).modifyPlace();

    if (placeId != 0) {
      _showLoginDialog();
    } else {}

    setState(() {
      _isLoading = false;
    });
    return placeId;
  }

  void _showLoginDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialog(
              title: 'تشکر',
              buttonText: 'خب',
              description:
                  ' تغییرات با موفقیت ثبت شد\n بعد از تایید نمایش داده خواهد شد',
            ));
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    double deviceWidth = MediaQuery.of(context).size.width;

    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ویرایش گالری',
          style: TextStyle(
            color: Colors.black,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: deviceHeight * 0.8,
          child: _isLoading
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
              : Stack(
                  children: [
                    GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: place.gallery.length,
                      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                        value: place.gallery[i],
                        child: Container(
                          height: deviceHeight * 0.15,
                          child: Stack(
                            children: <Widget>[
                              FadeInImage(
                                placeholder: AssetImage(
                                    'assets/images/tapsalon_icon_200.png'),
                                image: NetworkImage(
                                  place.gallery[i].url.medium,
                                ),
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: InkWell(
                                  onTap: () {
                                    removeImage(place.gallery[i]);
                                  },
                                  child: Card(
                                    color: Colors.white.withOpacity(0.3),
                                    child: Icon(Icons.clear,
                                        size: 25, color: Colors.white),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                left: 5,
                                height: 35,
                                width: 35,
                                child: Checkbox(
                                  onChanged: (value) {
                                    selectedImageId = place.gallery[i].id;

                                    Provider.of<Places>(context, listen: false)
                                        .placeInSend
                                        .image = place.gallery[i].id;
                                    setState(() {});
                                  },
                                  value: selectedImageId == place.gallery[i].id
                                      ? true
                                      : false,
                                ),
                              ),
                              _isLoadingremoveImage
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: SpinKitFadingCircle(
                                        itemBuilder:
                                            (BuildContext context, int index) {
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
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    ),
                    Positioned(
                      right: 20,
                      left: 20,
                      bottom: 20,
                      height: 60,
                      child: RaisedButton(
                        color: AppTheme.buttonColor,
                        onPressed: () async {
                          await sendChange().then((value) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
//                          Navigator.of(context).pushNamedAndRemoveUntil(
//                              NavigationBottomScreen.routeName,
//                                  (Route<dynamic> route) => false);
                          });
                        },
                        child: Text(
                          'تایید اطلاعات',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Iransans',
                            color: AppTheme.white,
                            fontSize: textScaleFactor * 14.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await selectImageResource();
        },
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
          size: 35,
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
