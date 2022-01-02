import 'package:flutter/material.dart';
import 'package:paint_to_print/models/prediction_model.dart';

class PredictionWidget extends StatelessWidget {
  final List<PredictionModel> predictions;

  const PredictionWidget({Key key, this.predictions}) : super(key: key);

  Widget _numberWidget(int num, PredictionModel prediction) {
    return Column(
      children: <Widget>[
        Text(
          '$num',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.red.withOpacity(
                    (prediction.confidence * 2).clamp(0, 1).toDouble(),
                  ),
          ),
        ),
        Text(
          '${prediction == null ? '' : prediction.confidence.toStringAsFixed(3)}',
          style: TextStyle(fontSize: 12.0),
        )
      ],
    );
  }

  List<dynamic> getPredictionStyles(List<PredictionModel> predictions) {
    List<dynamic> data = [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ];
    predictions?.forEach((prediction) {
      data[prediction.index] = prediction;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    var styles = getPredictionStyles(this.predictions);

    return Flexible(
      // TODO: REMOVE flex: 10
      flex: 10,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [for (var i = 0; i < 5; i++) _numberWidget(i, styles[i])],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [for (var i = 5; i < 9; i++) _numberWidget(i, styles[i])],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_numberWidget(9, styles[9])],
          ),
        ],
      ),
    );
  }
}
