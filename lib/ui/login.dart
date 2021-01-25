import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phoneNumber, verificationId;
  String otp, authStatus = "";

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
        });
      },
      verificationFailed: (AuthException authException) {
        setState(() {
          authStatus = "Authentication failed";
        });
      },
      codeSent: (String verId, [int forceCodeResent]) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP has been successfully send";
        });
        otpDialogBox(context).then((value) {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
        });
      },
    );
  }

  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  otp = value;
                },
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  signIn(otp);
                },
                child: Text(
                  'Submit',
                ),
              ),
            ],
          );
        });
  }

  Future<void> signIn(String otp) async {
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: otp,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Text(
              "Login",

              style: TextStyle(
                color: Colors.green,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30),
                      ),
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.phone_iphone,
                      color: Colors.green
                    ),
                    labelText: "Enter Your Phone Number...",
                    //hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "eg: +91 1234567892",
                    fillColor: Colors.white70
                ),
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width:  MediaQuery.of(context).size.width * 0.5,
              height:  MediaQuery.of(context).size.height * 0.06,
              child: RaisedButton(

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () =>
                phoneNumber == null ? null : verifyPhoneNumber(context),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white,
                  fontSize: 20,
                  ),
                ),
                elevation: 7.0,
                color: Colors.green,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //Text("Need Help?"),
            SizedBox(
              height: 20,
            ),
            // Text(
            //   "Please enter the phone number followed by country code",
            //   style: TextStyle(color: Colors.green),
            // ),
            SizedBox(
              height: 20,
            ),
            Text(
              authStatus == "" ? "" : authStatus,
              style: TextStyle(
                  color: authStatus.contains("fail") ||
                      authStatus.contains("TIMEOUT")
                      ? Colors.red
                      : Colors.green),
            )
          ],
        ),
      ),
    );
  }
}
