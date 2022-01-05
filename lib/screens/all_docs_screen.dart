import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                // margin: EdgeInsets.all(10.0),
                color: Colors.greenAccent,
                height: 130.0,
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
                    color: Colors.indigo.shade200,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf_rounded, size: 100.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // file name
                            Flexible(
                              flex: 3,
                              child: Container(
                                height: 50.0,
                                color: Colors.redAccent.shade100,
                                width:
                                    MediaQuery.of(context).size.width - 160.0,
                                child: Row(
                                  children: [
                                    /// file name
                                    Flexible(
                                      flex: 5,
                                      child: AutoSizeText(
                                        snapshot.data.docs[index]
                                            ['file_name_trimmed'],
                                        maxLines: 2,
                                        overflow: TextOverflow.visible,
                                        style: GoogleFonts.arimo(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),

                                    /// more_vert icon
                                    Flexible(
                                      child:
                                          GlobalMethods.morePdfItemsPopupMenu(),
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
                                width:
                                    MediaQuery.of(context).size.width - 160.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // file creation date
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 30.0,
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
                                                  fontSize: 14.0,
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
                                        height: 30.0,
                                        color: Colors.limeAccent,
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
                                                  fontSize: 14.0,
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
                                      child: Container(
                                        height: 30.0,
                                        color: Colors.orange,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                              child: Icon(Icons.pages_rounded,
                                                  size: 16.0),
                                            ),
                                            Flexible(
                                              child: AutoSizeText(
                                                '6',
                                                maxLines: 1,
                                                overflow: TextOverflow.visible,
                                                style: GoogleFonts.arimo(
                                                  fontSize: 14.0,
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
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TabBar(
          controller: tabController,
          labelColor: Colors.redAccent,
          labelStyle: GoogleFonts.arimo(
            fontSize: 18.0,
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
                      return Tab(text: 'Imported Files ($noOfImportedFiles)');
                    } else if (snapshot.data.docs.isEmpty) {
                      return Text('No docs yet');
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
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
                  }
                  return Tab(text: 'Imported Files ($noOfImportedFiles)');
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
                      return Tab(text: 'Created Pdfs ($noOfCreatedPdfs)');
                    } else if (snapshot.data.docs.isEmpty) {
                      return Text('No docs yet');
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
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
                    noOfCreatedPdfs = 0;
                  }
                  return Tab(text: 'Created Pdfs ($noOfCreatedPdfs)');
                }),
          ],
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              docsList(collectionName: 'importedfiles'),
              docsList(collectionName: 'createdpdfs'),
            ],
          ),
        ),
      ],
    );
  }
}
