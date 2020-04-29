import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/app_theme.dart';
import 'package:tapsalon_manager/models/complex.dart';
import 'package:tapsalon_manager/models/complex_search.dart';
import 'package:tapsalon_manager/provider/complexes.dart';
import 'package:tapsalon_manager/screen/complex_detail/complex_gallery_edit_screen.dart';
import 'package:tapsalon_manager/widget/main_drawer.dart';

import 'complex_detail_comment_screen.dart';
import 'complex_detail_info_screen.dart';
import 'complex_detail_place_list_screen.dart';

class ComplexDetailScreen extends StatefulWidget {
  static const routeName = '/complex-detail';

  @override
  _ComplexDetailScreenState createState() => _ComplexDetailScreenState();
}

class _ComplexDetailScreenState extends State<ComplexDetailScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading;
  bool _isInit = true;
  TabController _tabController;

  Complex loadedComplex;


  bool isLike = false;

  ComplexSearch complex;

  var image_url='';

  var title='';

  double stars=0;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    // TODO: implement initState
    super.initState();
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
  void didChangeDependencies() {
    if (_isInit) {
      searchItems();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
     complex = arguments != null ? arguments['complex'] : 0;
//    title = arguments != null ? arguments['title'] : '';
//    image_url = arguments != null ? arguments['imageUrl'] : '';
//    stars = arguments != null ? arguments['stars'] : '';

    print(complex.id);
    await Provider.of<Complexes>(context, listen: false)
        .retrieveComplex(complex.id);
    loadedComplex = Provider.of<Complexes>(context, listen: false).itemComplex;
    print(complex.id);
    image_url=loadedComplex.featured.url.medium;
    stars=loadedComplex.stars;
    title=loadedComplex.name;
    print(_isLoading.toString());

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    final List<Tab> myTabs = <Tab>[
      Tab(
        text: 'اطلاعات',
        icon: Icon(
          Icons.info,
          color: _tabController.index == 0 ? Colors.blue : Colors.grey,
        ),
      ),
      Tab(
        text: 'سالن ها',
        icon: Icon(
          Icons.account_balance,
          color: _tabController.index == 1 ? Colors.blue : Colors.grey,
        ),
      ),
      Tab(
        text: 'نظرات',
        icon: Icon(
          Icons.comment,
          color: _tabController.index == 3 ? Colors.blue : Colors.grey,
        ),
//        child: SalonDetailInfoScreen(),
      ),
    ];
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length: myTabs.length, // This is the number of tabs.
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: SliverAppBar(
//                    title: Text(title),
//                    centerTitle: true,
                    backgroundColor: AppTheme.appBarColor,
                    expandedHeight: deviceHeight * 0.4,
                    floating: true,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: <Widget>[

                          Positioned.fill(
                            child: FadeInImage(
                              placeholder: AssetImage(
                                  'assets/images/tapsalon_icon_200.png'),
                              image: NetworkImage(
                                  image_url!= null ? image_url : ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: AppTheme.bgColor,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isLike
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      bool isLikeT =
                                          await Provider.of<Complexes>(context,
                                                  listen: false)
                                              .sendLike(loadedComplex.id);
                                      isLikeT
                                          ? isLike
                                              ? isLike = false
                                              : isLike = true
                                          : isLike = isLike;
                                      print(isLike.toString());
                                      setState(() {});
                                    },
                                  ),
                                  Text(
                                    '${stars}/5.0',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Iransans',
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          11.0,
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: deviceWidth * 0.45,
                                      child: Text(
                                       title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Iransans',
                                          fontSize: MediaQuery.of(context)
                                                  .textScaleFactor *
                                              14.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    ComplexGalleryEditScreen.routeName,
                                    arguments: loadedComplex);

                              },
                              child: Icon(
                                Icons.camera_alt,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
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
                  ),
                  pinned: true,
                ),
              ];
            },
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: TabBarView(
                  children: myTabs.map((Tab tab) {
                    if (_isLoading) {
                      return Align(
                          alignment: Alignment.center,
                          child: SpinKitFadingCircle(
                            itemBuilder: (BuildContext context, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      index.isEven ? Colors.grey : Colors.grey,
                                ),
                              );
                            },
                          ));
                    } else if (_tabController.index == 0) {
                      return ComplexDetailInfoScreen(
                        complex: loadedComplex,
                      );
                    } else if (_tabController.index == 1) {
                      return ComplexDetailPlaceListScreen(
                        complex: loadedComplex,
                      );
                    } else {
                      return ComplexDetailCommentScreen(
                        complex: loadedComplex,
                      );
                    }
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white, // ADD THE COLOR YOU WANT AS BACKGROUND.
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
