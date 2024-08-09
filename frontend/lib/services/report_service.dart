import 'dart:convert';
import 'package:http/http.dart' as http;
import '../urls.dart';

class ReportService {
  static Future<List<Map<String, dynamic>>> fetchActivityReport(
      String userId, String startDate, String endDate) async {
    // Directly construct the URL without using a token
    final url = Uri.parse(
        '$baseUrl/activity_report/$userId/?start_date=$startDate&end_date=$endDate');

    // Making the HTTP GET request
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['report']);
    } else {
      throw Exception('Failed to load activity report');
    }
  }
}
