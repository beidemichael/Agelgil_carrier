import 'dart:async';


import 'package:agelgil_carrier_end/screens/signin/error_signingin.dart';
import 'package:agelgil_carrier_end/screens/signin/expired_code_blury_dialog.dart';
import 'package:agelgil_carrier_end/screens/signin/phonenumber_dialog.dart';
import 'package:agelgil_carrier_end/screens/signin/too_many_times.dart';
import 'package:agelgil_carrier_end/service/auth.dart';
import 'package:agelgil_carrier_end/shared/background_blur.dart';
import 'package:agelgil_carrier_end/shared/orange_button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String phoneCode = "+251";
  String phoneNumber = "";
  String wholePhoneNumber = "";
  String otpCode = "";
  String loginState = "";

  bool otpVisible = false;
  bool resendVisible = false;

  @override
  void initState() {
    super.initState();
    // _getFirebaseUser();
  }

  Timer _timer;
  int _start = 59;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start == 2) {
            _showExpiredDialog(context);
            otpVisible = false;
          }
          if (_start == 1) {
            setState(() {
              resendVisible = true;
            });
          }
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  _showExpiredDialog(BuildContext context) {
    VoidCallback okCallBack = () => {
          Navigator.of(context).pop(),
          setState(() {
            resendVisible = false;
          }),
        };
    BlurryDialog alert = BlurryDialog(okCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showErrorDialog(BuildContext context) {
    VoidCallback okCallBack = () => {
          Navigator.of(context).pop(),
        };
    ErrorSigningInBlurryDialog alert = ErrorSigningInBlurryDialog(okCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _tooManyTimesTried(BuildContext context) {
    VoidCallback okCallBack = () => {
          Navigator.of(context).pop(),
          _timer.cancel(),
          setState(() {
            otpVisible = false;
          }),
        };
    TooManyTrialsBlurryDialog alert = TooManyTrialsBlurryDialog(okCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showPhoneDialog(BuildContext context) {
    VoidCallback toManyTimes = () => {
          _tooManyTimesTried(context),
        };
    VoidCallback yesCallBack = () => {
          Navigator.of(context).pop(),
          AuthServices(wholePhoneNumber: wholePhoneNumber)
              .submitPhoneNumber(toManyTimes),
          startTimer(),
          print('submit'),
          setState(() {
            otpVisible = true;
            _start = 59;
          }),
        };
    VoidCallback noCallBack = () => {
          Navigator.of(context).pop(),
        };
    PhoneBlurryDialog alert =
        PhoneBlurryDialog(wholePhoneNumber, yesCallBack, noCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      phoneCode = countryCode.toString();
    });

    print("New Country selected: " + countryCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: <Widget>[
          BackgroundBlur(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: ListView(
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 94),
                  Visibility(
                    visible: !otpVisible,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          // child: TextField(
                          //   controller: _phoneNumberController,
                          //   decoration: InputDecoration(
                          //     hintText: 'Phone Number',
                          //     border: OutlineInputBorder(),
                          //   ),
                          // ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: CountryCodePicker(
                                  onChanged: _onCountryChange,
                                  initialSelection: '+251',
                                  favorite: ['+251', 'ETH'],
                                  textStyle: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                  showFlag: true,

                                  showFlagDialog: true,
                                  //comparator: (a, b) => b.name.compareTo(a.name),
                                  //Get the country information relevant to the initial selection
                                  //onInit: (code) => print("${code.name} ${code.dialCode}"),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      phoneNumber = val;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500
                                      // decorationColor: Colors.white,
                                      ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 20),

                                    //Label Text/////////////////////////////////////////////////////////
                                    labelText: 'Enter Phone Number',
                                    // labelText: Texts.PHONE_NUMBER_LOGIN,
                                    focusColor: Colors.orange[900],
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 15.0,
                                        color: Colors.grey[800]),
                                    /* hintStyle: TextStyle(
                                  color: Colors.orange[900]
                                  ) */
                                    ///////////////////////////////////////////////

                                    //when it's not selected////////////////////////////
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                        borderSide: BorderSide(
                                            color: Colors.grey[400])),
                                    ////////////////////////////////

                                    ///when textfield is selected//////////////////////////
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                        borderSide: BorderSide(
                                            color: Colors.orange[200])),
                                    ////////////////////////////////////////
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: otpVisible,
                    child: TextFormField(
                      validator: (val) => val.length != 6
                          ? 'Code should be 6 digits long'
                          : null,
                      textAlign: TextAlign.center,
                      onChanged: (val) {
                        setState(() {
                          otpCode = val;
                        });
                      },
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500

                          // decorationColor: Colors.white,
                          ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 0),

                        //Label Text/////////////////////////////////////////////////////////
                        hintText: '_  _  _  _  _  _',
                        hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 30.0,
                            fontWeight: FontWeight.w300

                            // decorationColor: Colors.white,
                            ),
                        // labelText: Texts.PHONE_NUMBER_LOGIN,
                        focusColor: Colors.orange[900],

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
                            borderSide: BorderSide(color: Colors.orange[400])),

                        ////////////////////////////////////////
                        ///
                        ///
                        errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.red[400])),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.red[400])),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: !otpVisible,
                    child: Text(
                      'Please confirm your country code and enter your phone number.',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15.0,
                          color: Colors.grey[500]),
                    ),
                  ),
                  Visibility(
                    visible: otpVisible,
                    child: Text(
                      'Please enter the activation code we have sent via SMS to:  ' +
                          wholePhoneNumber,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15.0,
                          color: Colors.grey[500]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Visibility(
                          visible: otpVisible,
                          child: _start >= 10
                              ? Text(
                                  "$_start",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17.0,
                                      color: Colors.grey[500]),
                                )
                              : Text(
                                  "$_start",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17.0,
                                      color: Colors.grey[500]),
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 48),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  resendVisible = false;
                  otpVisible = false;
                });
              },
              child: Center(
                child: Visibility(
                  visible: resendVisible,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: Colors.orange[500],
                      ),
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Center(
                      child: Text('Resend code',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w100)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                if (_formKey.currentState.validate()) {
                  if (otpVisible) {
                    VoidCallback codeInvalid =
                        () => {_showErrorDialog(context)};
                        VoidCallback cancelTimer =
                        () => {_timer.cancel()};
                    AuthServices(otpCode: otpCode)
                        .submitOTP(otpCode, wholePhoneNumber, codeInvalid,cancelTimer);
                    print('otp');
                    
                  }
                  if (!otpVisible) {
                    wholePhoneNumber = " ";
                    wholePhoneNumber = phoneCode + phoneNumber.trim();
                    _showPhoneDialog(context);
                  }
                }
              },
              child: Center(
                  child: OrangeButton(text: !otpVisible ? 'Submit' : 'Login')),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Text(loginState),
          )
        ],
      ),
    );
  }
  

}
