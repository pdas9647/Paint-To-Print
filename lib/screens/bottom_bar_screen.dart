import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key key}) : super(key: key);

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Bar Screen'),
      ),
      body: Center(
        child: OutlineButton(
          onPressed: () {
            _firebaseAuth.signOut();
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
