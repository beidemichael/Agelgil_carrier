import 'package:flutter/material.dart';

class NotAuthorizedMessage extends StatefulWidget {
 
  String loungeName;
  NotAuthorizedMessage({this.loungeName,});
  @override
  _NotAuthorizedMessageState createState() => _NotAuthorizedMessageState();
}

class _NotAuthorizedMessageState extends State<NotAuthorizedMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30.0),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            'You are not authorized to be an Adrash for '+ widget.loungeName ,
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
