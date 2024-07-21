import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class AuthService {
  final String baseUrl =
      "http://10.0.2.2:8000"; // Update this to your Django server URL

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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['access'];
      final refreshToken = data['refresh'];

      // Retrieve user details
      final userDetailsUrl = Uri.parse('$baseUrl/user_details/');
      final userDetailsResponse = await http.get(
        userDetailsUrl,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (userDetailsResponse.statusCode == 200) {
        final userDetails = jsonDecode(userDetailsResponse.body);
        final userName = userDetails['name'];
        final userProfilePicture = userDetails['profile_picture'];

        // Store the tokens and user information securely
        await storage.write(key: 'access_token', value: accessToken);
        await storage.write(key: 'refresh_token', value: refreshToken);
        await storage.write(key: 'user_name', value: userName);
        await storage.write(
            key: 'user_profile_picture', value: userProfilePicture);
      }
    } else {
      // Handle login failure
      print('Login failed: ${response.body}');
      throw Exception('Login failed');
    }
  }
}





/*/*


*import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../models/user.dart'; // Import the user model

class UserService {
  final String baseUrl = 'http://10.0.2.2:8000/users/create_user';

  Future<User?> createUser(User user) async {
    final url = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', url);

    request.fields['name'] = user.name;
    request.fields['email'] = user.email;
    request.fields['password'] = user.password;
    request.fields['gender'] = user.gender;
    request.fields['marital_status'] = user.marital_status;
    request.fields['height'] = user.height.toString();
    request.fields['birthdate'] = user.birthdate;
    request.fields['family_history'] = user.family_history.toString();

    if (user.profile_picture.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_picture',
        user.profile_picture,
        filename: basename(user.profile_picture),
      ));
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(responseData.body);
      return User.fromJson(data);
    } else {
      final responseData = await http.Response.fromStream(response);
      print('Failed to create user. Status code: ${response.statusCode}');
      print('Response body: ${responseData.body}');
      throw Exception('Failed to create user');
    }
  }
}
*/ */