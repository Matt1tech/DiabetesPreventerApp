import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../urls.dart';

class MealRecordsService {
  static Future<void> submitMealData(Meal meal) async {
    final url = Uri.parse('$baseUrl/create_meal/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(meal.toJson());

    try {
      print('Sending POST request to: $url');
      print('Request body: $body');

      final response = await http.post(url, headers: headers, body: body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Meal data submitted successfully');
      } else {
        throw Exception(
            'Failed to submit meal data: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting meal data: $e');
      rethrow; // Rethrow the exception so it can be caught in the calling function
    }
  }
}
