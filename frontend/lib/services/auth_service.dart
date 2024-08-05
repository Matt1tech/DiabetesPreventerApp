import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../urls.dart';

final storage = FlutterSecureStorage();

class AuthService {
  /// Registers a new user with the given information.
  ///
  /// [name]: User's name
  /// [email]: User's email address
  /// [password]: User's password
  /// [gender]: User's gender
  /// [maritalStatus]: User's marital status
  /// [height]: User's height
  /// [birthdate]: User's birth date
  /// [familyHistory]: Boolean indicating family history of diabetes
  /// [profilePicture]: Optional profile picture file
  ///
  /// Returns the HTTP response from the server.
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

  /// Logs in a user with the given email and password.
  ///
  /// [email]: User's email address
  /// [password]: User's password
  ///
  /// Stores the access token, refresh token, user name, profile picture, user ID, and user data in secure storage.
  /// Throws an exception if login fails.
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
      final user = data['user'];
      final profilePicture = user['profile_picture'];

      // Store the tokens and user information securely
      await storage.write(key: 'access_token', value: accessToken);
      await storage.write(key: 'refresh_token', value: refreshToken);
      await storage.write(key: 'user_name', value: user['name']);
      await storage.write(key: 'user_profile_picture', value: profilePicture);
      await storage.write(key: 'user_id', value: user['id'].toString());
      await storage.write(key: 'user_data', value: jsonEncode(user));

      print('Stored user_name: ${user['name']}');
    } else {
      print('Login failed: ${response.body}');
      throw Exception('Login failed');
    }
  }

  /// Logs out the user.
  ///
  /// Sends a request to the server to invalidate the refresh token and clears all stored data from secure storage.
  Future<void> logout() async {
    try {
      final refreshToken = await storage.read(key: 'refresh_token');
      if (refreshToken != null) {
        final url = Uri.parse('$baseUrl/logout/');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'refresh': refreshToken,
          }),
        );

        if (response.statusCode != 205) {
          throw Exception('Failed to logout from server');
        }
      }
    } catch (e) {
      // Handle any errors that might occur during the HTTP request
      print('Logout error: $e');
    }
    // Always clear the local storage
    await storage.deleteAll();
  }

  Future<http.Response> updateUserProfile(String userId, String password,
      double height, String maritalStatus, File? profilePicture) async {
    var uri = Uri.parse('$baseUrl/update_user/');
    var request = http.MultipartRequest('PUT', uri)
      ..fields['user_id'] = userId
      ..fields['password'] = password
      ..fields['height'] = height.toString()
      ..fields['marital_status'] = maritalStatus;

    if (profilePicture != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'profile_picture', profilePicture.path));
    }

    var response = await request.send();
    return await http.Response.fromStream(response);
  }

  /// Sends a password reset request to the server.
  ///
  /// [email]: User's email address to send the reset link to.
  ///
  /// Returns the HTTP response from the server.
  Future<http.Response> requestPasswordReset(String email) async {
    final url = Uri.parse('$baseUrl/password_reset/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );

    return response;
  }

  Future<http.Response> confirmPasswordReset(
      String uidb64, String token, String newPassword) async {
    final url = Uri.parse('$baseUrl/reset/$uidb64/$token/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'new_password': newPassword,
      }),
    );

    return response;
  }
}
