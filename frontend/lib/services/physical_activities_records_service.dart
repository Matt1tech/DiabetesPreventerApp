// physical_activity_records.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../urls.dart';

class PhysicalActivityRecordsService {
  Future<bool> submitExerciseRecord(
      String userId, String type, double duration) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/physical_record/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'duration': duration,
          'type': type,
        }),
      );

      if (response.statusCode == 200) {
        print('Record submitted successfully');
        return true; // success
      } else {
        print('Failed to submit record');
        return false; // failure
      }
    } catch (e) {
      print('Error submitting record: $e');
      return false; // error
    }
  }

  Future<bool> submitStressLevel(String userId, int stressLevel) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/physical_record/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'stress_level': stressLevel,
        }),
      );

      if (response.statusCode == 200) {
        print('Stress level submitted successfully');
        return true;
      } else {
        print('Failed to submit stress level');
        return false;
      }
    } catch (e) {
      print('Error submitting stress level: $e');
      return false;
    }
  }
}
