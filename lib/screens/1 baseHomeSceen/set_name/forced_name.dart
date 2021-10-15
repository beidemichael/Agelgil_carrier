import 'dart:io';
import 'dart:ui';
import 'package:agelgil_carrier_end/service/database.dart';
import 'package:launch_review/launch_review.dart';
import 'package:flutter/material.dart';

class ForcedName extends StatefulWidget {
  String userUid;
  String userName;
  ForcedName({this.userUid, this.userName});

  @override
  _ForcedNameState createState() => _ForcedNameState();
}

class _ForcedNameState extends State<ForcedName> {
  String newName;

  String sex;
  bool sexSpecified = true;
  int _radioValue = 6;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.userName != 'New member') {
      newName = widget.userName;
    } else {
      newName = 'Name';
    }
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      sexSpecified = true;
      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
      print(_radioValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10),
            child: Container(
              height: 300.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[600],
                    blurRadius: 1.0, //effect of softening the shadow
                    spreadRadius: 0.5, //effecet of extending the shadow
                    offset: Offset(
                        0.0, //horizontal
                        1.0 //vertical
                        ),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: Center(
                        child: Text('User Information',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey[700],
                            )),
                      ),
                    ),
                    Text('Please enter your name below.',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey[500],
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: TextFormField(
                        onChanged: (val) {
                          newName = val;
                        },
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500
                            // decorationColor: Colors.white,
                            ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20),

                          //Label Text/////////////////////////////////////////////////////////

                          labelText: newName,
                          // labelText: Texts.PHONE_NUMBER_LOGIN,
                          focusColor: Colors.orange[900],
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18.0,
                              color: Colors.grey[600]),
                          /* hintStyle: TextStyle(
                                    color: Colors.orange[900]
                                    ) */
                          ///////////////////////////////////////////////

                          //when it's not selected////////////////////////////
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(color: Colors.grey[400])),
                          ////////////////////////////////

                          ///when textfield is selected//////////////////////////
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide:
                                  BorderSide(color: Colors.orange[200])),
                          ////////////////////////////////////////
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Radio(
                          activeColor: Colors.orange[500],
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(
                          'Male',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        new Radio(
                          activeColor: Colors.orange[500],
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(
                          'Female',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: !sexSpecified,
                      child: Text('Please specify your gender.',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.red[500],
                          )),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              exit(0);
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                              ),
                              child: Center(
                                child: Text('Close',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () async {
                              if (newName == null) {
                                newName = 'New member';
                              }
                              if (_radioValue != 0 || _radioValue != 1) {
                                setState(() {
                                  sexSpecified = false;
                                });
                              }
                              if (_radioValue == 0) {
                                setState(() {
                                  sex = 'Male';
                                  sexSpecified = true;
                                });
                              } else if (_radioValue == 1) {
                                setState(() {
                                  sex = 'Female';
                                  sexSpecified = true;
                                });
                              }

                              await DatabaseService(userUid: widget.userUid)
                                  .updateNameandSex(newName, sex);
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0)),
                              ),
                              child: Center(
                                child: Text('Continue',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
