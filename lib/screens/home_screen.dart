import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paint_to_print/models/prediction_model.dart';
import 'package:paint_to_print/models/user_model.dart';
import 'package:paint_to_print/screens/canvas/canvas_view_screen.dart';
import 'package:paint_to_print/services/recognizer.dart';
import 'package:paint_to_print/widgets/create_home_icon.dart';
import 'package:paint_to_print/widgets/user_details.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shimmer/shimmer.dart';

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
  String _pickedImage = '';
  List<Uint8List> points = [];
  List<Uint8List> _images = [];
  List<PredictionModel> predictions = [];
  bool isLoading = false;

  Future<void> _recognize() async {
    print('_recognize called');
    // print('points: ${points.first.point}');
    List<dynamic> _predictions =
        await Recognizer().recognizeImage(context, points);
    predictions =
        _predictions.map((json) => PredictionModel.fromJson(json)).toList();
    print(_predictions.first);
  }

  Widget Shimmers({double height, double width}) {
    return Container(
      height: height * 0.38 - width * 0.05,
      width: width * 0.94,
      child: Shimmer.fromColors(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(height * 0.05),
          ),
        ),
        baseColor: Colors.white38,
        highlightColor: Colors.grey,
      ),
    );
  }

  /*Future<void> _pickImageCamera() async {
    String imagePath;
    print('_pickImageCamera');
    try {
      imagePath = (await EdgeDetection.detectEdge);
      imagePath == null ? null : File(imagePath);
      _images.add(File(imagePath));
      print(imagePath);
      setState(() {
        _pickedImage = imagePath;
      });
    } on PlatformException {
      imagePath = 'Failed to get cropped image path.';
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _pickedImage = imagePath;
    });
  }*/

  Future<void> _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 99,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);
    Uint8List imageUint8List = await pickedImageFile.readAsBytes();
    points.add(imageUint8List);
    print(imageUint8List);
    _images.add(imageUint8List);
    if (_images.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      /*await _recognize().then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          PageTransition(
            child: PDFImagesScreen(
              canvasImages: _images,
              convertedTexts: ['1'],
              isNavigatedFromHomeScreen: true,
            ),
            type: PageTransitionType.rippleRightUp,
          ),
        );
      });*/
    }
    setState(() {
      // _pickedImage = pickedImageFile;
    });
  }

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
                return Stack(
                  children: [
                    Container(),

                    /// shimmers
                    Positioned(
                      top: height * 0.02,
                      left: width * 0.03,
                      right: width * 0.03,
                      child: Shimmers(width: width, height: height),
                    ),
                  ],
                );
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
                      onTap: _pickImageGallery,
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
