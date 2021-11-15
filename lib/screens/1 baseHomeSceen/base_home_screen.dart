import 'dart:async';
import 'dart:math';

import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:agelgil_carrier_end/screens/1%20baseHomeSceen/drawer_content.dart';
import 'package:agelgil_carrier_end/screens/1%20baseHomeSceen/set_name/forced_name.dart';
import 'package:agelgil_carrier_end/screens/1%20baseHomeSceen/update/forced_update.dart';
import 'package:agelgil_carrier_end/screens/1.1%20map/camera_ask.dart';
import 'package:agelgil_carrier_end/screens/1.1%20map/maps.dart';
import 'package:agelgil_carrier_end/service/database.dart';
import 'package:agelgil_carrier_end/shared/loading.dart';
import 'package:android_intent/android_intent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ntp/ntp.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'not_paid/not_paid.dart';

class BaseHomeScreen extends StatefulWidget {
  @override
  _BaseHomeScreenState createState() => _BaseHomeScreenState();
}

class _BaseHomeScreenState extends State<BaseHomeScreen>
    with TickerProviderStateMixin {
  AnimationController drawerContoller;
  Animation drawerAnimation;
  String userUid = '';
  String userName = '';
  String userPhone = '';
  String userSex = ' ';
  String userPic = '';
  String documentId = '';
  var userLastPaid =  Timestamp.now();
  bool verified = false;
  bool taker = false;
  Timestamp lastPaid = Timestamp(1633096284, 38);
  Timestamp today;
  int datedifference;
  bool dateFinishedCalculating = false;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  MediaQueryData queryData;
  bool drawerIcon = false;
  bool loading = true;
  LatLng myLocation;
  final geo = Geoflutterfire();
  int controllerVersion = 0;
  int netVersion;
  /////////////////////////// App version
  int appVersion = 37;
  //////////////////////////  App version

  @override
  void initState() {
    super.initState();
    todayDate();
    _getUserLocation();

    drawerContoller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    drawerAnimation = Tween<double>(begin: 0, end: 90).animate(drawerContoller);
  }

  todayDate() async {
    DateTime startDate = await NTP.now(); // Datetime
    today = Timestamp.fromDate(startDate); // From Datetime to Timestamp
    setState(() {
      dateFinishedCalculating = true;
    });
  }

  drawerState() {
    if (drawerIcon == false) {
      drawerContoller.forward();
      drawerIcon = true;
    } else {
      drawerContoller.reverse();
      drawerIcon = false;
    }
  }

  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  void _getUserLocation() async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.medium);
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    // Position  position = await Geolocator.getCurrentPosition(
    //       desiredAccuracy: LocationAccuracy.medium,
    //       forceAndroidLocationManager: true)
    //   .timeout(Duration(seconds: 3));

    myLocation = LatLng(_locationData.latitude, _locationData.longitude);
    print('location optainerd');
    print(myLocation);
    Future.delayed(Duration(milliseconds: 300), () {
      // screenStarter();
      setState(() {
        loading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  // screenStarter() {
  //   _scaffoldState.currentState.openDrawer();
  //   Future.delayed(Duration(milliseconds: 100), () {
  //     _scaffoldState.currentState.openEndDrawer();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<List<UserInfo>>(context);
    final controllerInfo = Provider.of<List<Controller>>(context);
    if (userInfo != null) {
      if (userInfo.isNotEmpty) {
        userName = userInfo[0].userName;
        userSex = userInfo[0].userSex;
        userPhone = userInfo[0].userPhone;
        userPic = userInfo[0].userPic;
        userUid = userInfo[0].userUid;
        userLastPaid = userInfo[0].userLastPaid;
        documentId = userInfo[0].documentId;
        verified = userInfo[0].verified;
        lastPaid = userInfo[0].lastPaid;
        taker = userInfo[0].taker;
      }
    }
    if (controllerInfo != null) {
      if (controllerInfo.isNotEmpty) {
        controllerVersion = controllerInfo[0].version;
      }
    }

    if (dateFinishedCalculating == true) {
      datedifference =
          today.microsecondsSinceEpoch - lastPaid.microsecondsSinceEpoch;
    }

    netVersion = controllerVersion - appVersion;

    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Yes, exit',
                      style: TextStyle(color: Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });

        return value == true;
      },
      child: Scaffold(
        key: _scaffoldState,
        // drawer: Container(
        //   width: MediaQuery.of(context).size.width * 0.6,
        //   child: DrawerContent(
        //     documentId: documentId,
        //     userUid: userUid,
        //     userName: userName,
        //     userPhone: userPhone,
        //     userPic: userPic,
        //   ),
        // ),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            loading == true
                ? Loading()
                : Positioned(
                    child: MultiProvider(
                      providers: [
                        StreamProvider<List<Orders>>.value(
                          value: DatabaseService(userUid: userUid).orders,
                        ),
                        StreamProvider<List<Lounges>>.value(
                          value: DatabaseService(
                                  latitude: myLocation.latitude,
                                  longitude: myLocation.longitude)
                              .lounges,
                        ),
                        StreamProvider<List<OrdersCarrier>>.value(
                          value: DatabaseService(id: userUid).orderCarrier,
                        ),
                      ],
                      child: Maps(
                          userUid: userUid,
                          userName: userName,
                          userPhone: userPhone,
                          userPic: userPic,
                          verified: verified,
                          taker: taker,
                          location: _getUserLocation,
                          position: myLocation,
                          netVersion: netVersion,
                          userLastPaid: userLastPaid),
                    ),
                  ),
            Visibility(
              visible: netVersion > 4,
              child: ForcedUpdate(),
            ),
            Visibility(
              visible: userSex == '',
              child: ForcedName(
                userUid: userUid,
              ),
            ),
            Visibility(
              visible: dateFinishedCalculating == true &&
                  datedifference > 604800000000,
              child: NotPaid(),
            ),
          ],
        ),
      ),
    );
  }

  DrawerButton() {
    return GestureDetector(
      onTap: () {
        _scaffoldState.currentState.openDrawer();
      },
      child: Container(
        height: 55,
        width: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: drawerAnimation.value * (pi / 180),
              child: Icon(Icons.menu, color: Colors.orange, size: 30),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
