import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:agelgil_carrier_end/screens/1.1%20map/camera_ask.dart';
import 'package:agelgil_carrier_end/screens/1.2%20takeorders/alert/failed.dart';
import 'package:agelgil_carrier_end/screens/1.2%20takeorders/alert/sucessful.dart';
import 'package:agelgil_carrier_end/screens/2%20takenOrders/routeMap/routeContainer.dart';
import 'package:agelgil_carrier_end/screens/2%20takenOrders/takenOrdersUi/are_you_sure_you_want_to_cancel.dart';
import 'package:agelgil_carrier_end/screens/2%20takenOrders/takenOrdersUi/carrier_order_list_dialog.dart';

import 'package:agelgil_carrier_end/service/database.dart';
import 'package:agelgil_carrier_end/shared/concave_decoration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee_widget/marquee_widget.dart';

import 'package:time_formatter/time_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class CarrierMyOrdersCard extends StatefulWidget {
  OrdersCarrier orders;
  String userUid;
  CarrierMyOrdersCard({this.orders, this.userUid});
  @override
  _CarrierMyOrdersCardState createState() => _CarrierMyOrdersCardState();
}

class _CarrierMyOrdersCardState extends State<CarrierMyOrdersCard> {
  List food = [];
  List price = [];
  List quantity = [];
  double latitude;
  double longitude;
  String orderCode;
  DateTime now;
  bool loading = true;

  void initState() {
    super.initState();
    timeNow();
    Future.delayed(Duration(milliseconds: 500), () {
      food = widget.orders.food;
      price = widget.orders.price;
      quantity = widget.orders.quantity;
      latitude = widget.orders.latitude;
      longitude = widget.orders.longitude;
    });
  }

  timeNow() async {
    now = await NTP.now();
    setState(() {
      loading = false;
    });
  }

  checkBarcode() async {
    var cameraScanResult = await scanner.scan();

    if (cameraScanResult == widget.orders.orderCode) {
      DatabaseService(id: widget.orders.documentId).updateOrderIsDelivered();
      deliverySuccessful(context);
    } else {
      deliveryFailed(context);
    }
  }

