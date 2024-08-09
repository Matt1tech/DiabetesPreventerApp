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

  static Future<Map<String, dynamic>> fetchRiskSummaryReport(
      String userId, String startDate, String endDate) async {
    final url = Uri.parse(
        '$baseUrl/risk_summary_report/$userId/?start_date=$startDate&end_date=$endDate');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // The response should include both 'summary' and 'all_probabilities'
      return {
        'summary': Map<String, dynamic>.from(data['summary']),
        'all_probabilities':
            List<Map<String, dynamic>>.from(data['all_probabilities'])
      };
    } else {
      throw Exception('Failed to load risk summary report');
    }
  }

  static Future<Map<String, dynamic>> fetchHealthSummaryReport(
      String userId, String startDate, String endDate) async {
    final url = Uri.parse(
        '$baseUrl/health_summary_report/$userId/?start_date=$startDate&end_date=$endDate');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Map<String, dynamic>.from(data);
    } else {
      throw Exception('Failed to load health summary report');
    }
  }
}
