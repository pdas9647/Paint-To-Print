import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/models/pdf_model.dart';
import 'package:paint_to_print/screens/canvas/canvas_view_screen.dart';
import 'package:paint_to_print/screens/pdf_image_item_screen.dart';
import 'package:paint_to_print/services/global_methods.dart';

import 'bottom_bar_screen.dart';

class PdfImagesScreen extends StatefulWidget {
  final bool isNavigatedFromHomeScreen;
  final List<Uint8List> canvasImages;
  final List<String> convertedTexts;
  final PdfModel pdfModel;

  const PdfImagesScreen({
    Key key,
    @required this.isNavigatedFromHomeScreen,
    @required this.canvasImages,
    this.convertedTexts,
    this.pdfModel,
  }) : super(key: key);

  @override
  _PdfImagesScreenState createState() => _PdfImagesScreenState();
}

class _PdfImagesScreenState extends State<PdfImagesScreen> {
  List<Uint8List> canvasImages = [];
  List<String> convertedTexts = [];
  String pdfCreationDate;
  Timestamp timestamp;
  PdfModel pdfModel;
  bool back = false;

  Future<void> showRenameDialog({BuildContext context, String name}) async {
    TextEditingController _nameController = TextEditingController(text: name);
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: TextFormField(
              controller: _nameController,
              style: GoogleFonts.arimo(fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                  // labelStyle: GoogleFonts.arimo(fontWeight: FontWeight.w600),
                  // hintStyle: GoogleFonts.arimo(fontWeight: FontWeight.w600),
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // name = _nameController.text;
                  print(_nameController.text);
                  setState(() {
                    pdfModel.pdfName = _nameController.text;
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    canvasImages = widget.canvasImages;
    if (widget.isNavigatedFromHomeScreen) {
      pdfCreationDate = DateTime.now().toString();
      timestamp = Timestamp.now();
    }

    /// for the first time... canvasImages[0]
    if (widget.pdfModel == null) {
      pdfModel = PdfModel(
        // pdfName: pdfCreationDate,
        pdfName: pdfCreationDate + '.pdf_' + pdfCreationDate,
        canvasImages: canvasImages,
        pdfCreationDate: pdfCreationDate,
        timestamp: timestamp,
      );
    }

    /// for next times... canvasImages[>0]
    else {
      pdfModel = widget.pdfModel;
    }
    if (widget.convertedTexts == null) {
      convertedTexts = ['Padmanabha Das', 'Swagato Bag', '2', '3'];
    } else {
      convertedTexts = widget.convertedTexts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return canvasImages.isEmpty
        ? BottomBarScreen()
        : WillPopScope(
            onWillPop: () async {
              print('back pressed');
              GlobalMethods.buildDiscardWarningDialog(context);
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                title: GestureDetector(
                  onTap: () {
                    print('onTap');
                    showRenameDialog(
                      context: context,
                      name: pdfModel.pdfName,
                    );
                  },
                  child: AutoSizeText(
                    // pdfModel.pdfName == null
                    //     ? pdfModel.pdfCreationDate +
                    //         '.pdf_' +
                    //         pdfCreationDate // navigating from canvas screen first time, for canvasImages[0]
                    //     :
                    pdfModel.pdfName,
                    overflow: TextOverflow.fade,
                    maxFontSize: 17.0,
                    style: GoogleFonts.arimo(
                        fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                ),
                elevation: 0.0,
                leading: IconButton(
                  onPressed: () {
                    GlobalMethods.buildDiscardWarningDialog(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
                actions: [
                  PopupMenuButton(
                      elevation: 8.0,
                      onSelected: (selectedItem) async {
                        print(selectedItem);
                        switch (selectedItem) {
                          case 'Docx':
                            // await GlobalMethods.createAndSavePdfFile(
                            //   context: context,
                            //   images: canvasImages,
                            //   convertedTexts: convertedTexts,
                            //   pdfName: pdfModel.pdfName,
                            // );
                            await GlobalMethods.createAndSaveTextFile(
                              context: context,
                              convertedTexts: convertedTexts,
                              fileName: pdfModel.pdfName,
                            );
                          // await GlobalMethods.createFolderInAppDocDir(context: context,folderName: 'Paint to Print');
                            break;
                          default:
                            return;
                        }
                      },
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
                                Icon(
                                  MdiIcons.fileWord,
                                  color: Colors.indigoAccent,
                                ),
                              ],
                            ),
                          ),
                        ];
                      }),
                ],
              ),
              body: AnimationLimiter(
                child: ListView.builder(
                  itemCount: canvasImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: Key('${canvasImages[index]}'),
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Theme.of(context).colorScheme.error,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                            size: 50.0,
                          ),
                        ),
                      ),
                      direction: DismissDirection.endToStart, // right to left
                      onDismissed: (direction) {
                        print(direction);
                        Uint8List deletedImage;
                        String deletedConvertedText;
                        setState(() {
                          deletedImage = canvasImages.removeAt(index);
                          deletedConvertedText = convertedTexts.removeAt(index);
                        });

                        /// undo action
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Deleted', style: GoogleFonts.arimo()),
                            duration: Duration(seconds: 3),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                setState(
                                  () {
                                    canvasImages.insert(index, deletedImage);
                                    convertedTexts.insert(
                                        index, deletedConvertedText);
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: AnimationConfiguration.staggeredList(
                        position: index,
                        delay: Duration(milliseconds: 400),
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          curve: Curves.easeOutCirc,
                          child: FadeInAnimation(
                            child:
                                // index % 2 != 0 ? SizedBox(height: 10.0) :
                                Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: PdfImageItemScreen(
                                        pdfModel: pdfModel,
                                        canvasImages: canvasImages,
                                        convertedTexts: convertedTexts,
                                        // canvasImage: canvasImages[index],
                                        convertedText: convertedTexts[index],
                                        index: index,
                                      ),
                                      type: PageTransitionType.fade,
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    /// canvas image
                                    Container(
                                      padding: EdgeInsets.all(2.0),
                                      height: 200.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0))),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          child: Image.memory(
                                            canvasImages[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// arrow icon
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        child: Icon(Icons.arrow_forward)),

                                    /// converted text
                                    Container(
                                      padding: EdgeInsets.all(2.0),
                                      height: 200.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.5),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0))),
                                        child: Text(
                                          convertedTexts[index],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  print(convertedTexts);
                  Navigator.push(
                    context,
                    PageTransition(
                      child: CanvasViewScreen(
                        isNavigatedFromHomeScreen: false,
                        isNavigatedFromPdfImagesScreen: true,
                        canvasImages: canvasImages,
                        convertedTexts: convertedTexts,
                        pdfModel: pdfModel,
                      ),
                      type: PageTransitionType.fade,
                    ),
                  );
                },
                elevation: 8.0,
                backgroundColor: Color(0xFFDB2B39),
                child: Icon(MaterialCommunityIcons.draw, color: Colors.white),
              ),
            ),
          );
  }
}
