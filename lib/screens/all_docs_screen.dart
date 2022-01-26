import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/screens/rendered_images_screen.dart';
import 'package:paint_to_print/services/global_methods.dart';
import 'package:paint_to_print/widgets/loading_cube_grid.dart';

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
  int noOfImportedFiles = 0;
  int noOfCreatedPdfs = 0;
  int noOfCreatedTexts = 0;

  Widget docsList({String collectionName}) {
    return StreamBuilder(
        stream: _firebaseFirestore
            .collection('users')
            .doc(_firebaseAuth.currentUser.uid)
            .collection(collectionName)
            .orderBy('timestamp', descending: true)
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
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  bottom: 0.0,
                  right: 0.0,
                  child: LoadingCubeGrid(),
                ),
              ],
            );
          } else {
            noOfImportedFiles = 0;
            print('Error');
          }
          return ListView.builder(
            // padding: EdgeInsets.only(top: 5.0),
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return /*index == 0
                  ?
                  // All Docs (no of files)
                  Container(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'All Docs ($noOfImportedFiles)',
                        style: GoogleFonts.arimo(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  :*/
                  // files list
                  Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                // margin: EdgeInsets.all(10.0),
                color: Colors.greenAccent,
                height: MediaQuery.of(context).size.height * 0.23,
                child: GestureDetector(
                  onTap: () {
                    print('index: ${index} tapped');
                    Navigator.push(
                      context,
                      PageTransition(
                        child: RenderedImagesScreen(
                            pdfSnapshot: snapshot.data.docs[index]),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  onLongPress: () {},
                  child: Card(
                    // margin: EdgeInsets.all(0),
                    color: Colors.indigo.shade200,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf_rounded,
                            size: MediaQuery.of(context).size.width * 0.3),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // file name
                            Flexible(
                              flex: 3,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                color: Colors.redAccent.shade100,
                                width: MediaQuery.of(context).size.width * 0.63,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// file name
                                    Flexible(
                                      flex: 5,
                                      child: AutoSizeText(
                                        snapshot.data.docs[index]['file_name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.arimo(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
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
                            SizedBox(height: 10.0),
                            // file creation date, pdf size & pdf no of pages
                            Flexible(
                              flex: 1,
                              child: Container(
                                color: Colors.lightBlue.shade100,
                                width: MediaQuery.of(context).size.width * 0.63,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // file creation date
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.10,
                                        color: Colors.limeAccent,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: AutoSizeText(
                                                snapshot.data.docs[index]
                                                    ['file_creation_datetime'],
                                                maxLines: 1,
                                                overflow: TextOverflow.visible,
                                                style: GoogleFonts.arimo(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.05,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // pdf size
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.10,
                                        color: Colors.lightBlueAccent,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            /*Flexible(
                                                    child: Icon(
                                                  Feather.file,
                                                  size: 16.0,
                                                )),*/
                                            Flexible(
                                              child: AutoSizeText(
                                                '22MB',
                                                maxLines: 1,
                                                overflow: TextOverflow.visible,
                                                style: GoogleFonts.arimo(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.05,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // pdf no of pages
                                    Flexible(
                                      flex: 1,
                                      // child: Container(
                                      //   height: MediaQuery.of(context).size.height * 0.10,
                                      //   color: Colors.orange,
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.spaceAround,
                                      //     children: [
                                      //       Flexible(
                                      //         child: Icon(Icons.pages_rounded,
                                      //             size: MediaQuery.of(context).size.height * 0.04),
                                      //       ),
                                      //       Flexible(
                                      //         child: AutoSizeText(
                                      //           '6',
                                      //           maxLines: 1,
                                      //           overflow: TextOverflow.visible,
                                      //           style: GoogleFonts.arimo(
                                      //             fontSize: MediaQuery.of(context).size.height * 0.05,
                                      //             fontWeight: FontWeight.w700,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      child: Container(
                                        // margin: EdgeInsets.all(10.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.10,
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
                                                  0.004,
                                            )),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.0001),
                                          child: Center(
                                            child: AutoSizeText(
                                              '6',
                                              maxLines: 1,
                                              overflow: TextOverflow.visible,
                                              style: GoogleFonts.arimo(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                fontWeight: FontWeight.w700,
                                              ),
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
              );
            },
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
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
                      .collection('importedfiles')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.isNotEmpty) {
                        noOfImportedFiles = snapshot.data.docs.length;
                        return Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01),
                                child: Icon(MdiIcons.fileImport,
                                    size: MediaQuery.of(context).size.width *
                                        0.07),
                              ),
                              Text(
                                '($noOfImportedFiles)',
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
                            child: Icon(MdiIcons.fileImport,
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
                      noOfImportedFiles = 0;
                    }
                    return Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.01),
                            child: Icon(MdiIcons.fileImport,
                                size: MediaQuery.of(context).size.width * 0.07),
                          ),
                          Text(
                            '($noOfImportedFiles)',
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
                      .collection('createdpdfs')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.isNotEmpty) {
                        noOfCreatedPdfs = snapshot.data.docs.length;
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
                                '($noOfCreatedPdfs)',
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
                      noOfCreatedPdfs = 0;
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
                            '($noOfCreatedPdfs)',
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
                        noOfCreatedTexts = snapshot.data.docs.length;
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
                                '($noOfCreatedTexts)',
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
                      noOfCreatedTexts = 0;
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
                            '($noOfCreatedTexts)',
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
            children: [
              docsList(collectionName: 'importedfiles'),
              docsList(collectionName: 'createdpdfs'),
              docsList(collectionName: 'createdtxts'),
            ],
          ),
        ),
      ],
    );
  }
}
