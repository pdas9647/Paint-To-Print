import 'package:flutter/material.dart';
import 'package:paint_to_print/screens/home_screen.dart';

import 'screens/canvas/canvas_view_screen.dart';

class HomeScreenCanvasPageView extends StatefulWidget {
  const HomeScreenCanvasPageView({Key key}) : super(key: key);

  @override
  _HomeScreenCanvasPageViewState createState() =>
      _HomeScreenCanvasPageViewState();
}

class _HomeScreenCanvasPageViewState extends State<HomeScreenCanvasPageView> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        HomeScreen(),
        CanvasViewScreen(),
      ],
    );
  }
}
