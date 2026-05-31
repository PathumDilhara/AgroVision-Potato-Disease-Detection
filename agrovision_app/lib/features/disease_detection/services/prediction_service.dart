import 'dart:convert';
import 'dart:io';

import 'package:agrovision_app/features/disease_detection/models/prediction_result.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants.dart';

class PredictionService {
  Future<PredictionResult> getPrediction(File imageFile) async {
    try {
      final url = Uri.parse(kPredictingUrl);

      final request = http.MultipartRequest('POST', url);

      request.files.add(
        await http.MultipartFile.fromPath("file", imageFile.path),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        //print(body);

        final Map<String, dynamic> data = jsonDecode(body);
        PredictionResult result = PredictionResult.fromJson(data);
        return result;
      } else {
        //print("Request failed: ${response.statusCode}");
        return PredictionResult.empty();
      }
    } catch (err) {
      //print("Error : $err");
      return PredictionResult.empty();
    }
  }
}
