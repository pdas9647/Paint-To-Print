import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/screens/canvas/canvas_view_screen.dart';
import 'package:paint_to_print/widgets/create_home_icon.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  ProgressDialog progressDialog;

  Future<void> getPdfAndUpload({BuildContext context}) async {
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    FilePickerResult filePickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    File file = File(filePickerResult.files.single.path);
    String fileName = filePickerResult.files.first.name + '_$dateParse';
    print('file: $fileName');
    uploadFile(context: context, file: file, fileName: fileName)
        .then((value) async {
      print('Uploaded in firestore');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        'Uploaded',
        style: GoogleFonts.arimo(fontWeight: FontWeight.w600),
      )));
    });
  }

  Future<void> uploadFile(
      {BuildContext context, File file, String fileName}) async {
    String uploadedFileUrl;
    if (file == null) return null;
    Reference storageReference =
        FirebaseStorage.instance.ref().child('importedfiles').child(fileName);
    print('Uploading in storage...!');
    await progressDialog.show();
    await storageReference.putFile(file).then((p0) async {
      print('Uploaded in storage...!');
      uploadedFileUrl = await storageReference.getDownloadURL();
      print('file url: $uploadedFileUrl');
      print('Uploading in firestore...!');
      await progressDialog.hide();
      saveToFirestore(
        context: context,
        uploadedFileUrl: uploadedFileUrl,
        fileName: fileName,
      );
    });
  }

  Future<void> saveToFirestore(
      {BuildContext context, String uploadedFileUrl, String fileName}) async {
    // Kaagaz_20211122_002734779755.pdf_2022-01-03 10:59:37.426428
    var dateParse = fileName.split('.pdf_')[1]; // 2022-01-03 10:59:37.426428
    print(dateParse);
    var fileCreationYear = dateParse.substring(0, 4);
    var fileCreationMonth = DateFormat('MMM').format(DateTime.parse(dateParse));
    var fileCreationDate = dateParse.substring(8, 10);
    var fileCreationTime = dateParse.substring(11, 16);
    var fileCreationDateTime =
        '$fileCreationDate $fileCreationMonth, $fileCreationYear $fileCreationTime';
    print('fileCreationYear: $fileCreationYear');
    print('fileCreationMonth: $fileCreationMonth');
    print('fileCreationDate: $fileCreationDate');
    print('fileCreationTime: $fileCreationTime');
    await _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid)
        .collection('importedfiles')
        .doc(fileName) // Kaagaz_20211122_002734779755.pdf
        .set({
      'file_url': uploadedFileUrl,
      'file_name': fileName,
      'file_name_trimmed': fileName.substring(0, fileName.length - 27),
      'file_creation_datetime': fileCreationDateTime,
      'timestamp': fileName.split('.pdf_')[1],
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        // - MediaQuery.of(context).size.height * 0.10
        MediaQuery.of(context).size.height * 0.08;
    double width = MediaQuery.of(context).size.width;
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      customBody: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Image.asset(
              'assets/images/double_ring_loading_io.gif',
              height: 50.0,
              width: 50.0,
            ),
            SizedBox(width: 10.0),
            Flexible(
              child: AutoSizeText(
                'Uploading...',
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: GoogleFonts.arimo(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return Center(
      child: Container(
        height: height,
        width: width,
        // color: Colors.redAccent,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.001,
          vertical: MediaQuery.of(context).size.height * 0.015,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: height * 0.39,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: CreateHomeIcon(
                      image: 'assets/images/scan.png',
                      iconName: 'Scan',
                      shadowColor: Colors.orangeAccent,
                      onTap: () {
                        print('Scan');
                        Fluttertoast.showToast(msg: 'Scan');
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: CreateHomeIcon(
                      image: 'assets/images/import_picture.png',
                      iconName: 'Import Picture',
                      shadowColor: Colors.orangeAccent,
                      onTap: () {
                        print('Import Picture');
                        Fluttertoast.showToast(msg: 'Import Picture');
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.01),
            Container(
              height: height * 0.39,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /*Flexible(
                    flex: 1,
                    child: CreateHomeIcon(
                      image: 'assets/images/import_file.png',
                      iconName: 'Import File',
                      shadowColor: Colors.purpleAccent.shade200,
                      onTap: () {
                        print('Import File');
                        Fluttertoast.showToast(msg: 'Import File');
                        getPdfAndUpload(context: context);
                      },
                    ),
                  ),*/
                  Flexible(
                    flex: 1,
                    child: CreateHomeIcon(
                      image: 'assets/images/handwriting_to_text.png',
                      iconName: 'Handwriting to Text',
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
                  ),
                  Flexible(
                    flex: 1,
                    child: CreateHomeIcon(
                      image: 'assets/images/scan_id_card.png',
                      iconName: 'Scan ID Card',
                      shadowColor: Colors.yellowAccent.shade100,
                      onTap: () {
                        print('Scan ID Card');
                        Fluttertoast.showToast(msg: 'Scan ID Card');
                      },
                    ),
                  ),
                ],
              ),
            ),
            /*SizedBox(height: height * 0.01),
            Container(
              height: height * 0.26,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: CreateHomeIcon(
                      image: 'assets/images/handwriting_to_text.png',
                      iconName: 'Handwriting to Text',
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
                  ),
                  Flexible(
                    flex: 1,
                    child: CreateHomeIcon(
                      image: 'assets/images/merge_pdf.png',
                      iconName: 'Merge Pdf',
                      shadowColor: Colors.lightBlueAccent,
                      onTap: () {
                        print('Merge Pdf');
                        Fluttertoast.showToast(msg: 'Merge Pdf');
                      },
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
