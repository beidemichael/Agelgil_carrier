import 'dart:async';
import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:agelgil_carrier_end/screens/3%20complete%20orders/total_complete_orders.dart';
import 'package:agelgil_carrier_end/service/database.dart';
import 'package:agelgil_carrier_end/shared/background_blur.dart';
import 'package:agelgil_carrier_end/shared/internet_connection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'complete_my_orders_card.dart';

class AdrashCompleteOrders extends StatefulWidget {
  String carrierUid;
  AdrashCompleteOrders({this.carrierUid});
  @override
  _AdrashCompleteOrdersState createState() => _AdrashCompleteOrdersState();
}

class _AdrashCompleteOrdersState extends State<AdrashCompleteOrders> {
  StreamSubscription subscription;
  bool isInternetConnected = true;
  double total;
  double totalNo;
  num serviceCharge = 0;
  List<Orders> completeOrders;
  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          isInternetConnected = true;
        });
      } else {
        setState(() {
          isInternetConnected = false;
        });
      }
    });
    // completeOrders = widget.completeOrders;
  }

  totalCalculation(List<Orders> completeOrders) {
    total = 0;
    totalNo = 0;
    for (int i = 0; i < completeOrders.length; i++) {
      total = total + completeOrders[i].deliveryFee;
      totalNo = totalNo + 1;
      serviceCharge = serviceCharge + completeOrders[i].serviceCharge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completeOrders = Provider.of<List<Orders>>(context) ?? [];
    print(completeOrders);
    totalCalculation(completeOrders);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundBlur(),
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    // color: Colors.green,
                    height: MediaQuery.of(context).size.height - 150,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 90.0),
                      child: completeOrders == null
                          ? Center(
                              child: SpinKitCircle(
                              color: Colors.orange,
                              size: 50.0,
                            ))
                          : Container(
                              child: completeOrders.isEmpty
                                  ? Center(
                                      child: Text(
                                          'You don\'t have any complete orders yet.',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[400],
                                              fontWeight: FontWeight.w600)),
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: completeOrders.length,
                                      itemBuilder: (context, index) {
                                        return CompleteMyOrdersCard(
                                          orders: completeOrders[index],
                                        );
                                      },
                                    ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                    child: Container(
                      height: 140.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[600],
                            blurRadius: 1.0, //effect of softening the shadow
                            spreadRadius: 0.5, //effecet of extending the shadow
                            offset: Offset(
                                0.0, //horizontal
                                1.0 //vertical
                                ),
                          ),
                        ],
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Income',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey[500],
                                        )),
                                    Text(total.toString() + 'Birr',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        )),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('No of Orders',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey[500],
                                        )),
                                    Text(totalNo.toInt().toString(),
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        )),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Service charge',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey[500],
                                        )),
                                    Text(
                                        serviceCharge.toStringAsFixed(2) +
                                            'Birr',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 75.0, left: 60),
                child: Container(
                  height: 85,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 23.0, left: 10, right: 10),
                    child: Center(
                      child: Text(
                        'Unpaid Complete orders',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.grey[600]
                            // fontWeight: FontWeight.w700,
                            // fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 5.0, //effect of softening the shadow
                        spreadRadius: 0.5, //effecet of extending the shadow
                        offset: Offset(
                            8.0, //horizontal
                            10.0 //vertical
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiProvider(
                        providers: [
                          StreamProvider<List<Orders>>.value(
                            value:  DatabaseService(userUid: widget.carrierUid)
                                .completeOrders,
                          ),
                        ],
                        child: TotalAdrashCompleteOrders(),
                      ),
                    ));
              },
              child: Container(
                height: 80,
                width: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15.0,
                          color: Colors.grey[800]
                          // fontWeight: FontWeight.w700,
                          // fontStyle: FontStyle.italic,
                          ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400],
                      blurRadius: 5.0, //effect of softening the shadow
                      spreadRadius: 0.5, //effecet of extending the shadow
                      offset: Offset(
                          8.0, //horizontal
                          10.0 //vertical
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Visibility(
                visible: !isInternetConnected, child: InternetConnectivity()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
}
