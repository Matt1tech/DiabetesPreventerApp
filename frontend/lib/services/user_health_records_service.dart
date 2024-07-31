import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class UserHealthRecordsService {
  static const String _baseUrl =
      'http://10.0.2.2:8000/health-record/'; // Replace with your actual endpoint URL

  static Future<void> inputBloodGlucose(int userId, int bloodGlucose) async {
    final url = Uri.parse(_baseUrl);
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

  static Future<void> inputBloodPressure(
      int userId, String bloodPressure) async {
    final url = Uri.parse(_baseUrl);
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
}

class FetchHealthRecordService {
  static const _baseUrl = 'http://10.0.2.2:8000/health-record/last';

  Future<HealthRecord?> fetchLastHealthRecord(int userId) async {
    print(
        'FetchHealthRecordService.fetchLastHealthRecord called with userId: $userId');
    try {
      final url = Uri.parse('$_baseUrl/$userId');
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
