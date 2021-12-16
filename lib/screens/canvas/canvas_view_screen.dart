import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paint_to_print/widgets/floating_action_button_text.dart';
import 'package:permission_handler/permission_handler.dart';

import 'own_custom_painter.dart';

class CanvasViewScreen extends StatefulWidget {
  const CanvasViewScreen({Key key}) : super(key: key);

  @override
  _CanvasViewScreenState createState() => _CanvasViewScreenState();
}

class _CanvasViewScreenState extends State<CanvasViewScreen> {
  final GlobalKey<AnimatedFloatingActionButtonState> floatingActionButtonKey =
      GlobalKey();
  final GlobalKey canvasKey = GlobalKey();
  List<DrawingArea> points = [];
  Color selectedColor;
  double strokeWidth;
  // bool isDarkTheme = false;

  Widget clearCanvasFloatingAction() {
    return FloatActionButtonText(
      onPressed: () {
        floatingActionButtonKey.currentState.animate();
        setState(() {
          points.clear();
        });
      },
      icon: Icons.clear_all_rounded,
      color: selectedColor,
      textLeft: -73,
      text: 'Clear',
    );
  }

  Widget chooseStrokeWidthFloatingAction() {
    return FloatActionButtonText(
      onPressed: () {
        floatingActionButtonKey.currentState.animate();
        selectStrokeWidth();
      },
      icon: Icons.brush_rounded,
      color: selectedColor,
      textLeft: -163,
      text: 'Select Stroke Width',
    );
  }

  Widget chooseColorFloatingAction() {
    return FloatActionButtonText(
      onPressed: () {
        floatingActionButtonKey.currentState.animate();
        selectColor();
      },
      icon: Icons.color_lens_rounded,
      color: selectedColor,
      textLeft: -125,
      text: 'Choose Color',
    );
  }

  Widget saveCanvasFloatingAction() {
    return FloatActionButtonText(
      onPressed: () {
        floatingActionButtonKey.currentState.animate();
        _saveCanvas();
      },
      icon: MdiIcons.contentSave,
      color: selectedColor,
      textLeft: -70,
      text: 'Save',
    );
  }

  void selectColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            'Color Chooser',
            style: GoogleFonts.courgette(
              fontSize: 17.0,
              color: selectedColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: changeColor,
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
                style: GoogleFonts.courgette(
                  fontSize: 17.0,
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

  void selectStrokeWidth() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            'Choose Stroke Width',
            style: GoogleFonts.courgette(
              fontSize: 17.0,
              color: selectedColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Slider(
              min: 1.0,
              max: 7.0,
              value: strokeWidth,
              activeColor: selectedColor,
              inactiveColor: Colors.blueGrey.shade200,
              onChanged: (double value) {
                // setState(() {
                strokeWidth = value;
                // });
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
                style: GoogleFonts.courgette(
                  fontSize: 17.0,
                  color: selectedColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCanvas() async {
    RenderRepaintBoundary boundary =
        canvasKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    //Request permissions if not already granted
    if (!(await Permission.storage.status.isGranted))
      await Permission.storage.request();

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 100,
        name: '${DateTime.now()}');
    print(result);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  @override
  Widget build(BuildContext context) {
    // ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paint to Print'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(color: Theme.of(context).primaryColor),

          /// background gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              // color: Colors.white,
              gradient: const SweepGradient(
                colors: [
                  Color(0xFFFDFF8F),
                  Color(0xFFF4E185),
                  Color(0xFFFFFEA9),
                ],
                tileMode: TileMode.decal,
                // begin: Alignment.topCenter,
                // end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// column ----> canvas & row --> color picker, slider, clear canvas
          Center(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(flex: 1, child: SizedBox(height: 10.0)),

                  /// canvas
                  Flexible(
                    flex: 18,
                    child: Container(
                      width: width * 0.90,
                      height: height * 0.90,
                      child: Card(
                        elevation: 10.0,
                        shadowColor: Colors.purpleAccent.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: GestureDetector(
                          // onPanDown: (details) {
                          //   setState(() {
                          //     points.add(
                          //       DrawingArea(
                          //         point: details.localPosition,
                          //         areaPaint: Paint()
                          //           ..color = selectedColor
                          //           ..strokeWidth = strokeWidth
                          //           ..isAntiAlias = true
                          //           ..strokeCap = StrokeCap.round,
                          //       ),
                          //     );
                          //   });
                          // },
                          onPanUpdate: (details) {
                            setState(() {
                              points.add(
                                DrawingArea(
                                  point: details.localPosition,
                                  areaPaint: Paint()
                                    ..color = selectedColor
                                    ..strokeWidth = strokeWidth
                                    ..isAntiAlias = true
                                    ..strokeCap = StrokeCap.round,
                                ),
                              );
                            });
                          },
                          onPanStart: (details) {
                            setState(() {
                              points.add(
                                DrawingArea(
                                  point: details.localPosition,
                                  areaPaint: Paint()
                                    ..strokeCap = StrokeCap.round
                                    ..isAntiAlias = true
                                    ..color = selectedColor
                                    ..strokeWidth = strokeWidth,
                                ),
                              );
                            });
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
                                    size: Size.infinite,
                                    painter:
                                        OwnCustomPainter(pointsList: points),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Flexible(flex: 1, child: SizedBox(height: 10.0)),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        key: floatingActionButtonKey,
        fabButtons: <Widget>[
          clearCanvasFloatingAction(),
          chooseStrokeWidthFloatingAction(),
          chooseColorFloatingAction(),
          saveCanvasFloatingAction(),
        ],
        colorStartAnimation: Theme.of(context).primaryColor,
        colorEndAnimation: Colors.redAccent.shade100,
        animatedIconData: AnimatedIcons.menu_close,
      ),
    );
  }
}

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({this.point, this.areaPaint});
}
