import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paint_to_print/widgets/create_home_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            kToolbarHeight,
        child: ListView(
          children: [
            /// row 1
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(15.0),
                height: MediaQuery.of(context).size.height / 3.5,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CreateHomeIcon(
                      iconName: 'Smart Scan',
                      iconData: Icons.camera_alt,
                      shadowColor: Colors.orangeAccent,
                      onTap: () {
                        print('Smart Scan');
                        Fluttertoast.showToast(msg: 'Smart Scan');
                      },
                    ),
                    CreateHomeIcon(
                      iconName: 'Import Picture',
                      iconData: EvaIcons.image2,
                      shadowColor: Colors.greenAccent,
                      onTap: () {
                        print('Import Picture');
                        Fluttertoast.showToast(msg: 'Import Picture');
                      },
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 10.0),

            /// row 2
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(15.0),
                height: MediaQuery.of(context).size.height / 3.5,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CreateHomeIcon(
                      iconName: 'Import File',
                      iconData: MaterialCommunityIcons.file_upload,
                      shadowColor: Colors.purpleAccent.shade200,
                      onTap: () {
                        print('Import File');
                        Fluttertoast.showToast(msg: 'Import File');
                      },
                    ),
                    CreateHomeIcon(
                      iconName: 'Scan ID Card',
                      iconData: MdiIcons.idCard,
                      shadowColor: Colors.yellowAccent.shade100,
                      onTap: () {
                        print('Scan ID Card');
                        Fluttertoast.showToast(msg: 'Scan ID Card');
                      },
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 10.0),

            /// row 3
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(15.0),
                height: MediaQuery.of(context).size.height / 3.5,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CreateHomeIcon(
                      iconName: 'Handwriting to Text',
                      iconData: MdiIcons.textRecognition,
                      shadowColor: Colors.teal.shade600,
                      onTap: () {
                        print('Handwriting to Text');
                        Fluttertoast.showToast(msg: 'Handwriting to Text');
                      },
                    ),
                    CreateHomeIcon(
                      iconName: 'Import Picture',
                      iconData: EvaIcons.image2,
                      shadowColor: Colors.lightBlueAccent,
                      onTap: () {
                        print('Import Picture');
                        Fluttertoast.showToast(msg: 'Import Picture');
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: kBottomNavigationBarHeight / 1.5),
          ],
        ),
      ),
    );
  }
}
