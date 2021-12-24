import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/screens/canvas/canvas_view_screen.dart';
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
          // shrinkWrap: true,
          children: [
            /// row 1
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
              height: MediaQuery.of(context).size.height / 3.9,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CreateHomeIcon(
                    iconName: 'Scan',
                    image: 'assets/images/scan.png',
                    shadowColor: Colors.orangeAccent,
                    onTap: () {
                      print('Scan');
                      Fluttertoast.showToast(msg: 'Scan');
                    },
                  ),
                  CreateHomeIcon(
                    iconName: 'Import Picture',
                    image: 'assets/images/import_picture.png',
                    shadowColor: Colors.greenAccent,
                    onTap: () {
                      print('Import Picture');
                      Fluttertoast.showToast(msg: 'Import Picture');
                    },
                  ),
                ],
              ),
            ),
            // SizedBox(height: 10.0),

            /// row 2
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
              height: MediaQuery.of(context).size.height / 3.9,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CreateHomeIcon(
                    iconName: 'Import File',
                    image: 'assets/images/import_file.png',
                    shadowColor: Colors.purpleAccent.shade200,
                    onTap: () {
                      print('Import File');
                      Fluttertoast.showToast(msg: 'Import File');
                    },
                  ),
                  CreateHomeIcon(
                    iconName: 'Scan ID Card',
                    image: 'assets/images/scan_id_card.png',
                    shadowColor: Colors.yellowAccent.shade100,
                    onTap: () {
                      print('Scan ID Card');
                      Fluttertoast.showToast(msg: 'Scan ID Card');
                    },
                  ),
                ],
              ),
            ),
            // SizedBox(height: 10.0),

            /// row 3
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
              height: MediaQuery.of(context).size.height / 3.9,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CreateHomeIcon(
                    iconName: 'Handwriting to Text',
                    image: 'assets/images/handwriting_to_text.png',
                    shadowColor: Colors.teal.shade600,
                    onTap: () {
                      print('Handwriting to Text');
                      // persistentTabController =
                      //     PersistentTabController(initialIndex: 1);
                      Navigator.push(
                        context,
                        PageTransition(
                          child: CanvasViewScreen(
                            isNavigatedFromHomeScreen: true,
                            isNavigatedFromPdfImagesScreen: false,
                          ),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                  ),
                  CreateHomeIcon(
                    iconName: 'Merge Pdf',
                    image: 'assets/images/merge_pdf.png',
                    shadowColor: Colors.lightBlueAccent,
                    onTap: () {
                      print('Merge Pdf');
                      Fluttertoast.showToast(msg: 'Merge Pdf');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
