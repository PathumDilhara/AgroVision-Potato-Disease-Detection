class PredictionResult {
  final String predictedClass;
  final double confidence;

  PredictionResult({required this.predictedClass, required this.confidence});

  // Empty model
  factory PredictionResult.empty() {
    return PredictionResult(predictedClass: "", confidence: 0.0);
  }

  // Json to dart
  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictedClass: json["class"] ?? "",
      confidence: json["confidence"] ?? 0.0,
    );
  }

  bool get isEmpty => predictedClass.isEmpty && confidence == 0.0;
}
