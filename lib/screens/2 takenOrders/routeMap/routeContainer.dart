import 'dart:async';

import 'package:agelgil_carrier_end/screens/2%20takenOrders/routeMap/routeMapWidgets/back.dart';
import 'package:agelgil_carrier_end/screens/2%20takenOrders/routeMap/routeMapWidgets/information.dart';
import 'package:agelgil_carrier_end/screens/2%20takenOrders/routeMap/routeMapWidgets/routeMap.dart';
import 'package:agelgil_carrier_end/service/database.dart';
import 'package:agelgil_carrier_end/shared/internet_connection.dart';
import 'package:agelgil_carrier_end/shared/loading.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marquee_widget/marquee_widget.dart';

class MapRoute extends StatefulWidget {
  String information;
  String userUid;
  double lat;
  double long;
  double deslat;
  double deslong;
  String documentId;
  MapRoute(
      {this.userUid,
      this.lat,
      this.long,
      this.deslat,
      this.deslong,
      this.documentId,
      this.information});
  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {
  GoogleMapController _controller;
  LatLng _initialPosition;
  LatLng _tempInitialPosition;
  Map<MarkerId, Circle> circleA = <MarkerId, Circle>{};
  LatLng _lastMapPosition;
  Map<MarkerId, Marker> marker = <MarkerId, Marker>{};
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor eateriesIcon;
  // Object for PolylinePoints
  PolylinePoints polylinePoints;
// List of coordinates to join
  List<LatLng> polylineCoordinates = [];
// Map storing polylines created by connecting
// two points
  Map<PolylineId, Polyline> polylines = {};
  String googleAPIKey = "AIzaSyByQibVskdRB0VCOHIkyLrdunhuC8vDYNA";
  TravelMode travelModeOption = TravelMode.walking;
  StreamSubscription subscription;
  StreamSubscription positionStream;
  bool isInternetConnected = true;
  Timer timer;
  bool polylineVisible = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    ////////////internet subscription
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
    /////////////////////////////////////////////////
    //////////////location subscription
   
    positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.best, distanceFilter: 1,timeInterval: 1)
        .listen((Position position) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    });
    ///////////////////////////////////
    ///
    //////////////////update carrier location on database
    ///

    timer = Timer.periodic(Duration(seconds: 60), (Timer t) {
      _tempInitialPosition = _initialPosition;
      DatabaseService(id: widget.documentId).updateCarrierLocation(
          _tempInitialPosition.latitude, _tempInitialPosition.longitude);
    });

    ////////////////////////
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.5),
            'images/others/person.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 0.5), 'images/others/food.png')
        .then((onValue) {
      eateriesIcon = onValue;
    });
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print(_initialPosition);
      _createPolylines();
    });
    _tempInitialPosition = _initialPosition;
    DatabaseService(id: widget.documentId).updateCarrierLocation(
        _tempInitialPosition.latitude, _tempInitialPosition.longitude);
    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 0,
              target: LatLng(position.latitude, position.longitude),
              tilt: 0,
              zoom: 17.00)));
    }
  }

  _createPolylines() async {
    setState(() {
      polylineVisible = true;
    });
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey, // Google Maps API Key
      PointLatLng(_initialPosition.latitude, _initialPosition.longitude),
      PointLatLng(widget.deslat, widget.deslong),
      travelMode: travelModeOption,
    );
    print('poly result');
    print(result);
    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.orange,
      points: polylineCoordinates,
    );

    // Adding the polyline to the map
    setState(() {
      polylines[id] = polyline;
      polylineVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _initialPosition == null
              ? Loading()
              : RouteMap(
                  circleA: circleA,
                  controller: _controller,
                  initialPosition: _initialPosition,
                  deslat: widget.deslat,
                  deslong: widget.deslong,
                  marker: marker,
                  polylines: polylines,
                  lastMapPosition: _lastMapPosition,
                  lat: widget.lat,
                  long: widget.long,
                ),
          Visibility(visible: polylineVisible, child: Loading()),
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
              bottom: 30,
              left: 10,
              right: 10,
              child: Infromation(information: widget.information)),
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
    timer?.cancel();
    super.dispose();
    subscription.cancel();
    positionStream.cancel();
  }
}
