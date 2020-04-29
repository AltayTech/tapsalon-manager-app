import 'package:flutter/material.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';

import 'manager_profile_view.dart';

class ManagerProfileScreen extends StatefulWidget {
  static const routeName = '/manager-profile';

  @override
  _ManagerProfileScreenState createState() => _ManagerProfileScreenState();
}

class _ManagerProfileScreenState extends State<ManagerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),

      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ), // resizeToAvoidBottomInset: false,
      body: ManagerProfileView(),
    );
  }
}
