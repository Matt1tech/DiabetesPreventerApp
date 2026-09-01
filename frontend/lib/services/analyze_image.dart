import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import '../urls.dart';

const _secureStorage = FlutterSecureStorage();

Future<File> resizeImage(File imageFile, int maxSizeInBytes) async {
  // Read image from file
  Uint8List imageBytes = await imageFile.readAsBytes();
  img.Image image = img.decodeImage(imageBytes)!;

  // Resize image until it fits the size limit
  int quality = 50;
  int step = 8; // Step to reduce quality in each iteration

  while (imageBytes.lengthInBytes > maxSizeInBytes && quality > 0) {
    // Reduce the image dimensions aggressively
    img.Image resized = img.copyResize(image,
        width: (image.width * 0.5).toInt(),
        height: (image.height * 0.5).toInt());

    // Encode resized image to JPEG with reduced quality
    imageBytes = Uint8List.fromList(img.encodeJpg(resized, quality: quality));
    quality -= step;

    // Update the image for further resizing if necessary
    image = resized;
  }

  // Save resized image to temporary file
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  File resizedFile = File('$tempPath/resized_image.jpg');
  await resizedFile.writeAsBytes(imageBytes, flush: true);

  return resizedFile;
}

Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
  final url = Uri.parse('$baseUrl/analyze-food-image/');
  final accessToken = await _secureStorage.read(key: 'access_token');
  if (accessToken == null) {
    throw Exception('Authentication is required.');
  }

  // Resize the image to be under 6 MB
  File resizedImage = await resizeImage(imageFile, 4 * 1024 * 1024);

  try {
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..files
          .add(await http.MultipartFile.fromPath('image', resizedImage.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return json.decode(responseData);
    } else {
      throw Exception(
          'Failed to analyze image: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (_) {
    rethrow;
  }
}
