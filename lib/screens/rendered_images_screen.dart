import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as imglib;
import 'package:internet_file/internet_file.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:paint_to_print/widgets/loading_cube_grid.dart';
import 'package:paint_to_print/widgets/pdf_image_loader.dart';
import 'package:pdf_render/pdf_render.dart' as pdfrender;

class RenderedImagesScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object> pdfSnapshot;
  const RenderedImagesScreen({Key key, this.pdfSnapshot}) : super(key: key);

  @override
  _RenderedImagesScreenState createState() => _RenderedImagesScreenState();
}

class _RenderedImagesScreenState extends State<RenderedImagesScreen> {
  QueryDocumentSnapshot<Object> pdfSnapshot;
  var doc;
  int pageCount = 0;
  List<imglib.Image> images = [];
  final storage = Map<int, PdfPageImage>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pdfSnapshot = widget.pdfSnapshot;
    // initPdf();
  }

  Future<PdfDocument> _getDocument() async {
    print(pdfSnapshot.get('file_url'));
    if (await hasPdfSupport()) {
      // return PdfDocument.openAsset('assets/cs_gate_syllabus_2022.pdf');
      final Uint8List bytes = await InternetFile.get(
        pdfSnapshot.get('file_url'),
        process: (percentage) {
          print('downloadPercentage: $percentage');
        },
      );
      doc = await pdfrender.PdfDocument.openData(bytes);
      pageCount = doc.pageCount;
      print(doc);
      print(pageCount);
      return PdfDocument.openData(bytes);
    }
    throw Exception(
      'PDF Rendering does not '
      'support on the system of this version',
    );
  }

  Future<void> initPdf() async {
    final Uint8List bytes = await InternetFile.get(
      'https://github.com/rbcprolabs/packages.flutter/raw/fd0c92ac83ee355255acb306251b1adfeb2f2fd6/packages/native_pdf_renderer/example/assets/sample.pdf',
      process: (percentage) {
        print('downloadPercentage: $percentage');
      },
    );
    doc = await pdfrender.PdfDocument.openData(bytes);
    pageCount = doc.pageCount;
    print(doc);
    print(pageCount);
    // // get images from all the pages
    // for (int i = 1; i <= pages; i++) {
    //   PdfPage page = await doc.getPage(i);
    //   PdfPageImage pageImage = await page.render();
    //   await pageImage.createImageIfNotAvailable();
    //   var img = await pageImage.createImageDetached();
    //   var imgBytes = await img.toByteData(format: ImageByteFormat.png);
    //   var libImage = imglib.decodeImage(imgBytes.buffer.asUint8List(
    //       // imgBytes.offsetInBytes, imgBytes.lengthInBytes
    //       ));
    //   images.add(libImage);
    //   print(images[0].getBytes());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          /*onTap: () {
            print('onTap');
            showRenameDialog(
              context: context,
              name: pdfModel.pdfName,
            );
          },*/
          child: AutoSizeText(
            pdfSnapshot.get('file_name'),
            overflow: TextOverflow.fade,
            maxFontSize: 17.0,
            style:
                GoogleFonts.arimo(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          PopupMenuButton(
              elevation: 8.0,
              onSelected: (value) {
                print(value);
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
                        Icon(MdiIcons.fileWord, color: Colors.indigoAccent),
                      ],
                    ),
                  ),
                ];
              }),
        ],
      ),
      body: FutureBuilder(
          future: _getDocument(),
          builder: (context, AsyncSnapshot<PdfDocument> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (!snapshot.hasData) {
              return Center(child: LoadingCubeGrid());
            }
            return ListView.builder(
                itemCount: pageCount,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                      future: _getDocument(),
                      builder: (context, AsyncSnapshot<PdfDocument> snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else if (!snapshot.hasData) {
                          return Center(child: LoadingCubeGrid());
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            /// image
                            Container(
                              padding: EdgeInsets.all(2.0),
                              height: 200.0,
                              width: MediaQuery.of(context).size.width * 0.40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: PdfImageLoader(
                                  storage: storage,
                                  document: snapshot.data,
                                  pageNumber: index + 1,
                                ),
                              ),
                            ),

                            /// arrow icon
                            Container(
                                width: MediaQuery.of(context).size.width * 0.05,
                                child: Icon(Icons.arrow_forward)),

                            /// converted text
                            Container(
                                padding: EdgeInsets.all(2.0),
                                height: 200.0,
                                width: MediaQuery.of(context).size.width * 0.40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
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
                                  child: PdfImageLoader(
                                    storage: storage,
                                    document: snapshot.data,
                                    pageNumber: index + 1,
                                  ),
                                )),
                          ],
                        );
                      });
                });
          }),
    );
  }
}
