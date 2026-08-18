import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/disease_result.dart';
import 'api_service.dart';

class DiseaseService {
  Future<DiseaseResult> predictDisease({
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    final uri = Uri.parse(ApiService.predictDisease);

    try {
      // Detect MIME type from filename.
      final extension = fileName
          .split('.')
          .last
          .toLowerCase();

      MediaType contentType;

      switch (extension) {
        case 'jpg':
        case 'jpeg':
          contentType = MediaType('image', 'jpeg');
          break;

        case 'png':
          contentType = MediaType('image', 'png');
          break;

        case 'webp':
          contentType = MediaType('image', 'webp');
          break;

        default:
          throw Exception(
            'Unsupported image format: .$extension. '
            'Please select JPG, JPEG, PNG, or WEBP.',
          );
      }

      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: fileName,
          contentType: contentType,
        ),
      );

      print('Sending image: $fileName');
      print('Image size: ${imageBytes.length} bytes');
      print('Content type: $contentType');

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      print('Status code: ${response.statusCode}');
      print('Backend response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)
            as Map<String, dynamic>;

        return DiseaseResult.fromJson(data);
      }

      String message = 'Disease prediction failed';

      try {
        final data = jsonDecode(response.body);

        message =
            data['detail']?.toString() ??
            message;
      } catch (_) {}

      throw Exception(
        '$message (${response.statusCode})',
      );
    } catch (error) {
      throw Exception(
        'Cannot connect to AI backend: $error',
      );
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiService.health),
          )
          .timeout(
            const Duration(seconds: 5),
          );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}