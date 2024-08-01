import 'dart:convert';
import 'package:http/http.dart' as http;

class NutritionService {
  final String baseUrl = 'http://10.0.2.2:8000';

  Future<Map<String, dynamic>> fetchDailyNutrition(int userId) async {
    final String url = '$baseUrl/total_daily_nutrition/$userId';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Include any necessary headers such as authorization tokens
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to load nutrition data: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Caught error: $e');
      throw Exception('Error fetching data');
    }
  }
}
