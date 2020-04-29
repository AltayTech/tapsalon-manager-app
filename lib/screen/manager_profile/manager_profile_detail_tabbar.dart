import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/user.dart';
import 'package:tapsalon_manager/provider/manager_info.dart';
import 'manager_detail_info_screen.dart';
import 'manager_detail_may_complexes_screen.dart';
import 'manager_detail_wallet_screen.dart';

class ManagerProfileDetailTabBar extends StatefulWidget {
  final User user;

  ManagerProfileDetailTabBar({
    this.user,
  });

  @override
  _ManagerProfileDetailTabBarState createState() =>
      _ManagerProfileDetailTabBarState();
}

class _ManagerProfileDetailTabBarState extends State<ManagerProfileDetailTabBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ManagerInfo>(context, listen: false).getUser();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
    final deviceSize = MediaQuery.of(context).size;

    final List<Tab> myTabs = <Tab>[
      Tab(
        text: 'اطلاعات کاربر',
        icon: Icon(
          Icons.account_circle,
          color:
              _tabController.index == 0 ? Color(0xff009EFD) : Color(0xffFEA832),
          size: deviceSize.width * 0.11,
        ),
      ),
      Tab(
        text: 'مکانهای ورزشی من',
        icon: Icon(
          Icons.location_city,
          color:
              _tabController.index == 1 ? Color(0xff009EFD) : Color(0xffFEA832),
          size: deviceSize.width * 0.11,
        ),
      ),
      Tab(
        text: 'حساب مالی',
        icon: Icon(
          Icons.account_balance_wallet,
          color:
              _tabController.index == 2 ? Color(0xff009EFD) : Color(0xffFEA832),
          size: deviceSize.width * 0.11,
        ),
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          unselectedLabelColor: Color(0xffFEA832),
          labelColor: Colors.blue,
          labelStyle: TextStyle(
            fontFamily: 'Iransans',
            fontSize: MediaQuery.of(context).textScaleFactor * 10.0,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Iransans',
            fontSize: MediaQuery.of(context).textScaleFactor * 10.0,
          ),
          controller: _tabController,
          tabs: myTabs,
        ),
        body: TabBarView(
          controller: _tabController,
          children: myTabs.map((Tab tab) {
            if (_tabController.index == 0) {
              return ManagerDetailInfoScreen(
                user: widget.user,
              );
            } else if (_tabController.index == 1) {
              return ManagerDetailMyComplexesScreen(
                user: widget.user,
              );
            } else {
              return ManagerDetailWalletScreen(
                user: widget.user,
              );
            }
          }).toList(),
        ),
      ),
    );
  }
}
