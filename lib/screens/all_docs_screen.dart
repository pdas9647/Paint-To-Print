import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paint_to_print/models/pdf_model.dart';
import 'package:paint_to_print/models/text_model.dart';
import 'package:paint_to_print/services/global_methods.dart';
import 'package:paint_to_print/widgets/loading_cube_grid.dart';
import 'package:shimmer/shimmer.dart';

import 'home_screen.dart';

class AllDocsScreen extends StatefulWidget {
  const AllDocsScreen({Key key}) : super(key: key);

  @override
  _AllDocsScreenState createState() => _AllDocsScreenState();
}

class _AllDocsScreenState extends State<AllDocsScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Widget pdfsList() {
    return StreamBuilder(
        stream: _firebaseFirestore
            .collection('users')
            .doc(_firebaseAuth.currentUser.uid)
            .collection('createdpdfs')
            .orderBy('fileCreationDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.isNotEmpty) {
              // noOfImportedFiles = snapshot.data.docs.length;
              // return importedDocsList(snapshot: snapshot);
            } else if (snapshot.data.docs.isEmpty) {
              return Text('No docs yet');
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: [
                Container(),

                /// shimmers
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.065 +
                      MediaQuery.of(context).size.width * 0.02,
                  left: MediaQuery.of(context).size.width * 0.02,
                  right: MediaQuery.of(context).size.width * 0.01,
                  child: Shimmers(),
                ),
              ],
            );
          } else {
            print('Error');
          }
          var fileList = snapshot.data.docs.map((file) {
            return PDFModel.fromDocument(file);
          }).toList();
          return ListView.builder(
            shrinkWrap: true,
            itemCount: fileList.length,
            itemBuilder: (BuildContext context, int index) {
              PDFModel pdfModel = fileList[index];
              return Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.02)),
                // margin: EdgeInsets.all(10.0),
                // color: Colors.greenAccent,
                height: MediaQuery.of(context).size.height * 0.23,
                child: GestureDetector(
                  onTap: () async {
                    print('index: ${index} tapped');
                    /*String url = pdfModel.pdfUrl;
                    final file = await DefaultCacheManager().getSingleFile(url);
                    var fileContent = await file.readAsString();
                    print(fileContent.characters);
                    Navigator.push(
                      context,
                      PageTransition(
                        child:
                        TextFileViewerScreen(fileContent: fileContent),
                        type: PageTransitionType.fade,
                      ),
                    );*/
                  },
                  child: Card(
                    color: Colors.indigo.shade200,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02),
                      child: Row(
                        children: [
                          /// pdf preview
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              // color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.02),
                              image: DecorationImage(
                                image: AssetImage('assets/images/pdf_icon.png'),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),

                              /// file name & more icon
                              Flexible(
                                flex: 3,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  // color: Colors.redAccent.shade100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.63,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// file name
                                      Flexible(
                                        flex: 5,
                                        child: Text(
                                          pdfModel.pdfName,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.arimo(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.028,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),

                                      /// more_vert icon
                                      Flexible(
                                        child:
                                            GlobalMethods.morePdfItemsPopupMenu(
                                          context: context,
                                          pdfModel: pdfModel,
                                          collectionName: 'createdpdfs',
                                          index: index,
                                          fileList: fileList,
                                          snapshot: snapshot,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // SizedBox(height: 10.0),

                              /// file creation date
                              Flexible(
                                flex: 1,
                                child: Text(
                                  pdfModel.fileCreationDate,
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                  style: GoogleFonts.arimo(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.025,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              /// pdf size & pdf no of pages
                              Flexible(
                                flex: 1,
                                child: Container(
                                  // color: Colors.lightBlue.shade100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.63,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    // mainAxisSize: MainAxisSize.max,
                                    children: [
                                      /// pdf size
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        // color: Colors.lightBlueAccent,
                                        child: Row(
                                          children: [
                                            Text(
                                              pdfModel.pdfSize,
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: GoogleFonts.arimo(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),

                                      /// pdf no of pages
                                      Container(
                                        // margin: EdgeInsets.all(10.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        // color: Colors.orange,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.0035,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.0001),
                                          child: Center(
                                            child: Text(
                                              pdfModel.pdfPageCount.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.visible,
                                              style: GoogleFonts.arimo(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  Widget textsList() {
    return StreamBuilder(
        stream: _firebaseFirestore
            .collection('users')
            .doc(_firebaseAuth.currentUser.uid)
            .collection('createdtxts')
            .orderBy('fileCreationDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.isNotEmpty) {
              // noOfImportedFiles = snapshot.data.docs.length;
              // return importedDocsList(snapshot: snapshot);
            } else if (snapshot.data.docs.isEmpty) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.10,
                color: Colors.deepOrange,
                alignment: Alignment.center,
                child: Text('NO DOCS YET',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.arimo(
                        fontSize: MediaQuery.of(context).size.height * 0.16,
                        color: Colors.grey)),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: [
                Container(),

                /// shimmers
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.065 +
                      MediaQuery.of(context).size.width * 0.02,
                  left: MediaQuery.of(context).size.width * 0.02,
                  right: MediaQuery.of(context).size.width * 0.01,
                  child: Shimmers(),
                ),
                // Positioned(
                //   top: 0.0,
                //   left: 0.0,
                //   bottom: 0.0,
                //   right: 0.0,
                //   // child: LoadingCubeGrid(),
                //   child: Shimmers(),
                // ),
              ],
            );
          } else {
            print('Error');
          }
          var fileList = snapshot.data.docs.map((file) {
            return TextModel.fromDocument(file);
          }).toList();
          return ListView.builder(
            // padding: EdgeInsets.only(top: 5.0),
            shrinkWrap: true,
            itemCount: fileList.length,
            itemBuilder: (BuildContext context, int index) {
              TextModel textModel = fileList[index];
              return
                  // files list
                  Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                // margin: EdgeInsets.all(10.0),
                // color: Colors.greenAccent,
                height: MediaQuery.of(context).size.height * 0.23,
                child: GestureDetector(
                  onTap: () async {
                    print('index: ${index} tapped');
                    /*String url = pdfModel.pdfUrl;
                    final file = await DefaultCacheManager().getSingleFile(url);
                    var fileContent = await file.readAsString();
                    print(fileContent.characters);
                    Navigator.push(
                      context,
                      PageTransition(
                        child:
                        TextFileViewerScreen(fileContent: fileContent),
                        type: PageTransitionType.fade,
                      ),
                    );*/
                  },
                  child: Card(
                    // margin: EdgeInsets.all(0),
                    color: Colors.indigo.shade200,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Image.asset(
                              'assets/images/pdf_icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              /// single file row
                              Flexible(
                                flex: 3,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  color: Colors.redAccent.shade100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.63,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// file name
                                      Flexible(
                                        flex: 5,
                                        child: Text(
                                          textModel.textName,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.arimo(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.028,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),

                                      /// more_vert icon
                                      Flexible(
                                        child:
                                            GlobalMethods.morePdfItemsPopupMenu(
                                                context: context),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// file creation date, text size
                              Flexible(
                                flex: 1,
                                child: Container(
                                  color: Colors.lightBlue.shade100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.63,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      /// file creation date
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.10,
                                        color: Colors.limeAccent,
                                        child: Text(
                                          textModel.fileCreationDate,
                                          maxLines: 1,
                                          overflow: TextOverflow.visible,
                                          style: GoogleFonts.arimo(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),

                                      /// text size
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.10,
                                        color: Colors.lightBlueAccent,
                                        child: Text(
                                          textModel.textSize,
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          style: GoogleFonts.arimo(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  Widget Shimmers() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          // height: MediaQuery.of(context).size.height * 0.23 -
          //     MediaQuery.of(context).size.width * 0.02,
          // width: MediaQuery.of(context).size.width,
          // padding: EdgeInsets.only(
          //   top: MediaQuery.of(context).size.height * 0.005,
          //   left: MediaQuery.of(context).size.height * 0.02,
          //   right: MediaQuery.of(context).size.height * 0.02,
          //   bottom: MediaQuery.of(context).size.height * 0.02,
          // ),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          height: MediaQuery.of(context).size.height * 0.23,
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.02),
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Shimmer.fromColors(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    baseColor: Colors.white38,
                    highlightColor: Colors.grey,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Column(
                  children: [
                    // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Flexible(
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.18,
                        width: MediaQuery.of(context).size.width * 0.665,
                        // padding: EdgeInsets.symmetric(
                        //     vertical: MediaQuery.of(context).size.width * 0.02),
                        child: Shimmer.fromColors(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          baseColor: Colors.white38,
                          highlightColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getShimmer();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.065,
          child: TabBar(
            indicatorWeight: MediaQuery.of(context).size.height * 0.005,
            controller: tabController,
            labelColor: Colors.redAccent,
            labelStyle: GoogleFonts.arimo(
              fontSize: MediaQuery.of(context).size.height * 0.025,
              fontWeight: FontWeight.w700,
            ),
            tabs: [
              StreamBuilder(
                  stream: _firebaseFirestore
                      .collection('users')
                      .doc(_firebaseAuth.currentUser.uid)
                      .collection('createdpdfs')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.isNotEmpty) {
                        HomeScreen.noOfCreatedPdfs = snapshot.data.docs.length;
                        return Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01),
                                child: Icon(MdiIcons.filePdfBox,
                                    size: MediaQuery.of(context).size.width *
                                        0.07),
                              ),
                              Text(
                                '(${HomeScreen.noOfCreatedPdfs})',
                                style: GoogleFonts.arimo(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.data.docs.isEmpty) {
                        return Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.01),
                            child: Icon(MdiIcons.filePdfBox,
                                size: MediaQuery.of(context).size.width * 0.07),
                          ),
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Text(
                        '',
                        style: GoogleFonts.arimo(
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      );
                    } else {
                      HomeScreen.noOfCreatedPdfs = 0;
                    }
                    return Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.01),
                            child: Icon(MdiIcons.filePdfBox,
                                size: MediaQuery.of(context).size.width * 0.07),
                          ),
                          Text(
                            '(${HomeScreen.noOfCreatedPdfs})',
                            style: GoogleFonts.arimo(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                        ],
                      ),
                    );
                  }),
              StreamBuilder(
                  stream: _firebaseFirestore
                      .collection('users')
                      .doc(_firebaseAuth.currentUser.uid)
                      .collection('createdtxts')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.isNotEmpty) {
                        HomeScreen.noOfCreatedTexts = snapshot.data.docs.length;
                        return Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01),
                                child: Icon(MaterialCommunityIcons.format_text,
                                    size: MediaQuery.of(context).size.width *
                                        0.07),
                              ),
                              Text(
                                '(${HomeScreen.noOfCreatedTexts})',
                                style: GoogleFonts.arimo(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.data.docs.isEmpty) {
                        return Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.01),
                            child: Icon(MaterialCommunityIcons.format_text,
                                size: MediaQuery.of(context).size.width * 0.07),
                          ),
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Text(
                        '',
                        style: GoogleFonts.arimo(
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      );
                    } else {
                      HomeScreen.noOfCreatedTexts = 0;
                    }
                    return Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.01),
                            child: Icon(MaterialCommunityIcons.format_text,
                                size: MediaQuery.of(context).size.width * 0.07),
                          ),
                          Text(
                            '(${HomeScreen.noOfCreatedTexts})',
                            style: GoogleFonts.arimo(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [pdfsList(), textsList()],
          ),
        ),
      ],
    );
  }
}
