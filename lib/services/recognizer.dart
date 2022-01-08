import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint_to_print/screens/canvas/canvas_view_screen.dart';
import 'package:paint_to_print/utils/constants.dart';
import 'package:tflite/tflite.dart';

final _whitePaint = Paint()
  ..strokeCap = StrokeCap.round
  ..color = Colors.white
  ..strokeWidth = CanvasViewScreen(
    isNavigatedFromHomeScreen: false,
    isNavigatedFromPdfImagesScreen: false,
    pdfModel: null,
  ).strokeWidth
  ..filterQuality = FilterQuality.high;

final _bgPaint = Paint()..color = Colors.black;

class Recognizer {
  Future loadModel() {
    Tflite.close();

    return Tflite.loadModel(
      model: "assets/ml_models/mnist.tflite",
      labels: "assets/ml_models/mnist.txt",
    );
  }

  dispose() {
    Tflite.close();
  }

  // Future<Uint8List> previewImage(
  //     BuildContext context, List<DrawingArea> points) async {
  //   final picture = pointsToPicture(context, points);
  //   final image = await picture.toImage(
  //     Constants.mnistImageSize,
  //     Constants.mnistImageSize,
  //   );
  //   var pngBytes = await image.toByteData(format: ImageByteFormat.png);
  //   return pngBytes.buffer.asUint8List();
  // }

  Future recognize(BuildContext context, List<DrawingArea> points) async {
    final picture = pointsToPicture(context, points);
    Uint8List bytes =
        await imageToByteListUint8(picture, Constants.mnistImageSize);
    return _predict(bytes);
  }

  Future _predict(Uint8List bytes) {
    return Tflite.runModelOnBinary(binary: bytes);
  }

  Future<Uint8List> imageToByteListUint8(Picture pic, int size) async {
    final img = await pic.toImage(size, size);
    final imgBytes = await img.toByteData();
    final resultBytes = Float32List(size * size);
    final buffer = Float32List.view(resultBytes.buffer);
    int index = 0;
    for (int i = 0; i < imgBytes.lengthInBytes; i += 4) {
      final r = imgBytes.getUint8(i);
      final g = imgBytes.getUint8(i + 1);
      final b = imgBytes.getUint8(i + 2);
      buffer[index++] = (r + g + b) / 3.0 / 255.0;
    }
    return resultBytes.buffer.asUint8List();
  }

  Picture pointsToPicture(BuildContext context, List<DrawingArea> points) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder)
      ..scale(
          Constants.mnistImageSize / Constants.blockSizeHorizontal * 0.90,
          Constants.mnistImageSize /
              (Constants.blockSizeVertical * 0.90 -
                  kBottomNavigationBarHeight * 2));
    canvas.drawRect(
        Rect.fromLTWH(
          0,
          0,
          // MediaQuery.of(context).size.width.toDouble(),
          // MediaQuery.of(context).size.height.toDouble(),
          Constants.blockSizeHorizontal * 0.90,
          Constants.blockSizeVertical * 0.90 - kBottomNavigationBarHeight * 2,
        ),
        _bgPaint);
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i].point, points[i + 1].point, _whitePaint);
      }
    }
    return recorder.endRecording();
  }
}
