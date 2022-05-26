import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paint_to_print/services/check_for_invalid_string.dart';
import 'package:paint_to_print/services/global_methods.dart';
import 'package:paint_to_print/widgets/pdf_screen_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PdfViewScreen extends StatefulWidget {
  final String pdfUrl;
  final String pdfLocation;
  final String pdfName;
  final String pdfCreationDate;

  const PdfViewScreen({
    Key key,
    this.pdfUrl,
    this.pdfLocation,
    this.pdfName,
    this.pdfCreationDate,
  }) : super(key: key);

  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  PdfViewerController _pdfViewerController = PdfViewerController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  OverlayEntry _overlayEntry;
  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  bool _isSearching = false;
  bool _showToolbar;
  bool _showScrollHead;
  LocalHistoryEntry _historyEntry;
  bool _allowWriteFile = false;
  String progress = '';
  ProgressDialog progressDialog;
  Dio dio;

  void sharePdf(BuildContext context) async {
    print('sharePdf');
    final directory = await getExternalStorageDirectory();
    final pdfFile = File('${directory.path}/${widget.pdfName}.pdf');
    if (pdfFile.existsSync() == true) {
      print('pdf exists');
      Share.shareFiles(['${directory.path}/${widget.pdfName}.pdf'],
          text: '${widget.pdfName}');
    } else {
      print('pdf doesn\'t exist');
      downloadPdf(context, widget.pdfUrl,
              directory.path + '/' + widget.pdfName + '.pdf')
          .then((value) {
        progressDialog.hide();
        Share.shareFiles(['${directory.path}/${widget.pdfName}.pdf'],
            text: '${widget.pdfName}');
      });
    }
  }

  requestWritePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        _allowWriteFile = true;
      });
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }

  Future downloadPdf(
      BuildContext context, String downloadUrl, String path) async {
    if (!_allowWriteFile) {
      requestWritePermission();
    }
    try {
      progressDialog.show();
      print(downloadUrl);
      print(path);
      await dio.download(downloadUrl, path, onReceiveProgress: (rec, total) {
        // setState(() {
        //   progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
        //   progressDialog.setMessage(Text("Downloading $progress"));
        // });
      }).then((value) {
        print('downloaded');
      });
      progressDialog.hide();
    } catch (error) {
      print('98. Error: $error');
    }
  }

  Future removePdf(BuildContext context, String pdfName) async {
    GlobalMethods.customDialog(
      context,
      'Warning!',
      'Do you want to delete this pdf?',
      () async {
        if (!_allowWriteFile) {
          requestWritePermission();
        }
        try {
          final directory = await getExternalStorageDirectory();
          final pdfFile = File('${directory.path}/${widget.pdfName}.pdf');
          // delete from local storage
          if (await pdfFile.existsSync()) {
            print('pdf exists');
            await pdfFile.delete();
          } else {
            print('pdf doesn\'t exist');
          }
          // delete from firestore
          Navigator.of(context)
              .pop(); // popping out the custom alert dialog for delete
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser.uid)
              .collection('pdfs')
              .doc(widget.pdfCreationDate)
              .delete()
              .then((value) {
            Navigator.of(context).pop(); // for modal bottom sheet
            Navigator.of(context).pop(); // popping out the pdf view screen
            Fluttertoast.showToast(
              msg: 'Pdf delete successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.black,
              fontSize: 16.0,
            );
          });
        } catch (error) {
          print('Error: $error');
        }
      },
    );
  }

  void _ensureHistoryEntry(BuildContext context) {
    if (_historyEntry == null) {
      final ModalRoute<dynamic> route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry);
      }
    }
  }

  void _handleHistoryEntryRemoved() {
    _textSearchKey.currentState?.clearSearch();
    setState(() {
      _showToolbar = false;
    });
    _historyEntry = null;
  }

  // copy selected text
  void showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion.center.dy - 55,
        left: details.globalSelectedRegion.bottomLeft.dx,
        child: TextButton(
          child: Text(
            'Copy',
            style: GoogleFonts.arimo(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
          ),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            _pdfViewerController.clearSelection();
          },
          style: TextButton.styleFrom(
            elevation: 8.0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ),
    );
    _overlayState.insert(_overlayEntry);
  }

  // modal bottom sheet
  Future<void> showBottomSheetMore(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      elevation: 8.0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Card(
            elevation: 8.0,
            // color: Colors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Column(
              children: [
                // pdf name
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        MaterialCommunityIcons.pdf_box,
                        color: Colors.redAccent,
                      ),
                    ),
                    Flexible(
                      child: AutoSizeText(
                        widget.pdfName,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.arimo(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.black),
                // share
                // TODO: Copy the previous share from Global Methods
                ModalListTile(
                  context,
                  title: 'Share',
                  iconData: MaterialCommunityIcons.share,
                  onTap: () async {
                    print('share pdf');
                    sharePdf(context);
                    Navigator.of(context).pop();
                  },
                ),
                // download
                // TODO: Copy the previous download from Global Methods
                ModalListTile(
                  context,
                  title: 'Download',
                  iconData: MaterialCommunityIcons.file_download,
                  onTap: () async {
                    Navigator.of(context).pop();
                    final directory = await getExternalStorageDirectory();
                    final pdfFile =
                        File('${directory.path}/${widget.pdfName}.pdf');
                    downloadPdf(context, widget.pdfUrl,
                            directory.path + '/' + widget.pdfName + '.pdf')
                        .then((value) {
                      Fluttertoast.showToast(
                        msg: 'Pdf Downloaded at ${directory.path}',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.black,
                        fontSize: 16.0,
                      );
                    });
                  },
                ),
                // remove
                // TODO: Copy the previous delete from Global Methods
                ModalListTile(
                  context,
                  title: 'Remove',
                  iconData: MaterialIcons.delete,
                  color: Colors.redAccent,
                  onTap: () async {
                    removePdf(context, widget.pdfName);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return _showToolbar
        ? AppBar(
            flexibleSpace: SafeArea(
              child: SearchToolbar(
                key: _textSearchKey,
                showTooltip: true,
                controller: _pdfViewerController,
                onTap: (Object toolbarItem) async {
                  if (toolbarItem.toString() == 'Cancel Search') {
                    setState(() {
                      _showToolbar = false;
                      _showScrollHead = true;
                      if (Navigator.canPop(context)) {
                        Navigator.maybePop(context);
                      }
                    });
                  }
                  if (toolbarItem.toString() == 'noResultFound') {
                    setState(() {
                      _textSearchKey.currentState?.showToast = true;
                    });
                    await Future.delayed(Duration(seconds: 1));
                    setState(() {
                      _textSearchKey.currentState?.showToast = false;
                    });
                  }
                },
              ),
            ),
            elevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.redAccent,
          )
        : AppBar(
            title: Text(
              widget.pdfName,
              style: GoogleFonts.arimo(
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_rounded),
            ),
            actions: [
              // arrow up & arrow down --> previous & next page
              Visibility(
                visible: !_isSearching,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // arrow up
                    InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () {
                        _pdfViewerController.previousPage();
                      },
                      child: Icon(EvaIcons.arrowUp),
                    ),
                    // arrow down
                    InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () {
                        _pdfViewerController.nextPage();
                      },
                      child: Icon(EvaIcons.arrowDown),
                    ),
                  ],
                ),
              ),
              // search icon
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _showScrollHead = false;
                    _showToolbar = true;
                    _ensureHistoryEntry(context);
                  });
                },
              ),
              // more_vert --> modal bottom sheet
              Visibility(
                visible: !_isSearching,
                child: InkWell(
                  onTap: () {
                    showBottomSheetMore(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(MaterialIcons.more_vert),
                  ),
                ),
              ),
              Visibility(
                visible: _searchResult.hasResult,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchResult.clear();
                    });
                  },
                ),
              ),
              Visibility(
                visible: _searchResult.hasResult,
                child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_up, color: Colors.white),
                  onPressed: () {
                    _searchResult.previousInstance();
                  },
                ),
              ),
              Visibility(
                visible: _searchResult.hasResult,
                child: IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _searchResult.nextInstance();
                  },
                ),
              ),
            ],
          );
  }

  @override
  void initState() {
    _showToolbar = false;
    _showScrollHead = true;
    dio = Dio();
    print(widget.pdfLocation);
    print(isStringInvalid(text: widget.pdfLocation));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Download,
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
      ),
    );

    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          isStringInvalid(text: widget.pdfLocation)
              ? SfPdfViewer.network(
                  widget.pdfUrl,
                  key: _pdfViewerKey,
                  enableDoubleTapZooming: true,
                  controller: _pdfViewerController,
                  onTextSelectionChanged:
                      (PdfTextSelectionChangedDetails details) {
                    if (details.selectedText == null && _overlayEntry != null) {
                      _overlayEntry.remove();
                      _overlayEntry = null;
                    } else if (details.selectedText != null &&
                        _overlayEntry == null) {
                      showContextMenu(context, details);
                    }
                  },
                  canShowScrollHead: _showScrollHead,
                  enableTextSelection: true,
                  enableDocumentLinkAnnotation: true,
                  currentSearchTextHighlightColor:
                      Theme.of(context).primaryColorLight,
                )
              : SfPdfViewer.file(
                  File(widget.pdfLocation),
                  key: _pdfViewerKey,
                  enableDoubleTapZooming: true,
                  controller: _pdfViewerController,
                  onTextSelectionChanged:
                      (PdfTextSelectionChangedDetails details) {
                    if (details.selectedText == null && _overlayEntry != null) {
                      _overlayEntry.remove();
                      _overlayEntry = null;
                    } else if (details.selectedText != null &&
                        _overlayEntry == null) {
                      showContextMenu(context, details);
                    }
                  },
                  canShowScrollHead: _showScrollHead,
                  enableTextSelection: true,
                  enableDocumentLinkAnnotation: true,
                  currentSearchTextHighlightColor:
                      Theme.of(context).primaryColorLight,
                ),
        ],
      ),
    );
  }
}
