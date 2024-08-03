import 'dart:convert';
import 'package:http/http.dart' as http;
import '../urls.dart';

class UserCustomizationService {
  static Future<void> setMaxDailyCalories(int userId, int maxCalories) async {
    final url = Uri.parse('$baseUrl/update-customization/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'daily_calories_max': maxCalories,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Max daily calories set successfully');
      } else {
        print(
            'Failed to submit daily calories max: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting  daily calories max data: $e');
    }
  }
}
