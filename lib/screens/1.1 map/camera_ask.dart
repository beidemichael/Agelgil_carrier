import 'dart:ui';

import 'package:agelgil_carrier_end/shared/concave_decoration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:marquee_widget/marquee_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class AskCameraDialog extends StatelessWidget {
  Function turnOnLocation;
  AskCameraDialog({this.turnOnLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Center(
          child: Stack(
            children: [
              Container(
                width: 250.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Camera Permission",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 4.0,
                        ),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                // color: Colors.red,
                                height: 100,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                      "This app needs access to camera",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                    Map<Permission, PermissionStatus> statuses =
                                        await [
                                      Permission.camera,
                                    ].request();
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 65,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                    ),
                                    color: Colors.orange,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Turn on",
                                      style: TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w100),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      /////////////////////////////// close button
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                          )),
                    ),
                    Positioned(
                      ///////////////////////////////convex effect for close button
                      top: 0.0,
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          child: Icon(
                            FontAwesomeIcons.times,
                            size: 18.0,
                            color: Colors.grey,
                          ),
                          decoration: ConcaveDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              colors: [
                                Colors.white,
                                Colors.grey[700],
                              ],
                              depression: 4.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
