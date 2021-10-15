
import 'package:agelgil_carrier_end/service/auth.dart';
import 'package:agelgil_carrier_end/service/database.dart';
import 'package:agelgil_carrier_end/shared/loading.dart';
import 'package:agelgil_carrier_end/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'models/Models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        // if (snapshot.hasError) {
        //   return SomethingWentWrong();
        // }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<UserAuth>.value(
            value: AuthServices().user,
            child: OverlaySupport(
                          child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Wrapper(),
              ),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Loading(),
            ));
      },
    );
  }
}
