import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon_manager/models/complex_search.dart';
import 'package:tapsalon_manager/models/searchDetails.dart';
import 'package:tapsalon_manager/models/user.dart';
import 'package:tapsalon_manager/provider/complexes.dart';
import 'package:tapsalon_manager/screen/complex_detail/complex_detail_add_complex.dart';
import 'package:tapsalon_manager/widget/complex_item.dart';
import 'package:tapsalon_manager/widget/en_to_ar_number_convertor.dart';

class ManagerDetailMyComplexesScreen extends StatefulWidget {
  final User user;

  ManagerDetailMyComplexesScreen({this.user});

  @override
  _ManagerDetailMyComplexesScreenState createState() =>
      _ManagerDetailMyComplexesScreenState();
}

class _ManagerDetailMyComplexesScreenState
    extends State<ManagerDetailMyComplexesScreen> {
  final double rateRadious = 40;

  final double rateLineWidth = 4.0;

  final int rateAnimDuration = 1200;
  List<ComplexSearch> loadedComplexes = [];
  List<ComplexSearch> loadedComplexestolist = [];
  bool _isInit = true;
  var _isLoading;
  SearchDetails searchDetails;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      searchItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Complexes>(context, listen: false).searchBuilder();
    await Provider.of<Complexes>(context, listen: false).searchItem();
    searchDetails =
        Provider.of<Complexes>(context, listen: false).complexSearchDetails;
    _submit();

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> _submit() async {
    loadedComplexes.clear();
    loadedComplexes = Provider.of<Complexes>(context, listen: false).items;
    loadedComplexestolist.addAll(loadedComplexes);
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
//    List<Order> orderList = Provider.of<CustomerInfo>(context).orders;

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: <Widget>[
              Text(
                'سالن های من',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontFamily: 'Iransans',
                  fontSize: textScaleFactor * 14.0,
                ),
                textAlign: TextAlign.right,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color(0xffECE8E8),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'تعداد سالن ها',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 14.0,
                                ),
                              ),
                              Text(
                                EnArConvertor().replaceArNumber(
                                    (loadedComplexestolist.length.toString())),
                                style: TextStyle(
                                  color: Color(0xffA67FEC),
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color(0xffECE8E8),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 25,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    ComplexDetailAddComplex.routeName);
                              },
                              child: Text(
                                'اضافه کردن سالن',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: deviceHeight * 0.6,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: loadedComplexestolist.length,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: loadedComplexestolist[i],
                    child: Container(
                      height: deviceHeight * 0.16,
                      child: ComplexItem(
                        loadedComplex: loadedComplexestolist[i],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
