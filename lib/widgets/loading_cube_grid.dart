import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingCubeGrid extends StatelessWidget {
  const LoadingCubeGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitCubeGrid(
          color: Theme.of(context).colorScheme.primary,
          // size: 50.0,
        ),
      ),
    );
  }
}
