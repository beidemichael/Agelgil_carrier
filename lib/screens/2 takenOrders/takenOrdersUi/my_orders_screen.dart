import 'dart:async';

import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:agelgil_carrier_end/shared/background_blur.dart';
import 'package:agelgil_carrier_end/shared/internet_connection.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'back.dart';
import 'my_orders_card.dart';

class CarrierMyOrdersScreen extends StatefulWidget {
  String userUid;
  CarrierMyOrdersScreen({this.userUid});
  @override
  _CarrierMyOrdersScreenState createState() => _CarrierMyOrdersScreenState();
}

class _CarrierMyOrdersScreenState extends State<CarrierMyOrdersScreen> {
  StreamSubscription subscription;
  bool isInternetConnected = true;
  @override
  void initState() {
    // TODO: implement initState
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
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<OrdersCarrier>>(context) ?? [];

    return Scaffold(
      body: Stack(
        children: [
          BackgroundBlur(),
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 60,
                  ),
                  Container(
                      // color: Colors.green,
                      height: MediaQuery.of(context).size.height-60,
                      width: MediaQuery.of(context).size.width,
                      child: orders == null
                          ? Center(
                              child: SpinKitCircle(
                              color: Colors.orange,
                              size: 50.0,
                            ))
                          : Container(
                              child: orders.isEmpty
                                  ? Center(
                                      child: Text(
                                          'You have\'t taken any orders yet.',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[400],
                                              fontWeight: FontWeight.w600)),
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: orders.length,
                                      itemBuilder: (context, index) {
                                        return CarrierMyOrdersCard(
                                            orders: orders[index],
                                            userUid: widget.userUid);

                                        // }
                                      }),
                            )),
                ],
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Back()),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 110,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[600],
                    blurRadius: 2.0, //effect of softening the shadow
                    spreadRadius: 0.5, //effecet of extending the shadow
                    offset: Offset(
                        0.0, //horizontal
                        0.0 //vertical
                        ),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Center(
                child: Text(
                  "Accepted Orders",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600),
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
