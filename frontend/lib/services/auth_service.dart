import 'dart:convert';
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
