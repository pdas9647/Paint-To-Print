import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/screens/bottom_bar_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:progress_dialog/progress_dialog.dart';

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
                      type: PageTransitionType.fade,
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

  static PopupMenuButton<String> morePdfItemsPopupMenu() {
    return PopupMenuButton(
      elevation: 8.0,
      onSelected: (value) {
        print(value);
      },
      itemBuilder: (BuildContext context) {
        return [
          /// view
          PopupMenuItem(
            value: 'View',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'View',
                  style: GoogleFonts.arimo(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  MaterialCommunityIcons.eye_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),

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

  static Future<void> createAndSavePdfFile({
    BuildContext context,
    List<Uint8List> images,
    List<String> convertedTexts,
    String pdfName,
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
    try {
      final dir = await getExternalStorageDirectory();
      final pdfFile = File('${dir.path}/$pdfName.pdf');
      await pdfFile.writeAsBytes(await pdf.save());
      // pdf saved snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.greenAccent.shade100,
          content: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: AutoSizeText(
              'Pdf Saved at ${dir.path}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.arimo(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
      print(pdfName);
      var dateParse = pdfName.split('.pdf_')[1]; // 2022-01-03 10:59:37.426428
      print(dateParse);
      var pdfCreationYear = dateParse.substring(0, 4);
      var pdfCreationMonth =
          DateFormat('MMM').format(DateTime.parse(dateParse));
      var pdfCreationDate = dateParse.substring(8, 10);
      var pdfCreationTime = dateParse.substring(11, 16);
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
          .child('$pdfName.pdf');
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
            .doc(pdfName)
            .set({
          'file_url': pdfUrl,
          'file_name': pdfName,
          'file_name_trimmed': pdfName.substring(0, pdfName.length - 27),
          'file_creation_datetime': pdfCreationDateTime,
          'timestamp': pdfName.split('.pdf_')[1],
          'file_location': 'local storage path',
        }).then((value) async {
          print('Uploaded in firestore...!');
          await progressDialog.hide();
          // uploaded in firestore
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.pinkAccent.shade100,
              content: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Text(
                  'PDF uploaded successfully!',
                  style: GoogleFonts.arimo(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        });
      });
      // Navigator.of(context).canPop() ? Navigator.of(context).pop() : null;
      Navigator.pushReplacement(
        context,
        PageTransition(type: PageTransitionType.fade, child: BottomBarScreen()),
      );
      print('saved in ${dir.path}/$pdfName.pdf');
    } catch (e) {
      print(e.toString());
    }
  }
}
