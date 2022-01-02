import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint_to_print/screens/canvas/canvas_view_screen.dart';

class OwnCustomPainter extends CustomPainter {
  OwnCustomPainter({this.pointsList});

  //Keep track of the points tapped on the screen
  List<DrawingArea> pointsList;
  List<Offset> offsetPoints = [];

  //This is where we can draw on canvas.
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        //Drawing line when two consecutive points are available
        canvas.drawLine(pointsList[i].point, pointsList[i + 1].point,
            pointsList[i].areaPaint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].point);
        offsetPoints.add(
            Offset(pointsList[i].point.dx + 0.1, pointsList[i].point.dy + 0.1));

        //Draw points when two points are not next to each other
        canvas.drawPoints(
            PointMode.points, offsetPoints, pointsList[i].areaPaint);
      }
    }
  }

  //Called when CustomPainter is rebuilt.
  //Returning true because we want canvas to be rebuilt to reflect new changes.
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
