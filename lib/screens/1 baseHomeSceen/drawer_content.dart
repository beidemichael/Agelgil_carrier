import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:agelgil_carrier_end/screens/2%20takenOrders/takenOrdersUi/my_orders_screen.dart';
import 'package:agelgil_carrier_end/service/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DrawerContent extends StatelessWidget {
  String userUid;
  String userName;
  String userPhone;
  String userPic;
  String documentId;
  DrawerContent(
      {this.documentId,
      this.userName,
      this.userPhone,
      this.userPic,
      this.userUid});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
        ],
      ),
    );
  }
}
