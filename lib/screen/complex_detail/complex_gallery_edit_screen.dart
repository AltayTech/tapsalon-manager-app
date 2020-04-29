import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/complex.dart';
import 'package:tapsalon_manager/provider/complexes.dart';
import 'package:tapsalon_manager/widget/custom_dialog_select_image_picker.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';

class ComplexGalleryEditScreen extends StatefulWidget {
  static const routeName = '/complex-gallaey-edit';

  @override
  _ComplexGalleryEditScreenState createState() =>
      _ComplexGalleryEditScreenState();
}

class _ComplexGalleryEditScreenState extends State<ComplexGalleryEditScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;
  var _isLoadingremoveImage = false;
  bool _isInit = true;
  TabController _tabController;

  var title;

  var image_url;

  String stars;

  bool isLike = false;

  Complex complex;

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
      complex = ModalRoute.of(context).settings.arguments as Complex;
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> addPicture(String title) async {
    print('addPicture');
    ImageSource imageSource =
        await Provider.of<Complexes>(context, listen: false).imageSource;
    print('imageSource');

    _image = await ImagePicker.pickImage(source: imageSource);
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
      await Provider.of<Complexes>(context, listen: false)
          .Upload(_image, 0, complex.id, title);
    }
    await Provider.of<Complexes>(context, listen: false)
        .retrieveComplex(complex.id);
    complex = Provider.of<Complexes>(context, listen: false).itemComplex;
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

    await Provider.of<Complexes>(context, listen: false).deleteImage(imageId);

    await Provider.of<Complexes>(context, listen: false)
        .retrieveComplex(complex.id);
    complex = Provider.of<Complexes>(context, listen: false).itemComplex;
    setState(() {
      _isLoadingremoveImage = false;
      print(_isLoadingremoveImage.toString());
    });
    print(_isLoadingremoveImage.toString());
  }

  Future<void> editComplex() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Complexes>(context, listen: false).editComplex(
      complex_id: complex.id,
      ostan_id: complex.ostan.id,
      city_id: complex.city.id,
      region_id: complex.region.id,
      name: complex.name,
      excerpt: complex.excerpt,
      about: complex.about,
      address: complex.address,
      phone: complex.phone,
      mobile: complex.mobile,
      latitude: complex.latitude,
      longitude: complex.longitude,
      image_id: selectedImageId,
    );

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
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
                      'افزودن عکس',
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
                      itemCount: complex.image.length,
                      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                        value: complex.image[i],
                        child: Container(
                          height: deviceHeight * 0.15,
                          child: Stack(
                            children: <Widget>[
                              FadeInImage(
                                placeholder: AssetImage(
                                    'assets/images/tapsalon_icon_200.png'),
                                image: NetworkImage(
                                  complex.image[i].url.medium,
                                ),
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: InkWell(
                                  onTap: () {
                                    removeImage(complex.image[i].id);
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
                                      selectedImageId = complex.image[i].id;
                                      print(selectedImageId);
                                      setState(() {});
                                    },
                                    value:
                                        selectedImageId == complex.image[i].id
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

          editComplex().then((v) {
            Navigator.of(context).pop();
          });
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
