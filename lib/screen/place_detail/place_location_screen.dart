import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/models/places_models/place_in_search.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/widget/items/map_info_windows_item.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';
class PlaceLocationScreen extends StatefulWidget {
  static const routeName = '/PlaceLocationScreen';

  @override
  _PlaceLocationScreenState createState() => _PlaceLocationScreenState();
}

class _PlaceLocationScreenState extends State<PlaceLocationScreen>
    with TickerProviderStateMixin {
  bool _isInit = true;
  var _isLoading = false;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController myController;
  static const LatLng _center = const LatLng(38.074065, 46.312711);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  double speed;

  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  BitmapDescriptor salonBitmapDescriptor = BitmapDescriptor.defaultMarker;
  BitmapDescriptor gymBitmapDescriptor = BitmapDescriptor.defaultMarker;
  BitmapDescriptor entBitmapDescriptor = BitmapDescriptor.defaultMarker;

  Place selectedPlace;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      searchItem();
      _lastMapPosition =
          LatLng(selectedPlace.latitude, selectedPlace.longitude);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> searchItem() async {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    selectedPlace = arguments != null ? arguments['place'] : Place();
   await setCustomMapPin();

    _onAddMarker(selectedPlace);
    changePick(selectedPlace);
  }

  Future<void> changePick(Place placeInSearch) async {
    setState(() {});
    selectedPlace = placeInSearch;

    _animationController.forward();
    setState(() {});
  }

  void _onAddMarker(Place place) async {
    _markers.clear();
    print(place.latitude);
    print(place.longitude);
    var latLng = LatLng(place.latitude, place.longitude);
    var pinLocationIcon;
    if (place.placeType.id == 1) {
      pinLocationIcon = pinLocationIconSalon;
    } else if (place.placeType.id == 2) {
      pinLocationIcon = pinLocationIconEnt;
    } else if (place.placeType.id == 3) {
      pinLocationIcon = pinLocationIconGym;
    } else {
      pinLocationIcon = pinLocationIconSalon;
    }

    _markers.add(Marker(
      markerId: MarkerId(place.id.toString()),
      onTap: () {
        changePick(place);
      },
      infoWindow: InfoWindow(
        title: place.name,
      ),
      position: latLng,
      icon: pinLocationIcon,
    ));
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
    _controller.complete(controller);
  }

  Geolocator _geolocator;
  Position _position;

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  BitmapDescriptor pinLocationIconSalon;
  BitmapDescriptor pinLocationIconEnt;
  BitmapDescriptor pinLocationIconGym;

  void setCustomMapPin() async {
    print('setCustomMapPin');

    pinLocationIconSalon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        'assets/images/marker_ic_1_v1.png',
        mipmaps: true);
    pinLocationIconEnt = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        'assets/images/marker_ic_2_v1.png',
        mipmaps: true);
    pinLocationIconGym = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        'assets/images/marker_ic_3_v1.png',
        mipmaps: true);
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1600,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(3, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _geolocator = Geolocator();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    checkPermission();

    _geolocator.getPositionStream(locationOptions).listen((Position position) {
      _position = position;
    });
    setCustomMapPin();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
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
      body: Directionality(
        textDirection: TextDirection.rtl,
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
            : Stack(
                children: <Widget>[
                  Column(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _lastMapPosition,
                            zoom: 11.0,
                          ),
                          mapType: _currentMapType,
                          markers: _markers,
                          onCameraMove: _onCameraMove,
                          myLocationEnabled: true,
                          compassEnabled: true,
                          scrollGesturesEnabled: true,
                          mapToolbarEnabled: true,
                          myLocationButtonEnabled: true,
                          zoomGesturesEnabled: true,
                        ),
                      ),
                      Container(
                        height: deviceWidth * 0.5,
                        child: AnimatedContainer(
                          duration: _animationController.duration,
                          curve: Curves.easeIn,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: MapInfoWindowItem(
                                selectedPlace: PlaceInSearch(
                                  id: selectedPlace.id,
                                  name: selectedPlace.name,
                                  image: selectedPlace.image,
                                  rate: selectedPlace.rate,
                                  price: selectedPlace.price,
                                  address: selectedPlace.address,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                          : Container(),
                    ),
                  ),
                ],
              ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}
