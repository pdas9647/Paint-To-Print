class PredictionModel {
  final double confidence;
  final int index;
  final String label;

  PredictionModel({this.confidence, this.index, this.label});

  factory PredictionModel.fromJson(Map<dynamic, dynamic> json) {
    return PredictionModel(
      confidence: json['confidence'],
      index: json['index'],
      label: json['label'],
    );
  }
}
