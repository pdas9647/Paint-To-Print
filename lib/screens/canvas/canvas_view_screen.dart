import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint_to_print/models/pdf_model.dart';
import 'package:paint_to_print/models/prediction_model.dart';
import 'package:paint_to_print/services/recognizer.dart';
import 'package:paint_to_print/utils/constants.dart';
import 'package:paint_to_print/widgets/floating_action_button_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../pdf_images_screen.dart';
import 'own_custom_painter.dart';

class CanvasViewScreen extends StatefulWidget {
  final bool isNavigatedFromHomeScreen;
  final bool isNavigatedFromPdfImagesScreen;
  final List<Uint8List> canvasImages;
  final List<String> convertedTexts;
  final PdfModel pdfModel;
  double strokeWidth;

  CanvasViewScreen({
    Key key,
    @required this.isNavigatedFromHomeScreen,
    @required this.isNavigatedFromPdfImagesScreen,
    this.canvasImages,
    this.convertedTexts,
    @required this.pdfModel,
    this.strokeWidth = 2.0,
  }) : super(key: key);

  @override
  _CanvasViewScreenState createState() => _CanvasViewScreenState();
}

class _CanvasViewScreenState extends State<CanvasViewScreen> {
  final GlobalKey<AnimatedFloatingActionButtonState> floatingActionButtonKey =
      GlobalKey();
  final GlobalKey canvasKey = GlobalKey();
  List<DrawingArea> points = [];
  List<Uint8List> canvasImages = [];
  List<String> convertedTexts = [];
  List<PredictionModel> predictions = [];
  Color selectedColor = Colors.black;
  var directoryName = 'Paint to Print';

