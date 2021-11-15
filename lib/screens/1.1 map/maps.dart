import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:agelgil_carrier_end/screens/1%20baseHomeSceen/update/optional_update.dart';
import 'package:agelgil_carrier_end/screens/1.2%20takeorders/order_screen.dart';
import 'package:agelgil_carrier_end/screens/2%20takenOrders/takenOrdersUi/my_orders_screen.dart';
import 'package:agelgil_carrier_end/screens/3%20complete%20orders/complete_orders.dart';
import 'package:agelgil_carrier_end/service/database.dart';
import 'package:agelgil_carrier_end/shared/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'package:vibration/vibration.dart';

import 'NotAuthorizedMessage.dart';
import 'loungeNeedsVerificationMessage.dart';

class Maps extends StatefulWidget {
  String userUid;
  bool verified;
  bool taker;
  String userName;
  String userPhone;
  String userPic;
  var userLastPaid;
  LatLng position;
  Function location;
  Function orderConfirmed;
  int netVersion;
  Maps({
    this.userUid,
    this.userName,
    this.userPhone,
    this.userPic,
    this.verified,
    this.position,
    this.location,
    this.orderConfirmed,
    this.netVersion,
    this.taker,
    this.userLastPaid,
  });
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> with TickerProviderStateMixin {
  String token = '';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String _mapStyle;
  List<Orders> orders;
  bool cartVisibiliy = false;
  int categoryList = 0;
  List categoryItems = [];
  double distance = 0;
  double deliveryDistance = 0;
  double deliveryRadius = 0;
  String loungeId = '';
  String loungeName = '';
  String loungePic = '';
  bool needsVerification = false;

  static LatLng _initialPosition;
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor eateriesIcon;
  BitmapDescriptor supermarketIcon;
  GoogleMapController _controller;

  double _bearing = 0;
  double markerPointerData;
  AnimationController animationController;
  AnimationController loungeNeedsVerificationContoller;
  Animation loungeNeedsVerificationAnimation;

  AnimationController needsAuthorizationContoller;
  Animation needsAuthorizationAnimation;
  Map<MarkerId, Marker> loungeMarkers = <MarkerId, Marker>{};
  bool positionLoading = false;
  bool gotData = false;

  void getSub() async {
    //Notification when there is new order
    await firebaseMessaging.subscribeToTopic('OrderNotification');
  }

  void getAdrashSub() async {
    //Broadcast notification for adrashes only
    await firebaseMessaging.subscribeToTopic('AdrashNotification');
  }

  void getToken() async {
    token = await firebaseMessaging.getToken();
    Future.delayed(Duration(milliseconds: 1500), () {
      DatabaseService().newUserMessagingToken(
        widget.userUid,
        token,
      );
    });
  }

  loungeNeedsVerification() {
    loungeNeedsVerificationContoller.forward();
    Future.delayed(Duration(milliseconds: 1500), () {
      loungeNeedsVerificationContoller.reverse();
    });
  }

  needsAuthorization() {
    needsAuthorizationContoller.forward();
    Future.delayed(Duration(milliseconds: 1500), () {
      needsAuthorizationContoller.reverse();
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
    _getUserLocation();
    rootBundle.loadString('assets/custom_google_maps.txt').then((string) {
      _mapStyle = string;
    });
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            alert: true, badge: true, provisional: true, sound: true));

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate();
        }

        showOverlayNotification((context) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: SafeArea(
              child: ListTile(
                leading: SizedBox.fromSize(
                    size: const Size(40, 40),
                    child: ClipOval(
                        child: Container(
                      color: Colors.white,
                      child: Image(
                        image: AssetImage("images/others/Adrash.png"),
                        height: 40.0,
                        width: 40.0,
                        // color: Colors.grey[300],
                      ),
                    ))),
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
                trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    }),
              ),
            ),
          );
        }, duration: Duration(milliseconds: 4000));
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.5),
            'images/others/carrier.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 0.5), 'images/others/food.png')
        .then((onValue) {
      eateriesIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.5),
            'images/others/supermarket.png')
        .then((onValue) {
      supermarketIcon = onValue;
    });
    Future.delayed(Duration(seconds: 3), () {
      optionalUpdateActivator(context);
    });
    getSub();
    getAdrashSub();
    loungeNeedsVerificationContoller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });

    needsAuthorizationContoller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    loungeNeedsVerificationAnimation = Tween<double>(begin: -70, end: 20)
        .animate(loungeNeedsVerificationContoller);

    needsAuthorizationAnimation =
        Tween<double>(begin: -70, end: 20).animate(needsAuthorizationContoller);
  }

  ////////////////method for generating the over head text marker.
  Future<BitmapDescriptor> getMarkerName(
      final Color collor, String name, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = collor.withOpacity(0.5);
    final double tagWidth = 40.0;

    // Add tag circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, size.width, tagWidth + 20),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        tagPaint);

    // Add tag text
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr, textAlign: TextAlign.left);
    textPainter.text = TextSpan(
      text: name,
      style: TextStyle(
          fontSize: 30.0, fontWeight: FontWeight.w800, color: Colors.white),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(40, 10));

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  Future<BitmapDescriptor> getMarkerOrders(final Color collor, Size size,
      List<Orders> orders, String loungeId) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = collor.withOpacity(0.5);
    final double tagWidth = 40.0;
    int orderCount = 0;

    for (int i = 0; i < orders.length; i++) {
      if (orders[i].loungeId == loungeId) {
        orderCount++;
      }
    }

    // Add tag circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, size.width, tagWidth + 20),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        tagPaint);

    // Add tag text
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr, textAlign: TextAlign.left);
    textPainter.text = TextSpan(
      text: orderCount.toString(),
      style: TextStyle(
          fontSize: 30.0, fontWeight: FontWeight.w800, color: Colors.white),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(40, 10));

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  getFromDatabase(
    List<Lounges> lounges,
    List<Orders> orders,
  ) async {
    setState(() {
      loungeMarkers[MarkerId('me')] = Marker(
          markerId: MarkerId('me'),
          position: _initialPosition,
          icon: pinLocationIcon);
    });

    //for marker symbol
    for (int i = 0; i < lounges.length; i++) {
      deliveryDistance = calculateDistance(
          lounges[i].latitude,
          lounges[i].longitude,
          _initialPosition.latitude,
          _initialPosition.longitude);
      deliveryRadius = lounges[i].deliveryRadius;
      double differenceOfRadiuses = deliveryRadius - deliveryDistance;

      int markerNumber = 0;
      String markerIdVal = lounges[i].documentId;
      String markerIdVal2 = lounges[i].documentId + markerNumber.toString();
      String markerIdVal3 = lounges[i].documentId +
          lounges[i].documentId +
          markerNumber.toString();

      final MarkerId markerId = MarkerId(markerIdVal);

      // creating a new MARKER

      //////////////////////////Over head text(name of eatery)//////////////////////

      final Marker markerName = Marker(
          onTap: () {
            if (lounges[i].name != null) {
              setState(() {
                categoryItems = lounges[i].category;
                categoryList = lounges[i].category.length;
                loungeName = lounges[i].name;
                loungeId = lounges[i].id;
                needsVerification = lounges[i].needsVerification;
                loungePic = lounges[i].images;
                distance = calculateDistance(
                    lounges[i].latitude,
                    lounges[i].longitude,
                    _initialPosition.latitude,
                    _initialPosition.longitude);
              });
            }
            lounges[i].category == null
                ? loading()
                : loungeDetailActivator(
                    context, lounges[i].id, lounges[i].needsVerification);
          },
          markerId: markerId,
          anchor: Offset(0.5, 1.1),
          position: LatLng(lounges[i].latitude ?? 0, lounges[i].longitude ?? 0),
          icon: await getMarkerName(
              lounges[i].lounge == 'eatery' ? Colors.red : Colors.cyan,
              lounges[i].name,
              Size(lounges[i].name.length.toDouble() * 17 + 70, 150.0)));
      //////////////////////////Over head text(name of eatery)//////////////////////
      ///
      ///
      ///

//////////////////////////Over head text(order of eatery)//////////////////////

      final Marker markerNameOrder = Marker(
          onTap: () {
            if (lounges[i].name != null) {
              setState(() {
                categoryItems = lounges[i].category;
                categoryList = lounges[i].category.length;
                loungeName = lounges[i].name;
                loungeId = lounges[i].id;
                needsVerification = lounges[i].needsVerification;
                loungePic = lounges[i].images;
                distance = calculateDistance(
                    lounges[i].latitude,
                    lounges[i].longitude,
                    _initialPosition.latitude,
                    _initialPosition.longitude);
              });
            }
            lounges[i].category == null
                ? loading()
                : loungeDetailActivator(
                    context, lounges[i].id, lounges[i].needsVerification);
          },
          markerId: MarkerId(markerIdVal3.toString()),
          anchor: Offset(0.5, 1.6),
          position: LatLng(lounges[i].latitude ?? 0, lounges[i].longitude ?? 0),
          icon: await getMarkerOrders(
              lounges[i].lounge == 'eatery' ? Colors.red : Colors.cyan,
              Size(100, 150.0),
              orders,
              lounges[i].id));
      //////////////////////////Over head text(order of eatery)//////////////////////

      /////////////////////////////eatery symbol//////////////////////

      final Marker marker = Marker(
          markerId: MarkerId(markerIdVal2.toString()),
          position: LatLng(lounges[i].latitude ?? 0, lounges[i].longitude ?? 0),
          icon: lounges[i].lounge == 'eatery' ? eateriesIcon : supermarketIcon,
          onTap: () {
            if (lounges[i].name != null) {
              setState(() {
                categoryItems = lounges[i].category;
                categoryList = lounges[i].category.length;
                loungeName = lounges[i].name;
                loungeId = lounges[i].id;
                needsVerification = lounges[i].needsVerification;
                loungePic = lounges[i].images;
                distance = calculateDistance(
                    lounges[i].latitude,
                    lounges[i].longitude,
                    _initialPosition.latitude,
                    _initialPosition.longitude);
              });
            }
            lounges[i].category == null
                ? loading()
                : loungeDetailActivator(
                    context, lounges[i].id, lounges[i].needsVerification);
          });

      /////////////////////////////eatery symbol//////////////////////
      if (lounges[i].active == true && lounges[i].weAreOpen == true) {
        if (differenceOfRadiuses >= 0) {
          setState(() {
            // adding a new marker to map
            loungeMarkers[markerId] = markerName;
            loungeMarkers[MarkerId(markerIdVal2.toString())] = marker;
            loungeMarkers[MarkerId(markerIdVal3.toString())] = markerNameOrder;
          });
        } else {
          setState(() {
            loungeMarkers.remove(markerId);
            loungeMarkers.remove(MarkerId(markerIdVal2.toString()));
            loungeMarkers.remove(MarkerId(markerIdVal3.toString()));
          });
        }
      } else {
        setState(() {
          loungeMarkers.remove(markerId);
          loungeMarkers.remove(MarkerId(markerIdVal2.toString()));
          loungeMarkers.remove(MarkerId(markerIdVal3.toString()));
        });
      }
      markerNumber++;
    }
  }

  void _getUserLocation() async {
    setState(() {
      positionLoading = true;
    });
    widget.location();

    setState(() {
      _initialPosition =
          LatLng(widget.position.latitude, widget.position.longitude);
      positionLoading = false;
    });
    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: _bearing,
              target:
                  LatLng(widget.position.latitude, widget.position.longitude),
              tilt: 0,
              zoom: 17.00)));
    }
  }

  void _getUserLocation2() async {
    setState(() {
      positionLoading = true;
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      positionLoading = false;
    });
    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: _bearing,
              target:
                  LatLng(_initialPosition.latitude, _initialPosition.longitude),
              tilt: 0,
              zoom: 17.00)));
    }
  }

  loungeDetailActivator(
      BuildContext context, String loungeId, bool needsVerification) {
    if (needsVerification == true) {
      print("needsVerification = true");
      if (widget.taker == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StreamProvider<List<Orders>>.value(
                  value: DatabaseService(loungeId: loungeId).ordersDetail,
                  child: OrdersScreen(
                    lat: _initialPosition.latitude,
                    long: _initialPosition.longitude,
                    userName: widget.userName,
                    userPhone: widget.userPhone,
                    verified: widget.verified,
                    userPic: widget.userPic,
                    userUid: widget.userUid,
                    isAuthorized: widget.taker,
                  )),
            ));
      } else {
        needsAuthorization();
      }
    } else {
      print("needsVerification = false");
      if (widget.verified == true) {
        print("verified = true");

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StreamProvider<List<Orders>>.value(
                  value: DatabaseService(loungeId: loungeId).ordersDetail,
                  child: OrdersScreen(
                    lat: _initialPosition.latitude,
                    long: _initialPosition.longitude,
                    userName: widget.userName,
                    userPhone: widget.userPhone,
                    verified: widget.verified,
                    userPic: widget.userPic,
                    userUid: widget.userUid,
                    isAuthorized: widget.taker,
                  )),
            ));
      } else {
        loungeNeedsVerification();
      }
    }
  }

  optionalUpdateActivator(BuildContext context) {
    if (widget.netVersion == 3 || widget.netVersion == 4) {
      OptionalUpdate alert = OptionalUpdate();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  loading() {}

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Orders>>(context) ?? [];
    final lounges = Provider.of<List<Lounges>>(context) ?? [];
    final carrierOrders = Provider.of<List<OrdersCarrier>>(context) ?? [];
    if (lounges != null) {
      if (gotData == false) {
        getFromDatabase(lounges, orders);
        if (lounges.length > 0) {
          gotData = true;
        }
      }
    }
    return Scaffold(
      body: _initialPosition == null
          ? Loading()
          : lounges == null
              ? Loading()
              : Stack(
                  children: <Widget>[
                    Positioned(
                      child: Center(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          tiltGesturesEnabled: false,
                          initialCameraPosition: CameraPosition(
                            tilt: 0,
                            bearing: 0,
                            target: _initialPosition,
                            zoom: 17.00,
                          ),
                          markers: Set<Marker>.of(loungeMarkers.values),
                          compassEnabled: false,
                          zoomControlsEnabled: false,
                          mapToolbarEnabled: false,
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                            _controller.setMapStyle(_mapStyle);
                            setState(() {
                              loungeMarkers[MarkerId('me')] = Marker(
                                  markerId: MarkerId('me'),
                                  position: _initialPosition,
                                  icon: pinLocationIcon);
                            });
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 100.0,
                      right: 20.0,
                      child: LocationButton(),
                    ),
                    Positioned(
                      bottom: 170.0,
                      right: 20.0,
                      child: TakenOrdersButton(),
                    ),
                    Positioned(
                      right: 15,
                      bottom: 207,
                      child: Container(
                        height: 23.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                          color: Colors.orange[500].withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            carrierOrders.length.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 11.0),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: RefreshButton(
                        lounges,
                        orders,
                      ),
                    ),
                    Positioned(child: CompleteOrderss()),
                    Positioned(
                      right: 0.0,
                      left: 0.0,
                      bottom: loungeNeedsVerificationAnimation.value,
                      child: LoungeNeedsVerificationMessage(
                        loungeName: loungeName,
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      left: 0.0,
                      bottom: needsAuthorizationAnimation.value,
                      child: NotAuthorizedMessage(
                        loungeName: loungeName,
                      ),
                    ),
                  ],
                ),
    );
  }

  TakenOrdersButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StreamProvider<List<OrdersCarrier>>.value(
                  value: DatabaseService(id: widget.userUid).orderCarrier,
                  child: CarrierMyOrdersScreen(userUid: widget.userUid)),
            ));
      },
      child: Container(
        width: 60.0,
        height: 60.0,
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
          borderRadius: BorderRadius.circular(60.0),
        ),
        child: Center(
          child: Container(
            height: 22.0,
            width: 22.0,
            child: Center(
              child: Icon(FontAwesomeIcons.conciergeBell,
                  size: 20.0, color: Colors.orange[500]),
            ),
          ),
        ),
      ),
    );
  }

  LocationButton() {
    return Stack(
      children: <Widget>[
        Center(
          child: InkWell(
            onTap: () async {
              _getUserLocation2();
            },
            child: Container(
              width: 60.0,
              height: 60.0,
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
                borderRadius: BorderRadius.circular(60.0),
              ),
              child: positionLoading == true
                  ? Center(
                      child: SpinKitCircle(
                      color: Colors.orange,
                      size: 20.0,
                    ))
                  : Center(
                      child: Container(
                        height: 22.0,
                        width: 22.0,
                        child: Image(
                          image: AssetImage("images/others/position.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  RefreshButton(
    List<Lounges> lounges,
    List<Orders> orders,
  ) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 30.0,
          right: 0.0,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  getFromDatabase(lounges, orders);
                },
                child: Container(
                  width: 60.0,
                  height: 60.0,
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
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  child: Center(
                    child: Container(
                      height: 22.0,
                      width: 22.0,
                      child: Center(
                        child: Icon(FontAwesomeIcons.redoAlt,
                            size: 15.0, color: Colors.orange[500]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  CompleteOrderss() {
    print(widget.userLastPaid);
    return Stack(
      children: <Widget>[
        Positioned(
          top: 50.0,
          left: 0.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiProvider(
                          providers: [
                            // StreamProvider<List<Orders>>.value(
                            //   value: DatabaseService(userUid: widget.userUid)
                            //       .orders,
                            // ),
                            StreamProvider<List<Orders>>.value(
                              value: DatabaseService(
                                      userUid: widget.userUid,
                                      carrierLastPaid: widget.userLastPaid)
                                  .adrashFromLastPaidProgress,
                            ),
                          ],
                          child:
                              AdrashCompleteOrders(carrierUid: widget.userUid),
                        ),
                      ));

                  //              StreamProvider<List<Orders>>.value(
                  //   value: DatabaseService(loungeId: userUid).completeOrders,
                  //   child: CompleteOrders(),
                  // );
                },
                child: Container(
                  width: 60.0,
                  height: 60.0,
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
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  child: Center(
                    child: Container(
                      height: 22.0,
                      width: 22.0,
                      child: Center(
                        child: Icon(FontAwesomeIcons.history,
                            size: 15.0, color: Colors.orange[500]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
