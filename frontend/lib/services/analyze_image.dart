import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

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
  resizedFile.writeAsBytesSync(imageBytes);

  return resizedFile;
}

Future<Map<String, dynamic>> analyzeImage(File imageFile, String apiKey) async {
  final url = "https://vision.foodvisor.io/api/1.0/en/analysis/";
  final headers = {"Authorization": "Api-Key $apiKey"};

  // Resize the image to be under 6 MB
  File resizedImage = await resizeImage(imageFile, 629100); // 6 MB

  try {
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..files
          .add(await http.MultipartFile.fromPath('image', resizedImage.path));

    print('Sending request to $url');
    print('Headers: $headers');
    print('File path: ${resizedImage.path}');

    final response = await request.send();

    print('Response status: ${response.statusCode}');
    print('Response reason: ${response.reasonPhrase}');

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      print('Response data: $responseData');
      return json.decode(responseData);
    } else {
      final errorData = await response.stream.bytesToString();
      print('Error response: $errorData');
      throw Exception(
          'Failed to analyze image: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Exception during request: $e');
    throw e;
  }
}
