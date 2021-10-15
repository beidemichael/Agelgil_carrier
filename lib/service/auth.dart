
import 'package:agelgil_carrier_end/models/Models.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class AuthServices {
  String wholePhoneNumber;

  String otpCode;
  AuthServices({this.wholePhoneNumber, this.otpCode});

  User _firebaseUser;
  AuthCredential _phoneAuthCredential;

  int _code;

  static String _verificationId;

  Future<void> getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser;
  }

  UserAuth userFromFirebaseUser(User user) {
    return user != null ? UserAuth(uid: user.uid) : null;
  }

  Stream<UserAuth> get user {
    return FirebaseAuth.instance
        .authStateChanges()
        //.map((FirebaseUser user)=>_userFromFirebaseUser(user)) same as the code below
        .map(userFromFirebaseUser);
  }

  /// phoneAuthentication works this way:
  ///     AuthCredential is the only thing that is used to authenticate the user
  ///     OTP is only used to get AuthCrendential after which we need to authenticate with that AuthCredential
  ///
  /// 1. User gives the phoneNumber
  /// 2. Firebase sends OTP if no errors occur
  /// 3. If the phoneNumber is not in the device running the app
  ///       We have to first ask the OTP and get `AuthCredential`(`_phoneAuthCredential`)
  ///       Next we can use that `AuthCredential` to signIn
  ///    Else if user provided SIM phoneNumber is in the device running the app,
  ///       We can signIn without the OTP.
  ///       because the `verificationCompleted` callback gives the `AuthCredential`(`_phoneAuthCredential`) needed to signIn
  Future<void> login(
      wholePhoneNumber, Function codeInvalid, Function cancelTimer) async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((authRes) {
        _firebaseUser = authRes.user;

        print(_firebaseUser.toString());
      });
      final User user = await FirebaseAuth.instance.currentUser;
      final uid = user.uid;

      await DatabaseService(userPhoneNumber: wholePhoneNumber)
          .newUserData('', 'New member', uid.toString());
      cancelTimer();
    } catch (e) {
      // Navigator.pop(context);
      if (e.message.contains("invalid")) {}

      codeInvalid();
      print(e.toString());
    }
//      on PlatformException catch (e) {
//   if (e.message.contains("The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user.")) {
//     Navigator.pop(context);
//       _showErrorDialog(context);

//   } else if (e.message.contains('The sms code has expired')) {
//     // ...
//   }
// }
  }

  Future<void> logout() async {
    /// Method to Logout the `FirebaseUser` (`_firebaseUser`)
    try {
      // signout code
      await FirebaseAuth.instance.signOut();
      _firebaseUser = null;
    } catch (e) {
      print(e.toString());
    }
  }

  void submitOTP(
      otpCode, wholePhoneNumber, Function codeInvalid, Function cancelTimer) {
    /// get the `smsCode` from the user
    String smsCode = otpCode.trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    this._phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);

    login(wholePhoneNumber, codeInvalid, cancelTimer);
  }

  Future<void> submitPhoneNumber(Function toManyTimes) async {
    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) async {
      print('verificationCompleted');

      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
      try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((authRes) {
        _firebaseUser = authRes.user;

        print(_firebaseUser.toString());
      });
      final User user = await FirebaseAuth.instance.currentUser;
      final uid = user.uid;

      await DatabaseService(userPhoneNumber: wholePhoneNumber)
          .newUserData('', 'New member', uid.toString());
     
    } catch (e) {
      // Navigator.pop(context);
      if (e.message.contains("invalid")) {}

      print(e.toString());
    }
    }

    void verificationFailed(error) {
      print('verificationFailed');
      toManyTimes();
      print(error);
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// _showErrorDialog(context);
    }

    void codeSent(String verificationId, [int code]) {
      print('codeSent');
      _verificationId = verificationId;
      print(verificationId);
      this._code = code;
      print(code.toString());
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');

      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: wholePhoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(seconds: 62),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  } 
}
