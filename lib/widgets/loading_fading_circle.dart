import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingFadingCircle extends StatelessWidget {
  const LoadingFadingCircle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitFadingCircle(
          color: Theme.of(context).primaryColor,
          size: 200.0,
        ),
      ),
    );
  }
}
