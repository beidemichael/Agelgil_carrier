import 'dart:ui';
import 'package:flutter/material.dart';

class TooManyTrialsBlurryDialog extends StatelessWidget {
 
  VoidCallback okCallBack;

  TooManyTrialsBlurryDialog( this.okCallBack);
  TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          contentPadding: EdgeInsets.all(0),
          content: Container(
            width: 250.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Error",
                      style: TextStyle(fontSize: 24.0,color: Colors.grey[900],fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Divider(
                  color: Colors.grey,
                  height: 4.0,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
                    child: 
                    Text("You\'ve requested verification code too many times, please try again after 24 hours."
                    ,style: TextStyle(color: Colors.grey[900],fontWeight: FontWeight.w300),
                    )
                  ),
                ),
                InkWell(
                  onTap: () {
                    okCallBack();
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                    ),
                    child: Center(
                      child: Text('OK',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300)),
                    ),
                  ),
                ),
              ],
            ),
          ),
      
        ));
  }
}
