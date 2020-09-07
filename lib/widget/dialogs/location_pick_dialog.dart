import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/provider/app_theme.dart';
import 'package:tapsalon_manager/provider/places.dart';

class LocationPickDialog extends StatefulWidget {
  final Place place;

  LocationPickDialog({
    this.place,
  });

  @override
  _LocationPickDialogState createState() => _LocationPickDialogState();
}

class _LocationPickDialogState extends State<LocationPickDialog> {
  bool _isInit = true;

  var _isLoading = false;

  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController myController;

  static const LatLng _center = const LatLng(38.074065, 46.312711);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  double speed;

  Place selectedPlace;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await searchItem();

      if (selectedPlace.latitude == 0 && selectedPlace.longitude == 0)
        _lastMapPosition =
            LatLng(selectedPlace.latitude, selectedPlace.longitude);
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> searchItem() async {
    selectedPlace = widget.place;

    await setCustomMapPin();

    _onAddMarker(selectedPlace.latitude, selectedPlace.longitude);
    setState(() {});
  }

  void _onAddMarker(
    double lat,
    double lng,
  ) async {
    _markers.clear();

    var latLng = LatLng(lat, lng);

    var pinLocationIcon;

    if (selectedPlace.placeType.id == 1) {
      pinLocationIcon = pinLocationIconSalon;
    } else if (selectedPlace.placeType.id == 2) {
      pinLocationIcon = pinLocationIconEnt;
    } else if (selectedPlace.placeType.id == 3) {
      pinLocationIcon = pinLocationIconGym;
    } else {
      pinLocationIcon = pinLocationIconSalon;
    }

    _markers.add(
      Marker(
        markerId: MarkerId(selectedPlace.id.toString()),
        infoWindow: InfoWindow(
          title: selectedPlace.name,
        ),
        position: latLng,
        icon: pinLocationIcon,
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    print(position.toString());
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

  BitmapDescriptor locationPickerIcon;

  Future<void> setCustomMapPin() async {
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
    locationPickerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        'assets/images/location_picker_ic.png',
        mipmaps: true);
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();

    _geolocator = Geolocator();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    checkPermission();

    _geolocator.getPositionStream(locationOptions).listen((Position position) {
      _position = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder: (ctx, constraint) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
//                padding: EdgeInsets.only(
//                  top: Consts.avatarRadius + Consts.padding,
//                  bottom: Consts.padding,
//                  left: Consts.padding,
//                  right: Consts.padding,
//                ),
//                  margin: EdgeInsets.only(top: Consts.avatarRadius),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
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
                    mapToolbarEnabled: true,
                    myLocationButtonEnabled: true,
                    onTap: (argument) {
                      _onAddMarker(argument.latitude, argument.longitude);
                    },
                    onCameraMoveStarted: () {},
                  ),
                ),
              );
            },
          ),
          Positioned(
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Image.asset(
                'assets/images/picker_marker_ic.png',
                height: 45,
                width: 45,
              ),
            )),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            height: 60,
            child: RaisedButton(
              color: AppTheme.buttonColor,
              onPressed: () {
                Provider.of<Places>(context, listen: false)
                    .placeInSend
                    .latitude = _lastMapPosition.latitude;

                Provider.of<Places>(context, listen: false)
                    .placeInSend
                    .longitude = _lastMapPosition.longitude;

                Navigator.pop(context);
              },
              child: Text(
                'انتخاب موقعیت',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Iransans',
                  color: AppTheme.white,
                  fontSize: textScaleFactor * 14.0,
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
                                color: index.isEven ? Colors.grey : Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container()))
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
