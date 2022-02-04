import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paint_to_print/models/user_model.dart';
import 'package:paint_to_print/screens/canvas/canvas_view_screen.dart';
import 'package:paint_to_print/widgets/create_home_icon.dart';
import 'package:paint_to_print/widgets/loading_cube_grid.dart';
import 'package:paint_to_print/widgets/user_details.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomeScreen extends StatefulWidget {
  static int noOfCreatedPdfs = 0;
  static int noOfCreatedTexts = 0;
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  ProgressDialog progressDialog;
  UserModel userModel;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        // MediaQuery.of(context).size.height * 0.10 -
        MediaQuery.of(context).size.height * 0.08;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        // color: Colors.redAccent,
        boxShadow: [
          BoxShadow(
            offset: Offset(5, 10),
            color: Colors.red.shade50,
            blurRadius: 40.0,
            spreadRadius: 0.05,
            blurStyle: BlurStyle.normal,
          ),
        ],
      ),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firebaseFirestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingCubeGrid();
              }
              final userStream = snapshot.data.docs.map((user) {
                return UserModel.fromDocument(user);
              }).where((userItem) {
                return (userItem.id == _firebaseAuth.currentUser.uid);
              }).toList();
              userModel = userStream[0];
              return UserDetails(
                width: width,
                height: height,
                userModel: userModel,
              );
            },
          ),
          Container(
            height: height * 0.50,
            // color: Colors.lightBlueAccent,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CreateHomeIcon(
                      width: MediaQuery.of(context).size.width * 0.47,
                      height: height * 0.19,
                      iconName: 'Scan',
                      image: 'assets/images/scan.png',
                      imageSize: MediaQuery.of(context).size.width * 0.14,
                      shadowColor: Colors.orange.shade100,
                      onTap: () {
                        print('Scan');
                        Fluttertoast.showToast(msg: 'Scan');
                      },
                    ),
                    CreateHomeIcon(
                      width: MediaQuery.of(context).size.width * 0.47,
                      // height: height * 0.195,
                      height: height * 0.20,
                      iconName: 'Import Picture',
                      image: 'assets/images/import_picture.png',
                      imageSize: MediaQuery.of(context).size.width * 0.14,
                      shadowColor: Colors.orange.shade100,
                      onTap: () {
                        print('Import Picture');
                        Fluttertoast.showToast(msg: 'Import Picture');
                      },
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                CreateHomeIcon(
                  width: MediaQuery.of(context).size.width * 0.94,
                  // height: height * 0.195,
                  height: height * 0.20,
                  iconName: 'Handwriting to Text',
                  image: 'assets/images/handwriting_to_text.png',
                  imageSize: MediaQuery.of(context).size.height * 0.10,
                  shadowColor: Colors.teal.shade100,
                  onTap: () {
                    print('Handwriting to Text');
                    Navigator.push(
                      context,
                      PageTransition(
                        child: CanvasViewScreen(
                          isNavigatedFromHomeScreen: true,
                          isNavigatedFromPdfImagesScreen: false,
                        ),
                        type: PageTransitionType.rippleRightUp,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
