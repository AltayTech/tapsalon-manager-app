import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tapsalon_manager/models/complex.dart';
import 'package:tapsalon_manager/screen/complex_detail/complex_detail_edit_complex.dart';
import 'package:tapsalon_manager/widget/en_to_ar_number_convertor.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ComplexDetailInfoScreen extends StatefulWidget {
  final Complex complex;

  ComplexDetailInfoScreen({this.complex});

  @override
  _ComplexDetailInfoScreenState createState() =>
      _ComplexDetailInfoScreenState();
}

class _ComplexDetailInfoScreenState extends State<ComplexDetailInfoScreen> {
  Completer<GoogleMapController> _controller = Completer();
  bool _isInit = true;

  LatLng _center;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  final Set<Marker> _markers = {};

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _center = LatLng(
        widget.complex.latitude != null ? widget.complex.latitude : 36.0,
        widget.complex.longitude != null ? widget.complex.longitude : 48.0,
      );
      _isInit = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final List<String> contactInfo = [
      '${widget.complex.user.fname} ${widget.complex.user.lname}',
      widget.complex.phone,
      widget.complex.mobile,
      widget.complex.region.name
    ];
    final List<IconData> iconDatas = <IconData>[
      Icons.supervisor_account,
      Icons.phone,
      Icons.phonelink_ring,
      Icons.location_searching,
      Icons.email,
    ];
    _markers.add(
      Marker(
        markerId: MarkerId(widget.complex.id.toString()),
        position: _center,
        infoWindow: InfoWindow(
          title: widget.complex.name,
          snippet: widget.complex.stars.toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Text(
                    'درباره مجموعه',
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
                    ),
                  ),
                ),
                FittedBox(
                  child: FlatButton(
                    color: Colors.green,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        ComplexDetailEditComplex.routeName,
                        arguments: {
                          'complex': widget.complex,
                        },
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                        Text(
                          ' ویرایش',
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
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.complex.about,
              style: TextStyle(
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          SalonItemsList(
            title: 'اطلاعات تماس',
            entries: contactInfo,
            icons: iconDatas,
            color: Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: () =>
                      UrlLauncher.launch('tel:${widget.complex.phone}'),
                  child: Text(
                    'تماس بگیرید',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
                    ),
                  ),
                )),
          ),
          Container(
            height: deviceWidth * 0.7,
            width: double.infinity,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 13.0,
              ),
              compassEnabled: true,
              mapType: MapType.normal,
              markers: _markers,
              scrollGesturesEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}

class SalonItemsList extends StatelessWidget {
  const SalonItemsList({
    Key key,
    @required this.title,
    @required this.entries,
    @required this.icons,
    @required this.color,
  }) : super(key: key);

  final List<String> entries;
  final List<IconData> icons;
  final String title;
  final color;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            title.isNotEmpty ? title : '',
            style: TextStyle(
              fontFamily: 'Iransans',
              fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
            ),
          ),
          Divider(),
          Container(
//            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    EnArConvertor().replaceArNumber(entries[index]),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
                    ),
                  ),
                  trailing: Icon(
                    icons[index],
                    color: color,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
