import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/facility.dart';
import 'package:tapsalon_manager/models/field.dart';
import 'package:tapsalon_manager/models/place.dart';
import 'package:tapsalon_manager/screen/place_detail/place_detail_edit_place.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'place_gallery_edit_screen.dart';

class SalonDetailInfoScreen extends StatelessWidget {
  final Place place;

  SalonDetailInfoScreen({this.place});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final List<String> contactInfo = [
      place.complexInPlace.name.isNotEmpty ? place.complexInPlace.name : '',
      place.complexInPlace.phone,
    ];
    final List<Field> fields = place.fields;
    final List<Facility> facilities = place.facilities;

    final List<IconData> iconDatas = <IconData>[
      Icons.location_city,
      Icons.contact_mail,
      Icons.email,
      Icons.email,
      Icons.email,
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'درباره سالن',
                  style: TextStyle(
                    fontFamily: 'Iransans',
                    fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
                  ),
                ),
            FittedBox(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    PlaceDetailEditPlace.routeName,
                    arguments: {
                      'place': place,
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
              ),),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              place.about,
              style: TextStyle(
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 10),
          new SalonItemsList(
            title: 'اطلاعات تماس',
            entries: contactInfo,
            icons: iconDatas,
            color: Colors.red,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: () =>
                      UrlLauncher.launch('tel:${place.complexInPlace.phone}'),
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
          Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Text(
                    'رشته های ورزشی',
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
                    ),
                  ),
                ),
                Divider(),
                Container(
//            height: 300,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: fields.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            fields[index].name,
                            textAlign: TextAlign.right,
                          ),
                          trailing: Icon(
                            iconDatas[index],
                            color: Colors.yellow,
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Text(
                    'امکانات',
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
                    ),
                  ),
                ),
                Divider(),
                Container(
//            height: 300,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: facilities.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            facilities[index].name,
                            textAlign: TextAlign.right,
                          ),
                          trailing: Icon(
                            iconDatas[index],
                            color: Colors.blue,
                          ),
                        );
                      }),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FittedBox(
                            child: FlatButton(
                              color: Colors.green,
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    PlaceGalleryEditScreen.routeName,
                                    arguments: place);
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
                          Padding(
                            padding: const EdgeInsets.only(top: 10, right: 10),
                            child: Text(
                              'گالری تصاویر',
                              style: TextStyle(
                                fontFamily: 'Iransans',
                                fontSize:
                                    MediaQuery.of(context).textScaleFactor *
                                        18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Container(
                        width: double.infinity,
                        height: deviceHeight * 0.5,
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: place.image.length,
                          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                            value: place.image[i],
                            child: Container(
                              child: FadeInImage(
                                placeholder: AssetImage(
                                    'assets/images/tapsalon_icon_200.png'),
                                image: NetworkImage(place.image[i].url.medium),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
              ],
            ),
          )
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
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Text(
              title.isNotEmpty ? title : '',
              style: TextStyle(
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
              ),
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
                      entries[index],
                      textAlign: TextAlign.right,
                    ),
                    trailing: Icon(
                      icons[index],
                      color: color,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
