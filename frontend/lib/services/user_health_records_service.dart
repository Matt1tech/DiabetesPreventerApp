import 'dart:convert';
import 'package:http/http.dart' as http;

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
