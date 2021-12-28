import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/models/pdf_model.dart';
import 'package:paint_to_print/screens/canvas/canvas_view_screen.dart';
import 'package:paint_to_print/screens/pdf_image_item_screen.dart';

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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Uint8List> canvasImages = [];
  List<String> convertedTexts = [];
  String pdfCreationDate;
  Timestamp timestamp;
  PdfModel pdfModel;
  bool back = false;

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
        pdfName: pdfCreationDate,
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
      convertedTexts = ['0', '1', '2', '3'];
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
              return true;
            },
            child: Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: AutoSizeText(
                  pdfModel.pdfCreationDate,
                  overflow: TextOverflow.fade,
                  maxFontSize: 17.0,
                  style: GoogleFonts.arimo(
                      fontSize: 17.0, fontWeight: FontWeight.bold),
                ),
              ),
              body: AnimationLimiter(
                child: ListView.builder(
                  itemCount: canvasImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final canvasImage = canvasImages[index];
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
                      // confirmDismiss: (direction) {
                      //   print(direction);
                      //   setState(() {
                      //     Uint8List deletedImage = canvasImages.removeAt(index);
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         elevation: 8.0,
                      //         backgroundColor:
                      //             Theme.of(context).colorScheme.error,
                      //         content: Text(
                      //           'Deleted',
                      //           style: GoogleFonts.arimo(
                      //             fontSize: 15.0,
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         ),
                      //         action: SnackBarAction(
                      //           label: 'Undo',
                      //           textColor:
                      //               Theme.of(context).colorScheme.secondary,
                      //           onPressed: () => setState(
                      //             () =>
                      //                 canvasImages.insert(index, deletedImage),
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   });
                      // },
                      onDismissed: (direction) {
                        print(direction);
                        Uint8List deletedImage;
                        setState(() {
                          deletedImage = canvasImages.removeAt(index);
                        });

                        /// undo action
                        // setState(
                        //       () => canvasImages.insert(index, deletedImage),
                        // );
                        /*final SnackBar snackBar = SnackBar(
                          elevation: 8.0,
                          backgroundColor: Theme.of(context).colorScheme.error,
                          content: Text(
                            'Deleted',
                            style: GoogleFonts.arimo(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          duration: Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'Undo',
                            textColor: Theme.of(context).colorScheme.secondary,
                            onPressed: () => setState(
                              () => canvasImages.insert(index, deletedImage),
                            ),
                          ),
                        );

                        print(index);
                        showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            elevation: 8.0,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Delete',
                                        style: GoogleFonts.arimo(
                                          fontSize: 20.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        'Do you want to delete?',
                                        style: GoogleFonts.arimo(
                                          fontSize: 15.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          /// cancel
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            elevation: 8.0,
                                            color: Colors.white,
                                            child: Text(
                                              'Cancel',
                                              style: GoogleFonts.arimo(
                                                fontSize: 15.0,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),

                                          /// Delete
                                          MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                deletedImage = canvasImages
                                                    .removeAt(index);
                                              });
                                            },
                                            elevation: 8.0,
                                            color: Colors.white,
                                            child: Text(
                                              'Delete',
                                              style: GoogleFonts.arimo(
                                                fontSize: 15.0,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });*/
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
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        child: Image.memory(
                                          widget.canvasImages[index],
                                          fit: BoxFit.cover,
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
