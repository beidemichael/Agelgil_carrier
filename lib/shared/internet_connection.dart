import 'package:flutter/material.dart';

class InternetConnectivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey[100].withOpacity(0),
                Colors.grey[300].withOpacity(0.0),
                Colors.grey[300].withOpacity(0.1),
                Colors.grey[300].withOpacity(0.3),
                Colors.grey[300].withOpacity(0.6),
                Colors.grey[500].withOpacity(0.8),
                Colors.grey[500],
              ],
            ),
            // borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        Positioned(
          bottom: 110,
          right: 0,
          left: 0,
          child: Image(
              image: AssetImage("images/others/no-Internet.png"),
              height: 80,
              width: 80
              // height: 60.0,
              ),
        ),
        Positioned(
          bottom: 30,
          right: 0,
          left: 0,
          child: Center(
            child: Column(
              children: [
                Text(
                  'No Internet!',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18.0,
                    color: Colors.orange[50],
                  ),
                ),
                SizedBox(height: 13),
                Text(
                  'Please check your internet connection.',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14.0,
                    color: Colors.orange[50],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
