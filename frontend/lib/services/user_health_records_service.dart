import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../models/monthly_risk.dart';
import '../urls.dart';

class UserHealthRecordsService {
  static Future<void> inputBloodGlucose(int userId, int bloodGlucose) async {
    final url = Uri.parse('$baseUrl/health-record/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'blood_glucose': bloodGlucose,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Blood glucose data submitted successfully');
      } else {
        print(
            'Failed to submit blood glucose data: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting blood glucose data: $e');
    }
  }

  static Future<void> inputBloodPressure(int userId, int bloodPressure) async {
    final url = Uri.parse('$baseUrl/health-record/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'blood_pressure': bloodPressure,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Blood pressure data submitted successfully');
      } else {
        print(
            'Failed to submit blood pressure data: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting blood pressure data: $e');
    }
  }

  static Future<void> inputDailyWeight(int userId, int weight) async {
    final url = Uri.parse('$baseUrl/health-record/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'weight': weight,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Daily Weight submitted successfully');
      } else {
        print(
            'Failed to submit Daily Weight: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting Daily Weight: $e');
    }
  }
}

class FetchHealthRecordService {
  Future<HealthRecord?> fetchLastHealthRecord(int userId) async {
    print(
        'FetchHealthRecordService.fetchLastHealthRecord called with userId: $userId');
    try {
      final url = Uri.parse('$baseUrl/health-record/last/$userId');
      print('Requesting URL: $url');
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Parsed JSON data: $data');
        return HealthRecord.fromJson(data);
      } else {
        print('Error fetching health record: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception in fetchLastHealthRecord: $e');
      return null;
    }
  }
}

class RiskService {
  static Future<List<MonthlyRisk>> fetchMonthlyRisk(int userId) async {
    final url = Uri.parse('$baseUrl/monthly_risk/$userId');
    print('Requesting URL: $url');

    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Parsed JSON data: $data');
        print('Response body: ${response.body}');

        return data.map((json) => MonthlyRisk.fromJson(json)).toList();
      } else {
        print('Error fetching monthly risk data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception in fetchMonthlyRisk: $e');
      return [];
    }
  }
}
