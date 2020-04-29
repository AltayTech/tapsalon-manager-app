import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapsalon_manager/models/place.dart';

import 'salon_detail_info_screen.dart';
import 'salon_detail_timing_screen.dart';

class SalonDetailTabBar extends StatefulWidget {
  final Place place;

  SalonDetailTabBar({
    this.place,
  });

  @override
  _SalonDetailTabBarState createState() => _SalonDetailTabBarState();
}

class _SalonDetailTabBarState extends State<SalonDetailTabBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
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
  Widget build(BuildContext context) {
    final List<Tab> myTabs = <Tab>[
      Tab(
        text: 'مشخصات',
        icon: Icon(
          Icons.info,
          color: _tabController.index == 0 ? Colors.blue : Colors.grey,
        ),
      ),
      Tab(
        text: 'زمان بندی',
        icon: Icon(
          Icons.calendar_today,
          color: _tabController.index == 1 ? Colors.blue : Colors.grey,
        ),
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          unselectedLabelColor: Colors.black54,
          labelColor: Colors.blue,

          labelStyle: TextStyle(
            fontFamily: 'Iransans',
            fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Iransans',
            fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
          ),
          controller: _tabController,
          tabs: myTabs,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: TabBarView(
              controller: _tabController,
              children: myTabs.map((Tab tab) {
                final String label = tab.text.toLowerCase();
                if (_tabController.index == 0) {
                  return SalonDetailInfoScreen(
                    place: widget.place,
                  );
                } else {
                  return SalonDetailTimingScreen(
                    place: widget.place,
                  );
                }
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
