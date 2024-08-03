import 'dart:convert';
import 'package:http/http.dart' as http;

import '../urls.dart';

class DataPresentationService {
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
