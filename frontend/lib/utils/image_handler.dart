import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart' as userModel;
import '../globals.dart' as globals;

final storage = FlutterSecureStorage();

Future<Map<String, String?>> loadUserInfo() async {
  final userJson = await storage.read(key: 'user_data');
  if (userJson != null) {
    final userMap = jsonDecode(userJson);
    print('User JSON: $userMap'); // Debug statement
    final user = userModel.User.fromJson(userMap);
    final userName = user.name;
    final userId = user.id;
    // Construct the full URL for the profile picture
    final userProfilePicture =
        '${'http://10.0.2.2:8000'}/media/${user.profile_picture}';
    print('User Name: $userName'); // Debug statement
    print('User Profile Picture: $userProfilePicture'); // Debug statement
    return {
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'user_id': userId.toString(),
    };
  } else {
    print('No user data found in storage'); // Debug statement
    return {
      'userName': null,
      'userProfilePicture': null,
      'userId': null,
    };
  }
}

ImageProvider<Object> getImageProvider(
    XFile? profilePicture, String? userProfilePicture,
    {String defaultAssetPath = 'assets/images/diabetesLogo.png'}) {
  if (profilePicture != null) {
    return FileImage(File(profilePicture.path));
  } else if (userProfilePicture != null) {
    print(
        'Loading profile picture from network: $userProfilePicture'); // Debug statement
    return NetworkImage(userProfilePicture);
  } else {
    return AssetImage(defaultAssetPath);
  }
}
