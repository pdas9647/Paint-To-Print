import 'package:flutter/material.dart';

class AllDocsScreen extends StatefulWidget {
  const AllDocsScreen({Key key}) : super(key: key);

  @override
  _AllDocsScreenState createState() => _AllDocsScreenState();
}

class _AllDocsScreenState extends State<AllDocsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('All Docs'),
      ),
    );
  }
}
