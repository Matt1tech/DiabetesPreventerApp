import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/user.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../services/data_presentation.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000/api/auth/';

  Future<void> register(
      String name,
      String email,
      String password,
      String gender,
      String maritalStatus,
      String height,
      String birthdate,
      bool familyHistory,
      String? profilePicturePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl + 'register/'),
    );

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['gender'] = gender;
    request.fields['marital_status'] = maritalStatus;
    request.fields['height'] = height;
    request.fields['birthdate'] = birthdate;
    request.fields['family_history'] = familyHistory.toString();

    if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
      final mimeTypeData =
          lookupMimeType(profilePicturePath, headerBytes: [0xFF, 0xD8])
              ?.split('/');
      if (mimeTypeData != null && mimeTypeData.length == 2) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profilePicturePath,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));
      }
    }

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 201) {
      final data = jsonDecode(responseBody.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access', data['access'] ?? '');
      prefs.setString('refresh', data['refresh'] ?? '');
    } else {
      var responseJson = json.decode(responseBody.body);
      throw Exception('Failed to register: ${responseJson['error']}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl + 'login/'), // Adjusted API endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access', data['token']);
      /* Use DataPresentationService to fetch daily records
      try {
        DataPresentationService dataService = DataPresentationService();
        final dailyRecordsData =
            await dataService.fetchDailyRecords(data['token']);
        data['user']['daily_records'] = dailyRecordsData['daily_records'];

        if (dailyRecordsData['daily_records'].isNotEmpty) {
          data['user']['blood_glucose'] =
              dailyRecordsData['daily_records'][0]['blood_glucose'];
        } else {
          data['user']['blood_glucose'] = 'No daily records found';
        }
      } catch (e) {
        throw Exception('Failed to load daily records');
      }*/
      return data['user'];
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('refresh');
    final response = await http.post(
      Uri.parse(baseUrl + 'logout/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': token}),
    );

    if (response.statusCode == 205) {
      await prefs.remove('access');
      await prefs.remove('refresh');
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');
    final response = await http.get(
      Uri.parse(baseUrl + 'user/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
