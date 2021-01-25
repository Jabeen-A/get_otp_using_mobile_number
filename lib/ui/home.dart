import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, snapshot) {
          FirebaseUser firebaseUser = snapshot.data;
          return snapshot.hasData
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text(
                //   "SignIn Success ",
                //   style: TextStyle(
                //     color: Colors.green,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 30,
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                //Text("UserId: ${firebaseUser.uid}"),
                SizedBox(
                  height: 20,
                ),
                Text(
                    " Phone Number: ${firebaseUser.phoneNumber}",
                style: TextStyle(
                  fontSize: 20
                ),),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: _logout,
                  child: Text(
                    "LogOut",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                )
              ],
            ),
          )
              : CircularProgressIndicator();
        },
      ),
    );
  }
}