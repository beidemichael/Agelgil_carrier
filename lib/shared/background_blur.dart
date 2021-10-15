import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundBlur extends StatefulWidget {
  @override
  _BackgroundBlurState createState() => _BackgroundBlurState();
}

class _BackgroundBlurState extends State<BackgroundBlur> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.grey.withOpacity(0.6),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(190.0),
              ),
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
          child: Container(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}
