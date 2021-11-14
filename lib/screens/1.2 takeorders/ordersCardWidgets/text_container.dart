import 'dart:ui';

import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:agelgil_carrier_end/screens/1.1%20map/camera_ask.dart';
import 'package:agelgil_carrier_end/screens/1.2%20takeorders/alert/failed.dart';
import 'package:agelgil_carrier_end/screens/1.2%20takeorders/alert/order_is_taken.dart';
import 'package:agelgil_carrier_end/screens/1.2%20takeorders/alert/sucessful.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:geolocator/geolocator.dart';
import 'package:agelgil_carrier_end/service/database.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class TextsAndContent extends StatefulWidget {
  Orders orders;
  double lat;
  double long;
  String userUid;
  String userName;
  String userPhone;
  String userPic;
  bool verified;
  DateTime now;
  bool loading;
  bool isAuthorized;
  TextsAndContent({
    this.orders,
    this.lat,
    this.long,
    this.userName,
    this.userPhone,
    this.userPic,
    this.userUid,
    this.now,
    this.loading,
    this.verified,
    this.isAuthorized,
  });
  @override
  _TextsAndContentState createState() => _TextsAndContentState();
}

class _TextsAndContentState extends State<TextsAndContent> {
  double deslat;
  double deslong;
  LatLng _initialPosition;
  bool orderNotTaken = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deslong = widget.orders.longitude;
    deslat = widget.orders.latitude;
    print(deslong);
    print(deslat);
  }

  takeOrder() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    DatabaseService(id: widget.orders.documentId).updateOrderWithCarriers(
        widget.userName,
        widget.userPhone,
        widget.userUid,
        widget.userPic,
        position.latitude,
        position.longitude);
  }

  // checkQRcode() async {
  //   if (widget.orders.isTaken == true) {
  //     //order is taken by another carrier.
  //     orderIsTaken(context);
  //   } else {
  //     var cameraScanResult = await scanner.scan();

  //     if (cameraScanResult == widget.orders.loungeOrderNumber||cameraScanResult == widget.orders.loungeId ) {
  //       Position position = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high);
  //       DatabaseService(id: widget.orders.documentId).updateOrderWithCarriers(
  //           widget.userName,
  //           widget.userPhone,
  //           widget.userUid,
  //           widget.userPic,
  //           position.latitude,
  //           position.longitude);
  //       deliverySuccessful(context);
  //     } else {
  //       deliveryFailed(context);
  //     }
  //   }
  // }
  checkIfTaken(String documentUid) async {
    setState(() {
      orderNotTaken = true;
    });
    DateTime checkInternetConnection = await NTP.now();
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(documentUid)
        .get()
        .then((docs) async {
      if (docs != null) {
        if (docs.data()['isTaken'] == false) {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          DatabaseService(id: widget.orders.documentId).updateOrderWithCarriers(
              widget.userName,
              widget.userPhone,
              widget.userUid,
              widget.userPic,
              position.latitude,
              position.longitude);
        } else {
          orderIsTaken(context);
        }
      }
    });
    setState(() {
      orderNotTaken = false;
    });
  }

  orderIsTaken(BuildContext context) {
    OrderIsTaken alert = OrderIsTaken();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            // SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.green[200],
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Delivery fee ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300)),
                          Text(
                              widget.orders.deliveryFee.toInt().toString() +
                                  "Birr",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 25,
                        // color: Colors.yellow[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tip',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w300)),
                            Text(widget.orders.tip.toString() + "Birr",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      SizedBox(height: 13),
                      Container(
                        height: 25,
                        // color: Colors.yellow[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Orderd items',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w300)),
                            Text(widget.orders.quantity.length.toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 25,
                        // color: Colors.blue[200],
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Cost',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w300)),
                            Text(
                                (widget.orders.subTotal +
                                            widget.orders.serviceCharge)
                                        .toString() +
                                    ' Birr',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                Container(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width,
                  height: 25,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Distance:     ',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300)),
                          Text(widget.orders.distance.toStringAsFixed(2) + 'Km',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                InkWell(
                  onTap: () async {
                    if (widget.isAuthorized == true) {
                      checkIfTaken(widget.orders.documentId);
                    } else {
                      checkIfTaken(widget.orders.documentId);
//                   var status = await Permission.camera.status;
//                   if (status.isGranted) {
//                     // We didn't ask for permission yet or the permission has been denied before but not permanently.
//                     checkQRcode();
//                   } else if (status.isDenied) {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AskCameraDialog();
//                       },
//                     );
//                   } else {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AskCameraDialog();
//                       },
//                     );

//                     // showDialog(
//                     //     context: context,
//                     //     builder: (BuildContext context) => CupertinoAlertDialog(
//                     //           title: Text('Camera Permission'),
//                     //           content: Text(
//                     //               'This app needs camera access to take pictures for upload user profile photo'),
//                     //           actions: <Widget>[
//                     //             CupertinoDialogAction(
//                     //               child: Text('Deny'),
//                     //               onPressed: () => Navigator.of(context).pop(),
//                     //             ),
//                     //             CupertinoDialogAction(
//                     //                 child: Text('Settings'),
//                     //                 onPressed: () async {
//                     //                   // openAppSettings();
//                     //                   Map<Permission, PermissionStatus> statuses =
//                     //                       await [
//                     //                     Permission.camera,
//                     //                   ].request();
//                     //                 }
//                     //                 //
//                     //                 ),
//                     //           ],
//                     //         ));
//                   }

// // You can can also directly ask the permission about its status.
//                   if (await Permission.location.isRestricted) {
//                     // The OS restricts access, for example because of parental controls.
//                   }
                    }
                  },
                  child: Center(
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                          color: widget.orders.isTaken == false
                              ? Colors.orange[500]
                              : Colors.grey[500]),
                      child: Center(
                          child: orderNotTaken == true
                              ? Center(
                                  child: SpinKitCircle(
                                  color: Colors.white,
                                  size: 30.0,
                                ))
                              : Text('PICK',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
                SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: widget.loading == true
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
        ),
        // Positioned(
        //   child: Visibility(
        //     visible: orderNotTaken,
        //     child: Center(
        //       child: BackdropFilter(
        //         filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        //         child: Center(
        //             child: SpinKitCircle(
        //           color: Colors.orange,
        //           size: 50.0,
        //         )),
        //       ),
        //     ),
        //   ),
        // ),
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
    int difference = widget.now.millisecondsSinceEpoch - timestamp;
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
}
