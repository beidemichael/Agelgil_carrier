import 'package:flutter/material.dart';
class RedContainerBackShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 215,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[500],
                blurRadius: 5.0, //effect of softening the shadow
                spreadRadius: 0.1, //effecet of extending the shadow
                offset: Offset(
                    0.0, //horizontal
                    3.0 //vertical
                    ),
              ),
            ],
            // color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11.0),
          child: Container(
            height: 22,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500],
                  blurRadius: 5.0, //effect of softening the shadow
                  spreadRadius: 0.1, //effecet of extending the shadow
                  offset: Offset(
                      0.0, //horizontal
                      3.0 //vertical
                      ),
                ),
              ],
              // color: Colors.grey[400],
            ),
          ),
        ),
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[500],
                blurRadius: 5.0, //effect of softening the shadow
                spreadRadius: 0.1, //effecet of extending the shadow
                offset: Offset(
                    0.0, //horizontal
                    3.0 //vertical
                    ),
              ),
            ],
            // color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }
}