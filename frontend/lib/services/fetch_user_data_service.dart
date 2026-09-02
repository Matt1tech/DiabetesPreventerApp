import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart' as userModel;
import '../urls.dart';

final storage = FlutterSecureStorage();

Future<Map<String, String?>> loadUserInfo() async {
  final userJson = await storage.read(key: 'user_data');
  if (userJson != null) {
    final userMap = jsonDecode(userJson);
    final user = userModel.User.fromJson(userMap);
    final userName = user.name;
    final userId = user.id;
    final email = user.email;
    final gender = user.gender;
    final profilePicture = user.profile_picture;
    final userProfilePicture = profilePicture == null || profilePicture.isEmpty
        ? null
        : '$baseUrl/media/$profilePicture';
    return {
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'user_id': userId.toString(),
      'email': email,
      'gender': gender,
    };
  } else {
    print('No user data found in storage'); // Debug statement
    return {
      'userName': null,
      'userProfilePicture': null,
      'userId': null,
      'email': null,
      'gender': null,
    };
  }
}

ImageProvider<Object> getImageProvider(
    XFile? profilePicture, String? userProfilePicture,
    {String defaultAssetPath = 'assets/images/diabetesLogo.png'}) {
  if (profilePicture != null) {
    return FileImage(File(profilePicture.path));
  } else if (userProfilePicture != null && userProfilePicture.isNotEmpty) {
    print(
        'Loading profile picture from network: $userProfilePicture'); // Debug statement
    return NetworkImage(userProfilePicture);
  } else {
    return AssetImage(defaultAssetPath);
  }
}
