import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllDocsScreen extends StatefulWidget {
  const AllDocsScreen({Key key}) : super(key: key);

  @override
  _AllDocsScreenState createState() => _AllDocsScreenState();
}

class _AllDocsScreenState extends State<AllDocsScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('All Docs'),
    );
  }
}
