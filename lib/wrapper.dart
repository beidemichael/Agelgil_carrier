import 'dart:async';
import 'dart:io';
import 'package:agelgil_carrier_end/screens/1%20baseHomeSceen/base_home_screen.dart';
import 'package:agelgil_carrier_end/screens/signin/signIn.dart';
import 'package:agelgil_carrier_end/service/database.dart';
import 'package:agelgil_carrier_end/shared/internet_connection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/Models.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isInternetConnected = true;
  StreamSubscription subscription;
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
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuth>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: user == null
                ? SignIn()
                : MultiProvider(
                    providers: [
                      StreamProvider<List<UserInfo>>.value(
                        value: DatabaseService(userUid: user.uid).userInfo,
                      ),
                      StreamProvider<List<Controller>>.value(
                        value: DatabaseService().controllerInfo,
                      ),
                    ],
                    child: BaseHomeScreen(),
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
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }
}
