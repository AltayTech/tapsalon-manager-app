import 'package:flutter/material.dart';
import 'package:tapsalon_manager/models/complex_search.dart';

import 'salon_item.dart';

class HorizontalList extends StatelessWidget {
  const HorizontalList({
    @required this.listTitle,
    @required this.list,
  });

  final String listTitle;
  final List<ComplexSearch> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 19.0),
              child: Text(listTitle),
            ),
            FlatButton(
              disabledTextColor: Colors.black87,
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Text(
                    'همه',
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 12.0,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
        Container(
          width:  MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(10.0),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              return Container(
                  width:  MediaQuery.of(context).size.width*0.47,
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: SalonItem(loadedComplex: list[i],));
            },
          ),
        ),
      ],
    );
  }
}
