
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'background_blur.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundBlur(),
        Center(
          child: SpinKitCircle(color: Colors.orange,
          size: 50.0,)
        ),
      ],
    );
  }
}