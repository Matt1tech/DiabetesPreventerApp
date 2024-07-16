import 'dart:convert';
import 'package:http/http.dart' as http;

class DataPresentationService {
  final String baseUrl = 'http://10.0.2.2:8000/api/auth/';

  Future<Map<String, dynamic>> fetchDailyRecords(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl + 'daily-records/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load daily records: ${response.body}');
    }
  }
}
