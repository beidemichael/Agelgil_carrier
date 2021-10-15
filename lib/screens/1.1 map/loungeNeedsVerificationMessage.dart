import 'package:flutter/material.dart';

class LoungeNeedsVerificationMessage extends StatefulWidget {
 
  String loungeName;
  LoungeNeedsVerificationMessage({this.loungeName,});
  @override
  _LoungeNeedsVerificationMessageState createState() => _LoungeNeedsVerificationMessageState();
}

class _LoungeNeedsVerificationMessageState extends State<LoungeNeedsVerificationMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30.0),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            'You are not verified to be an Adrash ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 14.0,
              // fontWeight: FontWeight.w700,
              // fontStyle: FontStyle.italic,
            ),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey[500].withOpacity(0.9)),
      ),
    );
  }
}
