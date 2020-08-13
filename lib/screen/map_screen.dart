import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/city.dart';
import 'package:tapsalon_manager/models/places_models/place_in_search.dart';
import 'package:tapsalon_manager/widget/items/map_info_windows_item.dart';

import '../models/searchDetails.dart';
import '../provider/app_theme.dart';
import '../provider/cities.dart';
import '../provider/places.dart';
import 'place_detail/place_detail_screen.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/MapScreen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  bool _isInit = true;
  bool _isInfoShow = false;
  var _isLoading;
  List<PlaceInSearch> loadedPlaces = [];
  List<PlaceInSearch> loadedPlacesToList = [];
  SearchDetails searchDetails;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController myController;
  static const LatLng _center = const LatLng(38.074065, 46.312711);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  double speed;

  AnimationController _animationController;
  AnimationController _animationMapController;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  Animation<double> _scaleAnimation;

  BitmapDescriptor salonBitmapDescriptor = BitmapDescriptor.defaultMarker;
  BitmapDescriptor gymBitmapDescriptor = BitmapDescriptor.defaultMarker;
  BitmapDescriptor entBitmapDescriptor = BitmapDescriptor.defaultMarker;

  City selectedCity;

  PlaceInSearch selectedPlace;

  Animation<double> _animation;
  AnimationController _FBAnimationController;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Places>(context, listen: false).searchBuilder();
      _tabController.index = 0;
      try {
        selectedCity = Provider.of<Cities>(context, listen: false).selectedCity;
      } catch (error) {}
      _lastMapPosition = LatLng(selectedCity.latitude, selectedCity.longitude);
      retrieveItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }



  Future<void> retrieveItems() async {
    setState(() {
      _isLoading = true;
    });

    if (selectedCity.id == null) {
      await Provider.of<Cities>(context, listen: false).getSelectedCity();
      selectedCity = Provider.of<Cities>(context, listen: false).selectedCity;

      Provider.of<Places>(context, listen: false).sCityId =
          selectedCity.id.toString();

      await searchItems();
    } else {
      Provider.of<Places>(context, listen: false).sCityId =
          selectedCity.id.toString();
      loadedPlacesToList.clear();
      await searchItems();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> filterItems() async {
    loadedPlacesToList.clear();
    await retrieveItems();
  }



  Future<void> searchItems() async {
    Provider.of<Places>(context, listen: false).sPerPage = 1000;
    Provider.of<Places>(context, listen: false).searchBuilder();
    await Provider.of<Places>(context, listen: false).searchItem();
    searchDetails =
        Provider.of<Places>(context, listen: false).placeSearchDetails;
    loadedPlaces.clear();
    loadedPlaces = Provider.of<Places>(context, listen: false).items;
    loadedPlacesToList.addAll(loadedPlaces);
    _onAddMarker(loadedPlacesToList);
  }

  Future<void> changePick(List<PlaceInSearch> list, int i) async {
    if (_isInfoShow) {
      await _animationMapController.forward();
      await _animationController.reverse();
      setState(() {});

      selectedPlace = list[i];
      _animationMapController.reverse();

      _animationController.forward();

      setState(() {});
    } else {
      _isInfoShow = true;
      setState(() {});
      selectedPlace = list[i];

      _animationMapController.forward();
      _animationController.forward();
      setState(() {});
    }
  }

  Future<void> putOn() async {
    print('putOn');

    await _animationMapController.forward();
    await _animationController.reverse();
    setState(() {});
    _isInfoShow = false;
  }

  void _onAddMarker(List<PlaceInSearch> list) async {
    _markers.clear();
    for (int i = 0; i < list.length; i++) {
      print(list[i].latitude);
      print(list[i].longitude);
      var latLng = LatLng(list[i].latitude, list[i].longitude);
      var pinLocationIcon;
      if (list[i].placeType.id == 1) {
        pinLocationIcon = pinLocationIconSalon;
      } else if (list[i].placeType.id == 4) {
        pinLocationIcon = pinLocationIconEnt;
      } else if (list[i].placeType.id == 2) {
        pinLocationIcon = pinLocationIconGym;
      } else {
        pinLocationIcon = pinLocationIconSalon;
      }

      _markers.add(Marker(
        markerId: MarkerId(list[i].id.toString()),
        onTap: () {
          changePick(list, i);
        },
        infoWindow: InfoWindow(
          title: list[i].name,
          onTap: () {
            Navigator.of(context).pushNamed(
              PlaceDetailScreen.routeName,
              arguments: {
                'placeId': selectedPlace.id,
                'name': selectedPlace.name,
                'imageUrl': selectedPlace.image.url.medium,
                'stars': selectedPlace.rate.toString(),
              },
            );
          },
        ),
        position: latLng,
        icon: pinLocationIcon,
      ));
    }
  }

  void _onAddMarkerButtonPressed(LatLng latLng) {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
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

  TabController _tabController;
  BitmapDescriptor pinLocationIconSalon;
  BitmapDescriptor pinLocationIconEnt;
  BitmapDescriptor pinLocationIconGym;

  void setCustomMapPin() async {
    pinLocationIconSalon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(20, 30)),
      'assets/images/marker_ic_1_v1.png',
    );
    pinLocationIconEnt = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(20, 30)),
      'assets/images/marker_ic_2_v1.png',
    );
    pinLocationIconGym = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 3,
        size: Size(10, 18),
      ),
      'assets/images/marker_ic_3_v1.png',
    );
  }

  @override
  void initState() {
    super.initState();
    _animationMapController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 600,
        ),
        value: 1);
    _FBAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(
        curve: Curves.easeInOut, parent: _FBAnimationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 600,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 2),
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
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationMapController,
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

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationMapController.dispose();
    _FBAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    print(deviceHeight.toString());
    print(deviceWidth.toString());
    print(MediaQuery.of(context).size.toString());
    print(MediaQuery.of(context).devicePixelRatio.toString());
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height:
                  deviceHeight * 0.93 - Scaffold.of(context).appBarMaxHeight,
              width: deviceWidth,
              child: Column(
                children: [
                  Expanded(
//                    child: AnimatedContainer(
//                      duration: _animationMapController.duration,
//                      curve: Curves.easeIn,
//                      child: ScaleTransition(
//                        alignment: Alignment.center,
//                        scale: _scaleAnimation,

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
                      onTap: (_) {
                        putOn();
                      },
                      zoomGesturesEnabled: true,
                      onLongPress: (latlng) =>
                          _onAddMarkerButtonPressed(latlng),
                    ),
//                      ),
//                    ),
                  ),
                  _isInfoShow
                      ? AnimatedContainer(
                          duration: _animationController.duration,
                          curve: Curves.easeIn,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: MapInfoWindowItem(
                                selectedPlace: selectedPlace,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            width: 80,
            height: 35,
            child: Builder(
              builder: (context) => InkWell(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 1)
                      ]),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'فیلترها',
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          color: Colors.black,
                          fontSize: textScaleFactor * 14.0,
                        ),
                      ),
                    ),
                  ),
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
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
