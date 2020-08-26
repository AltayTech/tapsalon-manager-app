import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/image.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/provider/places.dart';
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

  Future<void> addPicture(String title) async {
    print('addPicture');

    ImageSource imageSource =
        Provider.of<Places>(context, listen: false).imageSource;

    print('imageSource');

    PickedFile pickedFile = await ImagePicker().getImage(source: imageSource);

    _image = File(pickedFile.path);

    print('ImagePicker');
  }

  Future<void> getImage() async {
    setState(() {
      _isLoading = true;
    });

    await showDialog(
        context: context, builder: (ctx) => CustomDialogSelectImagePicker());

    await addPicture(place.name);

    if (_image != null) {
      await Provider.of<Places>(context, listen: false).uploadImage(
        _image,
        place.id,
      );
    }

    await Provider.of<Places>(context, listen: false).retrievePlace(placeId);

    place = Provider.of<Places>(context, listen: false).itemPlace;

    gallery = place.gallery;

    Provider.of<Places>(context, listen: false).placeInSend.gallery =
        getIdList(gallery);

    Provider.of<Places>(context, listen: false).placeInSend.id=place.id;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> removeImage(ImageObj image) async {
    setState(() {
      _isLoadingremoveImage = true;
    });

    await Provider.of<Places>(context, listen: false).deleteImage(image.id);

    await gallery.removeAt(gallery.indexOf(image));

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

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    double deviceWidth = MediaQuery.of(context).size.width;

    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appBarColor,
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
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
                :
//              AnimatedList(itemBuilder: (ctx, i, animation) {
//                      return ChangeNotifierProvider.value(
//                        value: place.image[i],
//                        child: SlideTransition(
//                          position: animation.drive(
//                            Tween<Offset>(
//                              begin: Offset(3, 0),
//                              end: Offset(0, 0),
//                            ),
//                          ),
//                          child: Container(
//                            height: deviceHeight * 0.15,
//                            child: Stack(
//                              children: <Widget>[
//                                FadeInImage(
//                                  placeholder: AssetImage(
//                                      'assets/images/tapsalon_icon_200.png'),
//                                  image:
//                                      NetworkImage(place.image[i].url.medium),
//                                  fit: BoxFit.cover,
//                                ),
//                                Positioned(
//                                  top: 5,
//                                  right: 5,
//                                  child: InkWell(
//                                    onTap: () {
//                                      removeImage(place.image[i].id);
//                                    },
//                                    child: Card(
//                                      color: Colors.white.withOpacity(0.3),
//                                      child: Icon(Icons.clear,
//                                          size: 25, color: Colors.black),
//                                    ),
//                                  ),
//                                ),
//                                _isLoadingremoveImage
//                                    ? Align(
//                                        alignment: Alignment.center,
//                                        child: SpinKitFadingCircle(
//                                          itemBuilder: (BuildContext context,
//                                              int index) {
//                                            return DecoratedBox(
//                                              decoration: BoxDecoration(
//                                                shape: BoxShape.circle,
//                                                color: index.isEven
//                                                    ? AppTheme.spinerColor
//                                                    : AppTheme.spinerColor,
//                                              ),
//                                            );
//                                          },
//                                        ),
//                                      )
//                                    : Container(),
//                              ],
//                            ),
//                          ),
//                        ),
//                      );
//                    }),

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
                              child: Card(
                                color: Colors.white.withOpacity(0.3),
                                child: Checkbox(
                                  onChanged: (value) {
                                    selectedImageId = place.gallery[i].id;
                                    setState(() {});
                                  },
                                  value: selectedImageId == place.gallery[i].id
                                      ? true
                                      : false,
                                ),
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
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}