  void selectColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.02),
          ),
          title: Text(
            'Color Chooser',
            style: GoogleFonts.arimo(
              fontSize: MediaQuery.of(context).size.height * 0.05,
              color: selectedColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: changeColor,
              paletteType: PaletteType.hueWheel,
            ),
            // child: BlockPicker(
            //   pickerColor: selectedColor,
            //   onColorChanged: changeColor,
            // ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Okay',
                style: GoogleFonts.arimo(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  color: selectedColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void changeColor(Color color) {
    setState(() => selectedColor = color);
  }

  void selectStrokeWidth() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 0.02)),
              title: Text(
                'Select stroke width',
                style: GoogleFonts.arimo(
                    fontSize: MediaQuery.of(context).size.height * 0.05,
                    color: selectedColor),
              ),
              content: SingleChildScrollView(
                child: CupertinoSlider(
                  min: 1.0,
                  max: 10.0,
                  value: widget.strokeWidth, thumbColor: selectedColor,
                  // label: 'Stroke width',
                  activeColor: selectedColor,
                  // inactiveColor: Colors.blueGrey.shade200,
                  onChanged: (double value) {
                    setState(() {
                      widget.strokeWidth = value;
                    });
                    print(widget.strokeWidth);
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Okay',
                    style: GoogleFonts.arimo(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                      color: selectedColor,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _recognize() async {
    print('_recognize called');
    print('points: ${points.first.point}');
    List<dynamic> _predictions = await Recognizer().recognize(context, points);
    predictions =
        _predictions.map((json) => PredictionModel.fromJson(json)).toList();
    print(_predictions.first);
  }

  Future<void> saveCanvas() async {
    // RenderRepaintBoundary boundary =
    //     canvasKey.currentContext.findRenderObject();
    // ui.Image image = await boundary.toImage();
    // ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List pngBytes = byteData.buffer.asUint8List();

    // final picture = Recognizer().pointsToPicture(points);
    // Uint8List pngBytes = await Recognizer()
    //     .imageToByteListUint8(picture, Constants.mnistImageSize);
    // print(pngBytes);

    // ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    // ui.Picture picture = pictureRecorder.endRecording();
    // ui.Image image = await picture.toImage(MediaQuery.of(context).size.width.toInt(),
    //     MediaQuery.of(context).size.height.toInt());
    // ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List pngBytes = byteData.buffer.asUint8List();
    // Uint8List pngBytes = await Recognizer().imageToByteListUint8(
    //   Recognizer().pointsToPicture(points),
    //   Constants.mnistImageSize,
    // );
    ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    Canvas canvas = new Canvas(pictureRecorder);
    OwnCustomPainter(pointsList: points)..paint(canvas, Size.infinite);
    ui.Picture picture = pictureRecorder.endRecording();
    ui.Image image = await picture.toImage(
      (Constants.blockSizeHorizontal * 0.90).toInt(),
      (Constants.blockSizeVertical * 0.90 - kBottomNavigationBarHeight * 2)
          .toInt(),
    );
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);

    /// if canvas is navigated from home_screen (handwriting to text) --> navigate to pdf images screen
    if (widget.isNavigatedFromHomeScreen) {
      // final bytes = File(byteData.path).readAsBytesSync();
      canvasImages.clear();
      await _recognize();
      canvasImages.add(Uint8List.fromList(pngBytes));
      convertedTexts.add('${predictions.first.label}');
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: PdfImagesScreen(
            isNavigatedFromHomeScreen: true,
            canvasImages: canvasImages,
            convertedTexts: convertedTexts,
          ),
          type: PageTransitionType.fade,
        ),
      );
    }

    /// if canvas is navigated from pdf_images_screen (handwriting to text) --> navigate to pdf images screen
    else if (widget.isNavigatedFromPdfImagesScreen) {
      // canvasImages list shouldn't be cleared
      canvasImages = widget.canvasImages;
      convertedTexts = widget.convertedTexts;
      await _recognize();
      canvasImages.add(Uint8List.fromList(pngBytes));
      convertedTexts.add('${predictions.first.label}');
      _recognize();
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: PdfImagesScreen(
            isNavigatedFromHomeScreen: false,
            canvasImages: canvasImages,
            pdfModel: widget.pdfModel,
            convertedTexts: convertedTexts,
          ),
          type: PageTransitionType.fade,
        ),
      );
    }

    /// if canvas is navigated from bottom nav bar ---> save file
    else {
      RenderRepaintBoundary boundary =
          canvasKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      //Request permissions if not already granted
      if (!(await Permission.storage.status.isGranted))
        await Permission.storage.request();
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 100,
        name: DateTime.now().toIso8601String(),
      );
      print(result);
    }
  }

  Future<void> _initMLModel() async {
    await Recognizer().loadModel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initMLModel();
    selectedColor = Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    Constants().init(context);
    final height = Constants.blockSizeVertical;
    final width = Constants.blockSizeHorizontal;

    return Scaffold(
      appBar: widget.isNavigatedFromHomeScreen ||
              widget.isNavigatedFromPdfImagesScreen
          ? AppBar(
              title: Text(
                'CANVAS',
                style: GoogleFonts.arimo(fontSize: width * 0.07),
              ),
              elevation: 0.0,
              toolbarHeight: height * 0.10,
              leadingWidth: width * 0.20,
              leading: Transform.scale(
                scale: 1.5,
                child: Container(
                  width: width * 0.20,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios, size: height * 0.03),
                  ),
                ),
              ),
            )
          : null,
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            /// background gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: widget.isNavigatedFromHomeScreen
                    ? BorderRadius.zero
                    : BorderRadius.vertical(top: Radius.circular(15.0)),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.secondaryVariant,
                  ],
                  tileMode: TileMode.decal,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            /// column --> canvas
            Center(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: !widget.isNavigatedFromHomeScreen &&
                          !widget.isNavigatedFromPdfImagesScreen
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02),

                    /// dividers & canvas
                    // Flexible(
                    //   flex: 20,child:
                    Container(
                      width: width * 0.90,
                      height: !widget.isNavigatedFromHomeScreen &&
                              !widget.isNavigatedFromPdfImagesScreen
                          ? height * 0.85 - kBottomNavigationBarHeight * 2
                          : height * 0.76,
                      child: Card(
                        elevation: 10.0,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            Offset _localPosition = details.localPosition;
                            if (_localPosition.dx >= 0 &&
                                _localPosition.dx <= width * 0.90 &&
                                _localPosition.dy >= 0 &&
                                _localPosition.dy <=
                                    height * 0.90 -
                                        kBottomNavigationBarHeight * 2) {
                              setState(() {
                                points.add(
                                  DrawingArea(
                                    point: details.localPosition,
                                    areaPaint: Paint()
                                      ..color = selectedColor
                                      ..strokeWidth = widget.strokeWidth
                                      ..isAntiAlias = true
                                      ..strokeCap = StrokeCap.round,
                                  ),
                                );
                              });
                            }
                          },
                          onPanStart: (details) {
                            Offset _localPosition = details.localPosition;
                            if (_localPosition.dx >= 0 &&
                                _localPosition.dx <= width * 0.90 &&
                                _localPosition.dy >= 0 &&
                                _localPosition.dy <=
                                    height * 0.90 -
                                        kBottomNavigationBarHeight * 2) {
                              setState(() {
                                points.add(
                                  DrawingArea(
                                    point: details.localPosition,
                                    areaPaint: Paint()
                                      ..strokeCap = StrokeCap.round
                                      ..isAntiAlias = true
                                      ..color = selectedColor
                                      ..strokeWidth = widget.strokeWidth,
                                  ),
                                );
                              });
                            }
                          },
                          onPanEnd: (details) {
                            setState(() {
                              points.add(null);
                            });
                          },
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            child: RepaintBoundary(
                              key: canvasKey,
                              child: Stack(
                                children: [
                                  /// divider listview
                                  Container(
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: int.parse(
                                          '${(height * 0.90 / 50).ceil()}'),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return const Divider(
                                          color: Colors.black,
                                          height: 50.0,
                                          indent: 20.0,
                                          endIndent: 20.0,
                                        );
                                      },
                                    ),
                                    color: Colors.white,
                                  ),
                                  CustomPaint(
                                      painter:
                                          OwnCustomPainter(pointsList: points)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ),
                    // const Flexible(flex: 1, child: SizedBox(height: 10.0)),

                    /// row of icons
                    Visibility(
                      visible: widget.isNavigatedFromHomeScreen ||
                          widget.isNavigatedFromPdfImagesScreen,
                      child: Container(
                        height: height * 0.07,
                        // color: Colors.orange,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            /// clear all
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  points.clear();
                                  predictions.clear();
                                });
                              },
                              icon: Icon(
                                Icons.clear_all_rounded,
                                size: height * 0.05,
                              ),
                            ),

                            /// stroke width
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectStrokeWidth();
                                });
                              },
                              icon: Icon(
                                Icons.brush_rounded,
                                color: selectedColor,
                                size: height * 0.05,
                              ),
                            ),

                            /// choose color
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectColor();
                                });
                              },
                              icon: Icon(
                                Icons.color_lens_rounded,
                                color: selectedColor,
                                size: height * 0.05,
                              ),
                            ),

                            /// save
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  saveCanvas();
                                });
                              },
                              icon: Icon(
                                Icons.save_rounded,
                                size: height * 0.05,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // PredictionWidget(predictions: predictions),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton will be visible only when navigated from bottom nav bar
      floatingActionButton: Visibility(
        visible: !widget.isNavigatedFromHomeScreen &&
            !widget.isNavigatedFromPdfImagesScreen,
        child: Container(
          // width: width * 0.10,
          // height: height * 0.20,
          padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight * 2),
          child: SpeedDial(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: MediaQuery.of(context).size.height * 0.04,
            ),
            closedForegroundColor: Colors.black,
            openForegroundColor: Colors.white,
            labelsStyle: GoogleFonts.arimo(
                fontSize: MediaQuery.of(context).size.height * 0.02),
            closedBackgroundColor: Theme.of(context).primaryColor,
            openBackgroundColor: Theme.of(context).colorScheme.error,
            speedDialChildren: <SpeedDialChild>[
              /// clear
              SpeedDialChild(
                child: Icon(
                  Icons.clear_all_rounded,
                  size: MediaQuery.of(context).size.height * 0.02,
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                label: 'Clear',
                onPressed: () {
                  setState(() {
                    points.clear();
                    predictions.clear();
                  });
                },
                closeSpeedDialOnPressed: true,
              ),

              /// select stoke width
              SpeedDialChild(
                child: Icon(
                  Icons.brush_rounded,
                  size: MediaQuery.of(context).size.height * 0.02,
                ),
                foregroundColor: selectedColor,
                backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
                label: 'Select stroke width',
                onPressed: () {
                  setState(() {
                    selectStrokeWidth();
                  });
                },
                closeSpeedDialOnPressed: true,
              ),

              /// choose color
              SpeedDialChild(
                child: Icon(
                  Icons.color_lens_rounded,
                  size: MediaQuery.of(context).size.height * 0.02,
                ),
                foregroundColor: selectedColor,
                backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
                label: 'Choose color',
                onPressed: () {
                  setState(() {
                    selectColor();
                  });
                },
                closeSpeedDialOnPressed: true,
              ),

              /// save
              SpeedDialChild(
                child: Icon(
                  Icons.save_rounded,
                  size: MediaQuery.of(context).size.height * 0.02,
                ),
                foregroundColor: Colors.black,
                backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
                label: 'Save',
                onPressed: () {
                  setState(() {
                    saveCanvas();
                  });
                },
                closeSpeedDialOnPressed: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({this.point, this.areaPaint});
}
