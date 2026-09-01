import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../urls.dart';
import 'api_client.dart';

class MealRecordsService {
  static Future<void> submitMealData(Meal meal) async {
    final url = Uri.parse('$baseUrl/create_meal/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(meal.toJson());

    try {
      final response = await ApiClient.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Meal data submitted successfully');
      } else {
        throw Exception('Failed to submit meal data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting meal data: $e');
      rethrow; // Rethrow the exception so it can be caught in the calling function
    }
  }
}
