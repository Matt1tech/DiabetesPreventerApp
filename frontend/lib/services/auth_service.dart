import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart' as userModel;

final storage = FlutterSecureStorage();

class AuthService {
  final String baseUrl =
      "http://10.0.2.2:8000"; // Update this to  Django server URL

  Future<http.Response> registerUser(
      String name,
      String email,
      String password,
      String gender,
      String maritalStatus,
      String height,
      String birthdate,
      bool familyHistory,
      File? profilePicture) async {
    var uri = Uri.parse("$baseUrl/create_user/");
    var request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['gender'] = gender
      ..fields['marital_status'] = maritalStatus
      ..fields['height'] = height
      ..fields['birthdate'] = birthdate
      ..fields['family_history'] = familyHistory.toString();

    if (profilePicture != null) {
      var pictureStream = http.ByteStream(profilePicture.openRead());
      var pictureLength = await profilePicture.length();
      var multipartFile = http.MultipartFile(
        'profile_picture',
        pictureStream,
        pictureLength,
        filename: profilePicture.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('Login response status: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['access'];
      final refreshToken = data['refresh'];
      final user = userModel.User.fromJson(data['user']);

      // Store the tokens and user information securely
      await storage.write(key: 'access_token', value: accessToken);
      await storage.write(key: 'refresh_token', value: refreshToken);
      await storage.write(key: 'user_data', value: jsonEncode(user.toJson()));
    } else {
      // Handle login failure
      print('Login failed: ${response.body}');
      throw Exception('Login failed');
    }
  }

  Future<void> logout() async {
    final url = Uri.parse('$baseUrl/logout/');
    final accessToken = await storage.read(key: 'access_token');

    // Debugging statement to confirm token retrieval
    print('Retrieved Access Token: $accessToken');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print('Logout response status: ${response.statusCode}');
    print('Logout response body: ${response.body}');

    if (response.statusCode == 200) {
      // Clear stored tokens and user information
      await storage.delete(key: 'access_token');
      await storage.delete(key: 'refresh_token');
      await storage.delete(key: 'user_data');
    } else {
      // Handle logout failure
      print('Logout failed: ${response.body}');
      throw Exception('Logout failed');
    }
  }

  updateUserProfile(String email, String password, String weight, File? file) {}
}
