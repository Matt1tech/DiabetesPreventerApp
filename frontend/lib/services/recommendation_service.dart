import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../urls.dart';

class RecommendationService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> fetchRecommendations() async {
    final userId = await _storage.read(key: 'user_id');
    final response =
        await http.get(Uri.parse('$baseUrl/user_recommendations/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('Recommendations fetched successfully: $data'); // Debugging
      return data.map((item) {
        return {
          'name': item['name'],
          'imageUrl': item['image_url'],
          'recipe': item['recipe'],
          'carbs': item['carbs'],
          'fat': item['fat'],
          'protein': item['protein'],
          'fiber': item['fiber'],
          'category': item['category'],
          'total_calories': item['total_calories'],
        };
      }).toList();
    } else {
      print('Failed to load recommendations: ${response.statusCode}');
      print('Response body: ${response.body}'); // Debugging
      return [];
    }
  }
}
