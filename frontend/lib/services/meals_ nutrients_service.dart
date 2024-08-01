import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchMealsNutrientsService {
  static const _baseUrl = 'http://10.0.2.2:8000/total_daily_nutrition/';

  Future<Map<String, dynamic>?> fetchMealsNutrients(int userId) async {
    print(
        'FetchMealsNutrientsService.fetchMealsNutrients called with userId: $userId');
    try {
      final url = Uri.parse('$_baseUrl$userId/');
      print('Requesting URL: $url');
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Parsed JSON data: $data');
        return data;
      } else {
        print('Error fetching MealsNutrients: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception in fetchMealsNutrients: $e');
      return null;
    }
  }
}
