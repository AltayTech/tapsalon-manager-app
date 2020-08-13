import 'package:flutter/material.dart';

import '../../provider/app_theme.dart';
import '../../screen/user_profile/profile_view.dart';
import '../../widget/main_drawer.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      backgroundColor: AppTheme.white,
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: MainDrawer(),
      ),
      body: ProfileView(),
    );
  }
}
