import 'package:flutter/material.dart';

class Constants {
  static MediaQueryData mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double borderSize = 2;
  static int mnistImageSize = 28;
  static double strokeWidth = 8;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth;
    blockSizeVertical = screenHeight;
  }
}