  deliverySuccessful(BuildContext context) {
    CorrectBlurDialog alert = CorrectBlurDialog();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  deliveryFailed(BuildContext context) {
    IncorrectBlurDialog alert = IncorrectBlurDialog();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _orderList(BuildContext context) {
    CarrierOrderListBlurryDialog alert =
        CarrierOrderListBlurryDialog(widget.orders);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  areYouSureYouWantToCancel(BuildContext context, String documentId) {
    CancelOrderBlurDialog alert = CancelOrderBlurDialog(
      documentId: documentId,
    );

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
                        GreyContainerFront(),
                        TextsAndContent(),
                        HyphenDevider(),
                        GestureDetector(
                            onTap: () {
                              areYouSureYouWantToCancel(
                                  context, widget.orders.documentId);
                            },
                            child: CancelOrder()),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(height: 5),
          Container(
            height: 30,
            width: 30,
            child: Icon(
              FontAwesomeIcons.timesCircle,
              size: 25.0,
              color: Colors.grey[200],
            ),
            // decoration: ConcaveDecoration(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(15.0),
            //     ),
            //     colors: [
            //       Colors.white,
            //       Colors.grey[700],
            //     ],
            //     depression: 4.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
    );
  }

  HyphenDevider() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11.0),
        child: Column(
          children: [
            Container(
              height: 325,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              height: 22,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Flex(
                          children: List.generate(
                            (MediaQuery.of(context).size.width / 10).floor(),
                            (index) => Container(
                              height: 1,
                              width: 5,
                              color: Colors.grey[500],
                            ),
                          ),
                          direction: Axis.horizontal,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween);
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextsAndContent() {
    return Column(
      children: <Widget>[
        // SizedBox(height: 25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                height: 48,
                width: MediaQuery.of(context).size.width,
                // color: Colors.green[200],
                child: Center(
                  child: Marquee(
                    backDuration: Duration(milliseconds: 500),
                    directionMarguee: DirectionMarguee.oneDirection,
                    child: Text(widget.orders.loungeName.toString(),
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        // color: Colors.yellow[200],
                        child: Center(
                          child: Icon(FontAwesomeIcons.hotel,
                              size: 10.0, color: Colors.grey[200]),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 22,
                            width: 30,
                            decoration: BoxDecoration(
                                // color: Colors.red[50],
                                ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Flex(
                                        children: List.generate(
                                          (3).floor(),
                                          (index) => Container(
                                            height: 1,
                                            width: 5,
                                            color: Colors.grey[200],
                                          ),
                                        ),
                                        direction: Axis.horizontal,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween);
                                  },
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 7.0),
                            child: Center(
                              child: Icon(FontAwesomeIcons.conciergeBell,
                                  size: 7.0, color: Colors.grey[200]),
                            ),
                          ),
                          Container(
                            height: 22,
                            width: 30,
                            decoration: BoxDecoration(
                                // color: Colors.red[50],
                                ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Flex(
                                        children: List.generate(
                                          (3).floor(),
                                          (index) => Container(
                                            height: 1,
                                            width: 5,
                                            color: Colors.grey[200],
                                          ),
                                        ),
                                        direction: Axis.horizontal,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween);
                                  },
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 22,
                        width: 22,
                        // color: Colors.yellow[200],
                        child: Center(
                          child: Icon(FontAwesomeIcons.houseUser,
                              size: 10.0, color: Colors.grey[200]),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 22,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Delivery status',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[200],
                                fontWeight: FontWeight.w400)),
                        Text(
                            !widget.orders.isTaken
                                ? 'Waiting...'
                                : 'On the way',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[200],
                                fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w300)),
                        Marquee(
                          backDuration: Duration(milliseconds: 400),
                          directionMarguee: DirectionMarguee.oneDirection,
                          child: Text(widget.orders.userName,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Phone',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w300)),
                        Text(widget.orders.userPhone,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Orderd items',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[500],
                            )),
                        Text(widget.orders.quantity.length.toString(),
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Cost',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[500],
                            )),
                        Text(
                            (widget.orders.subTotal +
                                        widget.orders.serviceCharge)
                                    .toString() +
                                '0 Birr',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Delivery fee',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[500],
                            )),
                        Text(widget.orders.deliveryFee.toString() + '0 Birr',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Tip',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[500],
                            )),
                        Text(widget.orders.tip.toString() + '.00 Birr',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Total',
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.grey[700],
                            )),
                        Text(
                            (widget.orders.subTotal +
                                        widget.orders.deliveryFee +
                                        widget.orders.tip +
                                        widget.orders.serviceCharge)
                                    .toString() +
                                '0 Birr',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 22),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MapRoute(
                                        documentId: widget.orders.documentId,
                                        userUid: widget.userUid,
                                        lat: widget.orders.loungeLatitude,
                                        long: widget.orders.loungeLongitude,
                                        deslat: widget.orders.latitude,
                                        deslong: widget.orders.longitude,
                                        information:
                                            widget.orders.information)),
                              );
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.orange[200],
                              ),
                              child: Center(
                                child: Icon(FontAwesomeIcons.mapMarkerAlt,
                                    size: 25.0, color: Colors.orange[500]),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              launch("tel://${widget.orders.userPhone}");
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.green[200],
                              ),
                              child: Center(
                                child: Icon(FontAwesomeIcons.phone,
                                    size: 25.0, color: Colors.green[600]),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              var status = await Permission.camera.status;
                              if (status.isGranted) {
                                // We didn't ask for permission yet or the permission has been denied before but not permanently.
                                checkBarcode();
                              } else if (status.isDenied) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AskCameraDialog();
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AskCameraDialog();
                                  },
                                );
                              }

// You can can also directly ask the permission about its status.
                              if (await Permission.location.isRestricted) {
                                // The OS restricts access, for example because of parental controls.
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[400],
                              ),
                              child: Center(
                                child: Icon(FontAwesomeIcons.camera,
                                    size: 25.0, color: Colors.grey[700]),
                              ),
                            ),
                          )
                        ],
                      ), 
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: loading == true
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 6.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.orange,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey[300],
                          ),
                          value: 0.8,
                        ),
                      ),
                    )
                  : Text(
                      convertTimeStampp(
                              widget.orders.created.millisecondsSinceEpoch)
                          .toString(),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ],
    );
  }

  String convertTimeStampp(timeStamp) {
//Pass the epoch server time and the it will format it for you

    String formatted = formatTime(timeStamp).toString();
    return formatted;
  }

  String formatTime(int timestamp) {
    /// The number of milliseconds that have passed since the timestamp
    int difference = now.millisecondsSinceEpoch - timestamp;
    String result;

    if (difference < 60000) {
      result = countSeconds(difference);
    } else if (difference < 3600000) {
      result = countMinutes(difference);
    } else if (difference < 86400000) {
      result = countHours(difference);
    } else if (difference < 604800000) {
      result = countDays(difference);
    } else if (difference / 1000 < 2419200) {
      result = countWeeks(difference);
    } else if (difference / 1000 < 31536000) {
      result = countMonths(difference);
    } else
      result = countYears(difference);

    return !result.startsWith("J") ? result + ' ago' : result;
  }

  /// Converts the time difference to a number of seconds.
  /// This function truncates to the lowest second.
  ///   returns ("Just now" OR "X seconds")
  String countSeconds(int difference) {
    int count = (difference / 1000).truncate();
    return count > 1 ? count.toString() + ' seconds' : 'Just now';
  }

  /// Converts the time difference to a number of minutes.
  /// This function truncates to the lowest minute.
  ///   returns ("1 minute" OR "X minutes")
  String countMinutes(int difference) {
    int count = (difference / 60000).truncate();
    return count.toString() + (count > 1 ? ' minutes' : ' minute');
  }

  /// Converts the time difference to a number of hours.
  /// This function truncates to the lowest hour.
  ///   returns ("1 hour" OR "X hours")
  String countHours(int difference) {
    int count = (difference / 3600000).truncate();
    return count.toString() + (count > 1 ? ' hours' : ' hour');
  }

  /// Converts the time difference to a number of days.
  /// This function truncates to the lowest day.
  ///   returns ("1 day" OR "X days")
  String countDays(int difference) {
    int count = (difference / 86400000).truncate();
    return count.toString() + (count > 1 ? ' days' : ' day');
  }

  /// Converts the time difference to a number of weeks.
  /// This function truncates to the lowest week.
  ///   returns ("1 week" OR "X weeks" OR "1 month")
  String countWeeks(int difference) {
    int count = (difference / 604800000).truncate();
    if (count > 3) {
      return '1 month';
    }
    return count.toString() + (count > 1 ? ' weeks' : ' week');
  }

  /// Converts the time difference to a number of months.
  /// This function rounds to the nearest month.
  ///   returns ("1 month" OR "X months" OR "1 year")
  String countMonths(int difference) {
    int count = (difference / 2628003000).round();
    count = count > 0 ? count : 1;
    if (count > 12) {
      return '1 year';
    }
    return count.toString() + (count > 1 ? ' months' : ' month');
  }

  /// Converts the time difference to a number of years.
  /// This function truncates to the lowest year.
  ///   returns ("1 year" OR "X years")
  String countYears(int difference) {
    int count = (difference / 31536000000).truncate();
    return count.toString() + (count > 1 ? ' years' : ' year');
  }

  GreyContainerFront() {
    return Column(
      children: <Widget>[
        Container(
          height: 325,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
            color: Colors.grey[50],
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
                color: Colors.orange[500],
              ),
            ),
          ),
        ),
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.grey[50], BlendMode.srcOut),
          child: Stack(
            children: <Widget>[
              Container(
                height: 22,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.dstOut,
                  color: Colors.grey[100],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 22,
                  width: 11,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 22,
                  width: 11,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 110,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }

  RedContainerBackShadow() {
    return Column(
      children: <Widget>[
        Container(
          height: 325,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
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
            // color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11.0),
          child: Container(
            height: 22,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
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
              // color: Colors.grey[400],
            ),
          ),
        ),
        Container(
          height: 110,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
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
            // color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }
}
