class PredictionResult {
  final String predictedClass;
  final String confidence;

  PredictionResult({required this.predictedClass, required this.confidence});

  // Empty model
  factory PredictionResult.empty() {
    return PredictionResult(
      predictedClass: "",
      confidence: "",
    );
  }

  // Json to dart
  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictedClass: json["class"] ?? "",
      confidence: json["confidence"] ?? "",
    );
  }

  bool get isEmpty =>
      predictedClass.isEmpty && confidence.isEmpty;

}
