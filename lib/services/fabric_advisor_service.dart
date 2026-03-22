import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/fabric_advisor/fabric_prediction_model.dart';
import 'package:flutter/foundation.dart';

class FabricAdvisorService {
  String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://localhost:8000';
    }
    return 'http://localhost:8000';
  }

  Future<FabricPrediction> predictFabric({
    required File image,
    String? description,
  }) async {
    var uri = Uri.parse('$_baseUrl/predict');
    var request = http.MultipartRequest('POST', uri);
    
    request.headers.addAll({
      'accept': 'application/json',
    });

    String ext = image.path.split('.').last.toLowerCase();
    String subType = 'jpeg';
    if (ext == 'png') {
      subType = 'png';
    } else if (ext == 'heic') {
      subType = 'heic';
    } else if (ext == 'jpg' || ext == 'jpeg') {
      subType = 'jpeg';
    }

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType('image', subType),
    ));

    if (description != null && description.isNotEmpty) {
      request.fields['description'] = description;
    }

    request.fields['return_details'] = 'true';

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        return FabricPrediction.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to get prediction. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred during prediction: $e');
    }
  }
}
