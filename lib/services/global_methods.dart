import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paint_to_print/models/pdf_model.dart';
import 'package:paint_to_print/models/text_model.dart';
import 'package:paint_to_print/screens/bottom_bar_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalMethods {
  static Future<void> customDialog(BuildContext context, String title,
      String subtitle, Function func) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.asset(
                  'assets/images/warning.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: GoogleFonts.arimo(
                    color: Colors.redAccent,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: GoogleFonts.arimo(
              fontSize: 14.0,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.arimo(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                func();
              },
              child: Text(
                'Delete',
                style: GoogleFonts.arimo(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> authErrorDialog(
      BuildContext context, String title, String subtitle) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.asset(
                  'assets/images/warning.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: GoogleFonts.arimo(
                    color: Colors.redAccent,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: GoogleFonts.arimo(
              fontSize: 14.0,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Okay',
                style: GoogleFonts.arimo(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> signOutDialog(
      BuildContext context, String title, String subtitle) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Image.network(
                  'https://image.flaticon.com/icons/png/128/1828/1828304.png',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: GoogleFonts.arimo(
                    fontSize: 18.0,
                    letterSpacing: 1.1,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            style: GoogleFonts.arimo(
              fontSize: 14.0,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text(
                'No',
                style: GoogleFonts.arimo(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                await FirebaseAuth.instance.signOut();
              },
              child: Text(
                'Yes',
                style: GoogleFonts.arimo(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<dynamic> buildDiscardWarningDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Text(
              'Do you want to discard?',
              style: GoogleFonts.arimo(
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            elevation: 8.0,
            actions: [
              /// yes button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: BottomBarScreen(),
                      type: PageTransitionType.rippleLeftDown,
                    ),
                  );
                },
                child: Text(
                  'Yes',
                  style: GoogleFonts.arimo(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              /// no button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'No',
                  style: GoogleFonts.arimo(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          );
        });
  }

  static PopupMenuButton<String> morePdfItemsPopupMenu(
      {BuildContext context,
      PDFModel pdfModel,
      TextModel textModel,
      String collectionName,
      int index,
      fileList,
      AsyncSnapshot snapshot}) {
    return PopupMenuButton(
      elevation: 8.0,
      padding: EdgeInsets.all(0.0),
      iconSize: MediaQuery.of(context).size.width * 0.05,
      onSelected: (value) async {
        print(value);
        final firebaseFirestore = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection(collectionName);
        print(index);
        switch (value) {
          case 'Share':
            String saveFileName = pdfModel.pdfName;
            final directory = await getExternalStorageDirectory();
            String savePath = directory.path + '/$saveFileName';
            final pdfFile = File('${directory.path}/${saveFileName}');
            print(pdfFile.path);
            if (pdfFile.existsSync() == true) {
              print('pdf exists');
              Share.shareFiles([savePath], text: '${saveFileName}');
            } else {
              print('pdf doesn\'t exist');
              downloadPdf(
                      context: context, pdfModel: pdfModel, savePath: savePath)
                  .then((value) {
                Share.shareFiles([savePath], text: '${saveFileName}');
              });
            }
            break;

          case 'Delete':

            /// alert dialog
            customDialog(context, 'Warning!', 'Do you want to delete?', () {
              print('snapshot.data.docs[index]: ${snapshot.data.docs[index]}');

              /// delete file from firebase storage
              FirebaseStorage.instance.refFromURL(pdfModel.pdfUrl).delete();
              print('Deleted from storage');

              /// delete entry from firebasefirestore
              firebaseFirestore
                  .where('fileCreationDate',
                      isEqualTo: pdfModel.fileCreationDate)
                  .get()
                  .then((value) {
                value.docs.forEach((element) {
                  firebaseFirestore.doc(element.id).delete().then((value) {
                    print('Deleted from firestore');
                    Navigator.of(context).pop();
                    int documentsCount = 0;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .get()
                        .then((documentSnapshot) {
                      documentsCount = documentSnapshot.get('documentsCount');
                    }).then((value) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser.uid)
                          .update({
                        'documentsCount': documentsCount - 1,
                      });
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(18.0))),
                        content: Text(
                          'Deleted Successfully',
                          style: GoogleFonts.arimo(fontSize: 17.0),
                        ),
                      ),
                    );
                  });
                });
              });
            });
            break;

          case 'Download':
            Map<Permission, PermissionStatus> statuses = await [
              Permission.storage,
            ].request();
            if (statuses[Permission.storage].isGranted) {
              Directory downloadDirectory =
                  await DownloadsPathProvider.downloadsDirectory;
              if (downloadDirectory != null) {
                String savePath =
                    downloadDirectory.path + '/${pdfModel.pdfName}';
                downloadPdf(
                        context: context,
                        pdfModel: pdfModel,
                        savePath: savePath)
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(18.0))),
                      content: Text(
                        'Downloaded Successfully',
                        style: GoogleFonts.arimo(fontSize: 17.0),
                      ),
                    ),
                  );
                });
              }
            }
            break;

          case 'Rename':
            TextEditingController _nameController =
                TextEditingController(text: pdfModel.pdfName);
            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    content: TextFormField(
                      controller: _nameController,
                      style: GoogleFonts.arimo(fontWeight: FontWeight.w400),
                      // decoration: InputDecoration(
                      // labelStyle: GoogleFonts.arimo(fontWeight: FontWeight.w600),
                      // hintStyle: GoogleFonts.arimo(fontWeight: FontWeight.w600),
                      // ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (!_nameController.text.contains('.pdf')) {
                            _nameController.text += '.pdf';
                          }
                          firebaseFirestore
                              .where('fileCreationDate',
                                  isEqualTo: pdfModel.fileCreationDate)
                              .get()
                              .then((value) {
                            value.docs.forEach((element) {
                              firebaseFirestore
                                  .doc(element.id)
                                  .update({'pdfName': _nameController.text});
                            });
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Save',
                          style: GoogleFonts.arimo(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  );
                });
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          /// share
          PopupMenuItem(
            value: 'Share',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Share',
                  style: GoogleFonts.arimo(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  MaterialCommunityIcons.share,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),

          /// delete
          PopupMenuItem(
            value: 'Delete',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delete',
                  style: GoogleFonts.arimo(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  MaterialCommunityIcons.delete_circle,
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ),

          /// download
          PopupMenuItem(
            value: 'Download',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Download',
                  style: GoogleFonts.arimo(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  MaterialCommunityIcons.download,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),

          /// rename
          PopupMenuItem(
            value: 'Rename',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rename',
                  style: GoogleFonts.arimo(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.edit_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ];
      },
    );
  }

  static Future<void> downloadPdf(
      {BuildContext context, PDFModel pdfModel, String savePath}) async {
    String saveFileName = pdfModel.pdfName;
    // String savePath = downloadDirectory.path + '/$saveFileName';
    print(savePath);
    try {
      /*ProgressDialog progressDialog = ProgressDialog(context);*/
      await Dio().download(pdfModel.pdfUrl, savePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
          /*// progress dialog
                      progressDialog = ProgressDialog(
                        context,
                        type: ProgressDialogType.Download,
                        isDismissible: true,
                        customBody: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              print((received / total * 100).toStringAsFixed(0) + '%');
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/double_ring_loading_io.gif',
                                          height: 50.0,
                                          width: 50.0,
                                        ),
                                        SizedBox(width: 10.0),
                                        Flexible(
                                          child: AutoSizeText(
                                            'Downloading...',
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
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                          '${(received / total * 100).toStringAsFixed(0) + '%'}'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                      progressDialog.show();*/
        }
      });
      /*progressDialog.hide();*/
      print('$saveFileName is saved to ${savePath}');
    } on DioError catch (e) {
      // progressDialog.hide();
      print('Error in download: ${e.message}');
    }
  }

  static Future<void> createAndSavePdfFile({
    BuildContext context,
    List<Uint8List> images,
    List<String> convertedTexts,
    String pdfName,
    String fileCreationDate,
    // String timestamp,
  }) async {
    /// creating pdf
    var pdf = pdfWidget.Document();
    for (int i = 0; i < images.length; i++) {
      var img = images[i];
      final image = pdfWidget.MemoryImage(img);
      var convertedText = convertedTexts[i];
      pdf.addPage(
        pdfWidget.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pdfWidget.Context context) {
              return pdfWidget.Container(
                color: PdfColors.lightBlueAccent,
                width: 500.0,
                height: 800.0,
                child: pdfWidget.Column(
                  // mainAxisAlignment: pdfWidget.MainAxisAlignment.center,
                  crossAxisAlignment: pdfWidget.CrossAxisAlignment.start,
                  children: [
                    // pdfWidget.Image(image),
                    // pdfWidget.Text(convertedText),
                    pdfWidget.Container(
                      height: 480.0,
                      color: PdfColor.fromInt(0xFF4FBDBA),
                      child: pdfWidget.Image(image),
                    ),
                    pdfWidget.Container(
                      height: 180.0,
                      color: PdfColor.fromInt(0xFFFFF89A),
                      child: pdfWidget.Text(convertedText),
                    ),
                  ],
                ),
              );
            }),
      );
    }

    // progress dialog
    ProgressDialog progressDialog = ProgressDialog(
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

    /// save pdf in local storage and firebase...
    // local storage
    String pdfUrl = '';
    String pdfSize = '0B';
    try {
      final dir = await getExternalStorageDirectory();
      final pdfFile = File('${dir.path}/$pdfName.pdf');
      await pdfFile.writeAsBytes(await pdf.save());
      final bytes = pdfFile.readAsBytesSync().lengthInBytes;
      if (bytes <= 1024) {
        pdfSize = '$bytes B';
      } else if (bytes / (1024 * 1024) >= 1) {
        pdfSize = '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
      } else {
        pdfSize = '${(bytes / 1024).toStringAsFixed(2)} KB';
      }
      print(pdfName);
      var dateParse = fileCreationDate.substring(0, 19);
      print(dateParse);
      var pdfCreationYear = dateParse.substring(0, 4);
      var pdfCreationMonth =
          DateFormat('MMM').format(DateTime.parse(dateParse));
      var pdfCreationDate = dateParse.substring(8, 10);
      var pdfCreationTime = dateParse.substring(11, 19);
      var pdfCreationDateTime =
          '$pdfCreationDate $pdfCreationMonth, $pdfCreationYear $pdfCreationTime';
      print('pdfCreationYear: $pdfCreationYear');
      print('pdfCreationMonth: $pdfCreationMonth');
      print('pdfCreationDate: $pdfCreationDate');
      print('pdfCreationTime: $pdfCreationTime');
      // firestore & firebase storage
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('createdpdfs')
          .child('$pdfName.pdf $pdfCreationDateTime');
      print('Uploading in storage...!');
      await progressDialog.show();
      await storageReference.putFile(pdfFile).then((p0) async {
        pdfUrl = await storageReference.getDownloadURL();
        print('Uploaded in storage...!');
        print('Uploading in firestore...!');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection('createdpdfs')
            .doc('$pdfName.pdf $pdfCreationDateTime')
            .set(PDFModel(
              pdfName: pdfName + '.pdf',
              // canvasImages: ,
              fileCreationDate: pdfCreationDateTime,
              pdfSize: pdfSize,
              pdfUrl: pdfUrl,
              pdfPageCount: images.length,
              // timestamp: timestamp,
              pdfLocation: pdfFile.path,
            ).toMap())
            .then((value) async {
          print('Uploaded in firestore...!');
          await progressDialog.hide();
          // uploaded in firestore
          int documentsCount = 0;
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .get()
              .then((documentSnapshot) {
            documentsCount = documentSnapshot.get('documentsCount');
          }).then((value) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .update({
              'documentsCount': documentsCount + 1,
            });
          });
          Fluttertoast.showToast(msg: 'PDF uploaded successfully!');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     backgroundColor: Colors.pinkAccent.shade100,
          //     content: Container(
          //       decoration:
          //           BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          //       child: Text(
          //         'PDF uploaded successfully!',
          //         style: GoogleFonts.arimo(
          //           color: Colors.black,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ),
          //   ),
          // );
        });
      });
      // Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rippleRightUp,
          child: BottomBarScreen(),
        ),
      );
      BottomBarScreen.currentIndex = 2;
      print('saved in ${dir.path}/$pdfName.pdf');
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> launchURL({String url}) async {
    if (!await launch(url))
      SnackBar(
        backgroundColor: Colors.red.shade200,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.0))),
        content: Text(
          'Something went wrong',
          style: GoogleFonts.arimo(fontSize: 17.0, color: Colors.black),
        ),
      );
  }

  static Future<void> createAndSaveTextFile({
    BuildContext context,
    List<Uint8List> images,
    List<String> convertedTexts,
    String txtFileName,
    String fileCreationDate,
  }) async {
    // progress dialog
    ProgressDialog progressDialog = ProgressDialog(
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

    String txtFileUrl = '';
    String txtSize = '0B';
    try {
      final Directory directory = await getExternalStorageDirectory();
      final File txtFile = File('${directory.path}/$txtFileName.txt');
      await txtFile.writeAsString(convertedTexts.join(" "));
      final bytes = txtFile.readAsBytesSync().lengthInBytes;
      print('bytes: $bytes');
      if (bytes <= 1024) {
        txtSize = '$bytes B';
      } else if (bytes / (1024 * 1024) >= 1) {
        txtSize = '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
      } else {
        txtSize = '${(bytes / 1024).toStringAsFixed(2)} KB';
      }
      print(txtFileName);
      var dateParse = fileCreationDate.substring(0, 19);
      print(dateParse);
      var txtCreationYear = dateParse.substring(0, 4);
      var txtCreationMonth =
          DateFormat('MMM').format(DateTime.parse(dateParse));
      var txtCreationDate = dateParse.substring(8, 10);
      var txtCreationTime = dateParse.substring(11, 19);
      var txtCreationDateTime =
          '$txtCreationDate $txtCreationMonth, $txtCreationYear $txtCreationTime';
      print('txtCreationYear: $txtCreationYear');
      print('txtCreationMonth: $txtCreationMonth');
      print('txtCreationDate: $txtCreationDate');
      print('txtCreationTime: $txtCreationTime');
      // firestore & firebase storage
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('createdtxts')
          .child('$txtFileName.txt $txtCreationDateTime');
      print('Uploading in storage...!');
      await progressDialog.show();
      await storageReference.putFile(txtFile).then((p0) async {
        txtFileUrl = await storageReference.getDownloadURL();
        print('Uploaded in storage...!');
        print('Uploading in firestore...!');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection('createdtxts')
            .doc('$txtFileName.txt $txtCreationDateTime')
            .set(TextModel(
              textName: txtFileName + '.txt',
              // canvasImages: ,
              fileCreationDate: txtCreationDateTime,
              textSize: txtSize,
              textUrl: txtFileUrl,
              // timestamp: timestamp,
              txtLocation: txtFile.path,
            ).toMap())
            .then((value) async {
          print('Uploaded in firestore...!');
          await progressDialog.hide();
          // uploaded in firestore
          int documentsCount = 0;
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .get()
              .then((documentSnapshot) {
            documentsCount = documentSnapshot.get('documentsCount');
          }).then((value) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .update({
              'documentsCount': documentsCount + 1,
            });
          });
          Fluttertoast.showToast(msg: 'Text uploaded successfully!');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     backgroundColor: Colors.pinkAccent.shade100,
          //     content: Container(
          //       decoration:
          //           BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          //       child: Text(
          //         'Text uploaded successfully!',
          //         style: GoogleFonts.arimo(
          //           color: Colors.black,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ),
          //   ),
          // );
        });
      });

      // Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rippleRightUp,
          child: BottomBarScreen(),
        ),
      );
      BottomBarScreen.currentIndex = 2;
      print('saved in ${directory.path}/$txtFileName.txt');
    } catch (e) {
      print(e.toString());
    }
    // Navigator.pushReplacement(
    //   context,
    //   PageTransition(
    //     type: PageTransitionType.rippleRightUp,
    //     child: BottomBarScreen(),
    //   ),
    // );
  }
}
