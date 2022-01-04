import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/models/pdf_model.dart';
import 'package:paint_to_print/screens/pdf_images_screen.dart';

enum MODE {
  VIEW_MODE,
  EDIT_MODE,
}

class PdfImageItemScreen extends StatefulWidget {
  final PdfModel pdfModel;
  final List<Uint8List> canvasImages;
  final List<String> convertedTexts;
  // final Uint8List canvasImage;
  final String convertedText;
  final int index;

  const PdfImageItemScreen({
    Key key,
    @required this.pdfModel,
    @required this.canvasImages,
    @required this.convertedTexts,
    // @required this.canvasImage,
    @required this.convertedText,
    @required this.index,
  }) : super(key: key);

  @override
  _PdfImageItemScreenState createState() => _PdfImageItemScreenState();
}

class _PdfImageItemScreenState extends State<PdfImageItemScreen> {
  PdfModel pdfModel;
  MODE editViewMode;
  int index;
  List<Uint8List> canvasImages = [];
  List<String> convertedTexts = [];
  TextEditingController _convertedTextController;
  String convertedText;

  Future<void> _showPopAlertDialog() async {
    showDialog(
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
                  Navigator.of(context).pop();
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

  Future<void> _showEditModalBottomSheet() async {
    _convertedTextController = TextEditingController(text: convertedText);
    return showModalBottomSheet(
        context: context,
        elevation: 10.0,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        // isDismissible: false,
        builder: (context) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
              padding: EdgeInsets.all(15.0),
              // height: MediaQuery.of(context).size.height * 0.75,
              constraints: BoxConstraints(maxHeight: 300.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _convertedTextController,
                    maxLines: 10,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: GoogleFonts.arimo(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    onSaved: (value) {
                      _convertedTextController.text = value.trim();
                      print(_convertedTextController.text.trim());
                    },
                    keyboardType: TextInputType.multiline,
                  ),
                  Expanded(child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /// cancel button
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.arimo(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// save button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            convertedText = _convertedTextController.text;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Center(
                            child: Text(
                              'Save',
                              style: GoogleFonts.arimo(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pdfModel = widget.pdfModel;
    editViewMode = MODE.VIEW_MODE;
    index = widget.index;
    canvasImages = widget.canvasImages;
    convertedTexts = widget.convertedTexts;
    convertedText = widget.convertedText;
    print('init called');
  }

  @override
  Widget build(BuildContext context) {
    print(editViewMode);
    return WillPopScope(
      onWillPop: () {
        if (widget.convertedText != convertedText) _showPopAlertDialog();
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              if (widget.convertedText != convertedText)
                _showPopAlertDialog();
              else
                Navigator.of(context).pop();
            },
            icon: Icon(Icons.close, color: Theme.of(context).primaryColor),
          ),
          actions: [
            editViewMode == MODE.VIEW_MODE
                ?

                /// edit icon
                IconButton(
                    onPressed: () {
                      setState(() {
                        editViewMode = MODE.EDIT_MODE;
                      });
                    },
                    icon: Icon(
                      Icons.edit_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                :

                /// view icon / check
                widget.convertedText == convertedText
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            editViewMode = MODE.VIEW_MODE;
                          });
                        },
                        icon: Icon(
                          MaterialCommunityIcons.eye_circle,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          convertedTexts.removeAt(index);
                          convertedTexts.insert(index, convertedText);
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: PdfImagesScreen(
                                isNavigatedFromHomeScreen: false,
                                canvasImages: canvasImages,
                                pdfModel: pdfModel,
                                convertedTexts: convertedTexts,
                              ),
                              type: PageTransitionType.fade,
                            ),
                          ).then((value) {
                            setState(() {
                              convertedTexts;
                            });
                          });
                        },
                        icon: Icon(
                          MaterialCommunityIcons.check,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
            PopupMenuButton(
                elevation: 8.0,
                onSelected: (value) {
                  print(value);
                  if (value == 'Share') {
                  } else if (value == 'Docx') {}
                },
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                itemBuilder: (context) {
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
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            MaterialCommunityIcons.share,
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),

                    /// docx
                    PopupMenuItem(
                      value: 'Docx',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Docx',
                            style: GoogleFonts.arimo(
                              fontSize: 14.0,
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(MdiIcons.fileWord, color: Colors.indigoAccent),
                        ],
                      ),
                    ),
                  ];
                }),
          ],
        ),
        body: Column(
          children: [
            /// canvas image
            Flexible(
              flex: 7,
              child: Container(
                padding: EdgeInsets.all(3.0),
                height: MediaQuery.of(context).size.height * 0.60,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.memory(
                      canvasImages[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            /// arrow icon
            Container(
              // height: MediaQuery.of(context).size.width * 0.05,
              child: Icon(Icons.arrow_downward),
            ),

            /// converted text
            Flexible(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  editViewMode == MODE.VIEW_MODE
                      ?
                      // viewmode --> show toast, press 1 sec to copy
                      Fluttertoast.showToast(
                          msg: 'Hold long to copy',
                          backgroundColor: Colors.lightBlueAccent.shade100,
                          textColor: Colors.black,
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_SHORT,
                        )
                      :
                      // editmode --> show modal sheet to edit
                      _showEditModalBottomSheet();
                },
                onLongPress: () {
                  editViewMode == MODE.VIEW_MODE
                      ?
                      // viewmode --> copy
                      Clipboard.setData(
                          ClipboardData(text: convertedTexts[index]),
                        ).then((value) {
                          Fluttertoast.showToast(
                            msg: 'Copied to clipboard',
                            backgroundColor: Colors.greenAccent,
                            textColor: Colors.black,
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_LONG,
                          );
                          print('Copied to clipboard');
                        })
                      :
                      // editmode --> show toast, you are editing
                      Fluttertoast.showToast(
                          msg: 'You are editing',
                          backgroundColor: Colors.lightBlueAccent.shade100,
                          textColor: Colors.black,
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_SHORT,
                        );
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      convertedText,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.arimo(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
