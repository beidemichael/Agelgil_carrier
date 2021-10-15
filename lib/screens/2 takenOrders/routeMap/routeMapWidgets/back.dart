import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Back extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[600],
                          blurRadius: 2.0, //effect of softening the shadow
                          spreadRadius: 0.5, //effecet of extending the shadow
                          offset: Offset(
                              0.0, //horizontal
                              0.0 //vertical
                              ),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(FontAwesomeIcons.arrowLeft,
                          size: 25.0, color: Colors.grey[700]),
                    ),
                  );
  }
}