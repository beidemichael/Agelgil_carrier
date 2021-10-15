import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';

class Infromation extends StatelessWidget {
  String information;
  Infromation({this.information});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
       
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Center(
          child: Marquee(
        backDuration: Duration(milliseconds: 500),
        directionMarguee: DirectionMarguee.oneDirection,
        child: Text(information,
            style: TextStyle(
                fontSize: 15,
                color: Colors.grey[900],
                fontWeight: FontWeight.w500)),
      )),
    );
  }
}
