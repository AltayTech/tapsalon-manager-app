import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/complex_search.dart';
import 'package:tapsalon_manager/screen/complex_detail/complex_detail_screen.dart';
class SalonItem extends StatelessWidget {
  final ComplexSearch loadedComplex;

  SalonItem({this.loadedComplex});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) => InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ComplexDetailScreen.routeName, arguments: {
            'complexId': loadedComplex.id,
            'title': loadedComplex.name,
            'imageUrl': loadedComplex.img_url,
            'stars': loadedComplex.stars.toString()
          });
        },
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: constraint.maxHeight * 0.6,
                      child: FadeInImage(
                        placeholder:
                            AssetImage('assets/images/tapsalon_icon_200.png'),
                        image: NetworkImage(loadedComplex.img_url.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: constraint.maxHeight * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: constraint.maxHeight * 0.1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: constraint.maxWidth * 0.5,
                              child: Text(
                                loadedComplex.name,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Iransans',
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          12.0,
                                ),
                              ),
                            ),
                            Container(
                              width: constraint.maxWidth * 0.3,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: SmoothStarRating(
                                    allowHalfRating: false,
                                    onRatingChanged: (v) {},
                                    starCount: 5,
                                    rating: loadedComplex.stars,
                                    size: constraint.maxWidth * 0.05,
                                    color: Colors.green,
                                    borderColor: Colors.green,
                                    spacing: 0.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: constraint.maxWidth * 0.5,
                      height: constraint.maxHeight * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 3.0, top: 4, bottom: 5),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          Text(
                            loadedComplex.region.name,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontFamily: 'Iransans',
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: constraint.minWidth,
                      height: constraint.maxHeight * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: ListView.builder(
//                        shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: loadedComplex.fields.length,
                          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                            value: loadedComplex.fields[i],
                            child: Container(
                                child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                i < (loadedComplex.fields.length - 1)
                                    ? (loadedComplex.fields[i].name + ',')
                                    : loadedComplex.fields[i].name,
                                style: TextStyle(
                                  fontFamily: 'Iransans',
                                  color: Colors.black54,
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          10.0,
                                ),
                              ),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: constraint.maxHeight * 0.05,
              left: -1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: AppTheme.discountBgColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Text(
                      'تخفیف 20%',
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: constraint.maxHeight * 0.20,
              left: -1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: AppTheme.priceBgColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Text(
                      'قابل روزرو',
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
