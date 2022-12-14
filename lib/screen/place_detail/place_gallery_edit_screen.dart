import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
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
  TabController _tabController;

  var title;

  var image_url;

  String stars;

  bool isLike = false;

  Place place;

  File _image;

  int selectedImageId;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    // TODO: implement initState
    super.initState();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final Map arguments = ModalRoute.of(context).settings.arguments as Map;

      place = arguments['place'];
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> addPicture(String title) async {
    print('addPicture');

    ImageSource imageSource =
        await Provider.of<Places>(context, listen: false).imageSource;

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
    await addPicture(title);
    print(_image.path);

    if (_image != null) {
      await Provider.of<Places>(context, listen: false).uploadImage(
        _image,
        place.id,
      );
    }
    await Provider.of<Places>(context, listen: false).retrievePlace(place.id);
    place = Provider.of<Places>(context, listen: false).itemPlace;
    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> removeImage(int imageId) async {
    setState(() {
      _isLoadingremoveImage = true;
    });

    await Provider.of<Places>(context, listen: false).deleteImage(imageId);

    await Provider.of<Places>(context, listen: false).retrievePlace(place.id);
    place = Provider.of<Places>(context, listen: false).itemPlace;
    setState(() {
      _isLoadingremoveImage = false;
      print(_isLoadingremoveImage.toString());
    });
    print(_isLoadingremoveImage.toString());
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
        child: Column(
          children: <Widget>[
            FittedBox(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  getImage();
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                    Text(
                      '???????????? ??????',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Iransans',
                        fontSize: textScaleFactor * 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
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
                                    removeImage(place.gallery[i].id);
                                  },
                                  child: Card(
                                    color: Colors.white.withOpacity(0.3),
                                    child: Icon(Icons.clear,
                                        size: 25, color: Colors.black),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                left: 5,
                                child: Card(
                                  color: Colors.white.withOpacity(0.3),
                                  child: Checkbox(
                                    onChanged: (value) {
                                      selectedImageId = place.gallery[i].id;
                                      print(selectedImageId);
                                      setState(() {});
                                    },
                                    value:
                                        selectedImageId == place.gallery[i].id
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(selectedImageId);

//          editComplex().then((v) {
//            Navigator.of(context).pop();
//          });
        },
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
