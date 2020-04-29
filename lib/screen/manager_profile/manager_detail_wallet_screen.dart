import 'package:flutter/material.dart';
import 'package:tapsalon_manager/models/user.dart';

class ManagerDetailWalletScreen extends StatefulWidget {
  final User user;

  ManagerDetailWalletScreen({this.user});

  @override
  _ManagerDetailWalletScreenState createState() =>
      _ManagerDetailWalletScreenState();
}

class _ManagerDetailWalletScreenState extends State<ManagerDetailWalletScreen> {
  final double rateRadious = 40;

  final double rateLineWidth = 4.0;

  final int rateAnimDuration = 1200;

  String sellCaseValue = 'همه';
  String statusValue = 'همه';
  String orderValue = 'جدیدترین';

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
                'سفارشات',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontFamily: 'Iransans',
                  fontSize: textScaleFactor * 14.0,
                ),
                textAlign: TextAlign.right,
              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  Expanded(
//                    child: Padding(
//                      padding: const EdgeInsets.all(5.0),
//                      child: Container(
//                        decoration: BoxDecoration(
//                            color: Colors.white,
//                            borderRadius: BorderRadius.circular(5),
//                            border: Border.all(
//                              color: Color(0xffECE8E8),
//                            )),
//                        child: Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Column(
//                            children: <Widget>[
//                              Text(
//                                'تعداد سفارشات',
//                                style: TextStyle(
//                                  color: Colors.grey,
//                                  fontFamily: 'Iransans',
//                                  fontSize: textScaleFactor * 14.0,
//                                ),
//                              ),
//                              Text(
//                                EnArConvertor().replaceArNumber(
//                                    (orderList.length.toString())),
//                                style: TextStyle(
//                                  color: Color(0xffA67FEC),
//                                  fontFamily: 'Iransans',
//                                  fontSize: textScaleFactor * 14.0,
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//
//                ],
//              ),
              Card(
                elevation: 0.5,
                child: Wrap(
                  children: <Widget>[
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, right: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                'وضعیت',
                                style: TextStyle(
                                  fontFamily: 'Iransans',
                                  color: Colors.grey,
                                  fontSize: textScaleFactor * 10.0,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'نوع خرید',
                                style: TextStyle(
                                  fontFamily: 'Iransans',
                                  color: Colors.grey,
                                  fontSize: textScaleFactor * 10.0,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'تاریخ',
                                style: TextStyle(
                                  fontFamily: 'Iransans',
                                  color: Colors.grey,
                                  fontSize: textScaleFactor * 10.0,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                'شماره',
                                style: TextStyle(
                                  fontFamily: 'Iransans',
                                  color: Colors.grey,
                                  fontSize: textScaleFactor * 10.0,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
//                    ListView.builder(
//                      physics: NeverScrollableScrollPhysics(),
//                      shrinkWrap: true,
//                      itemCount: orderList.length,
//                      itemBuilder: (ctx, index) {
//                        return GestureDetector(
//                          onTap: () {
//                            Navigator.of(context).pushNamed(
//                                OrderViewScreen.routeName,
//                                arguments: orderList[index].id);
//                          },
//                          child: OrderItem(
//                            number: orderList[index].shenaseh.toString(),
//                            date:
//                                orderList[index].order_register_date.toString(),
//                            sellCase: orderList[index].pay_type.toString(),
//                            status: orderList[index].pay_status.toString(),
//                          ),
//                        );
//                      },
//                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.03,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  const InfoItem({
    Key key,
    @required this.title,
    @required this.text,
  }) : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.arrow_right),
                Text('$title : '),
                Text(text)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem({
    Key key,
    @required this.number,
    @required this.date,
    @required this.sellCase,
    @required this.status,
  }) : super(key: key);

  final String number;
  final String date;
  final String sellCase;
  final String status;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: deviceHeight * 0.05,
        decoration: BoxDecoration(
          color: Color(0xffFFEDD8),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Text(
                  number,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 11.0,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 11.0,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  sellCase,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 11.0,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 11.0,
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
