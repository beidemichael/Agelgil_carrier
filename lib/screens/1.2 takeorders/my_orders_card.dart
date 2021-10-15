import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:agelgil_carrier_end/screens/1.2 takeorders/order_list_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ntp/ntp.dart';

import 'ordersCardWidgets/background_white_container.dart';
import 'ordersCardWidgets/hyphen_devider.dart';
import 'ordersCardWidgets/shadow_container.dart';
import 'ordersCardWidgets/text_container.dart';

class MyOrdersCard extends StatefulWidget {
  Orders orders;
  double lat;
  double long;
  String userUid;
  String userName;
  String userPhone;
  String userPic;
  bool verified;
  bool isAuthorized;
  MyOrdersCard({
    this.orders,
    this.lat,
    this.long,
    this.userName,
    this.userPhone,
    this.userPic,
    this.userUid,
    this.verified,
    this.isAuthorized,
  });
  @override
  _MyOrdersCardState createState() => _MyOrdersCardState();
}

class _MyOrdersCardState extends State<MyOrdersCard> {
  DateTime now;
  bool loading = true;
  void initState() {
    super.initState();
    timeNow();
  }

  timeNow() async {
    now = await NTP.now();
    setState(() {
      loading = false;
    });
  }

  _orderList(BuildContext context) {
    OrderListBlurryDialog alert = OrderListBlurryDialog(widget.orders);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _orderList(context);
      },
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: Stack(
                      children: <Widget>[
                        RedContainerBackShadow(),
                        GreyContainerFront(
                          orders: widget.orders,
                        ),
                        TextsAndContent(
                          orders: widget.orders,
                          lat: widget.lat,
                          long: widget.long,
                          userName: widget.userName,
                          userPhone: widget.userPhone,
                          userPic: widget.userPic,
                          userUid: widget.userUid,
                          verified: widget.verified,
                          now: now,
                          loading: loading,
                          isAuthorized:widget.isAuthorized,
                        ),
                        HyphenDevider(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  CancelOrder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(color: Colors.transparent, height: 327),
            Container(
              width: 150,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[500],
                    blurRadius: 5.0, //effect of softening the shadow
                    spreadRadius: 0.1, //effecet of extending the shadow
                    offset: Offset(
                        0.0, //horizontal
                        3.0 //vertical
                        ),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text('Cancel order',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
