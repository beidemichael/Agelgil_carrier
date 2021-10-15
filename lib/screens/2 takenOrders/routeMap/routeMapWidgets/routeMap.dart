import 'package:agelgil_carrier_end/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class RouteMap extends StatefulWidget {
  GoogleMapController controller;
  LatLng initialPosition;
  Map<MarkerId, Circle> circleA = <MarkerId, Circle>{};
  Map<MarkerId, Marker> marker = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polylines = {};
  LatLng lastMapPosition;
  double deslat;
  double deslong;
  double lat;
  double long;
  // Future<dynamic> createPolylines;
  Function onCameraMove;

  RouteMap({
    this.lastMapPosition,
    this.initialPosition,
    this.circleA,
    this.marker,
    this.polylines,
    this.controller,
    this.deslat,
    this.deslong,
    // this.createPolylines,
    this.onCameraMove,
    this.lat,
    this.long,
  });
  @override
  _RouteMapState createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  GoogleMapController _controller;
  double _zoom;
  double _bearing;
  LatLng _tempInitialPosition;
  String _mapStyle;
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor eateriesIcon;
  BitmapDescriptor carrierIcon;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    rootBundle
        .loadString('assets/custom_google_maps_for_OrderTracking.txt')
        .then((string) {
      _mapStyle = string;
    });

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
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.5),
            'images/others/carrier.png')
        .then((onValue) {
      carrierIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    _tempInitialPosition = widget.initialPosition;
    setState(() {
      widget.marker[MarkerId('carrier')] = Marker(
          markerId: MarkerId('carrier'),
          position: widget.initialPosition,
          icon: carrierIcon);
    });
    return GoogleMap(
      mapType: MapType.normal,
      tiltGesturesEnabled: false,
      compassEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      // onCameraMove: (CameraPosition position) {
      //   _zoom = position.zoom;
      //   _bearing = position.bearing;
      //   _controller.animateCamera(CameraUpdate.newCameraPosition(
      //       new CameraPosition(
      //           target: LatLng(_tempInitialPosition.latitude,
      //               _tempInitialPosition.longitude),
      //           tilt: 60,
      //           zoom: _zoom,
      //           bearing: _bearing)));
      // },
      initialCameraPosition: CameraPosition(
        tilt: 0,
        bearing: 0,
        target: widget.initialPosition,
        zoom: 17,
      ),
      polylines: Set<Polyline>.of(widget.polylines.values),
      circles: Set<Circle>.of(widget.circleA.values),
      markers: Set<Marker>.of(widget.marker.values),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
        _controller.setMapStyle(_mapStyle);
        setState(() {
          widget.marker[MarkerId('me')] = Marker(
              markerId: MarkerId('me'),
              position: LatLng(widget.deslat, widget.deslong),
              icon: pinLocationIcon);

          widget.marker[MarkerId('lounge')] = Marker(
              markerId: MarkerId('lounge'),
              position: LatLng(widget.lat, widget.long),
              icon: eateriesIcon);

          widget.marker[MarkerId('carrier')] = Marker(
              markerId: MarkerId('carrier'),
              position: widget.initialPosition,
              icon: carrierIcon);

          widget.circleA[MarkerId('a')] = Circle(
              circleId: CircleId("A"),
              center: LatLng(widget.deslat, widget.deslong),
              radius: 30,
              fillColor: Colors.orange.withOpacity(0.5),
              strokeColor: Colors.orange[200].withOpacity(0.5),
              strokeWidth: 10);
        });
      },
    );
  }
}
