import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/utilities.dart';
import '../widgets/widgets.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'home_page.dart';

final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();
final _weightController = TextEditingController();

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  List<bool> isSelectedGender = [true, false];
  XFile? _profilePicture;
  final storage = FlutterSecureStorage();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await loadUserInfo();
    setState(() {
      _nameController.text = userInfo['userName'] ?? '';
      /* _emailController.text = globals.userEmail ?? '';
      _dateController.text = globals.userBirthdate ?? '';
      _heightController.text = globals.userHeight ?? '';
      _weightController.text = globals.userWeight ?? '';
      isSelectedGender =
          globals.userGender == 'Male' ? [true, false] : [false, true];
      _profilePicture = userInfo['userProfilePicture'] != null
          ? XFile(userInfo['userProfilePicture']!)
          : null;*/
    });
  }

  Future<Map<String, String?>> loadUserInfo() async {
    final userJson = await storage.read(key: 'user_data');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      print('User JSON: $userMap'); // Debug statement
      var userModel;
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

  Future<void> _pickProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePicture = image;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.toLowerCase();
      String password = _passwordController.text;
      String weight = _weightController.text;

      var response = await AuthService().updateUserProfile(
        email,
        password,
        weight,
        _profilePicture != null ? File(_profilePicture!.path) : null,
      );

      if (response.statusCode == 200) {
        final snackBar =
            SnackBar(content: Text('Profile updated successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar =
            SnackBar(content: Text('Update failed: ${response.body}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(227, 249, 243, 243),
      appBar: AppBar(
        backgroundColor: blueColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: Text('Update Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _pickProfilePicture,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: _pickProfilePicture,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profilePicture != null
                          ? FileImage(File(_profilePicture!.path))
                          : null,
                      child: _profilePicture == null
                          ? Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey[800],
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  readOnly: true, // Disable editing
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon:
                        Icon(Icons.person), // Use prefixIcon instead of icon
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 16),
                ReusableTextFormField(
                  labelText: 'Email',
                  icon: Icons.email,
                  validatorMessage: 'Please enter a valid email',
                  validatorFormat:
                      RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.\w{2,3})+$'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                ReusableTextFormField(
                  labelText: 'Password',
                  icon: Icons.lock,
                  validatorMessage:
                      'Must include 6 numbers, a capital letter, a small letter, and a special character',
                  validatorFormat: RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$'),
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ReusableTextFormField(
                  labelText: 'Confirm Password',
                  icon: Icons.lock,
                  validatorMessage: 'Passwords do not match',
                  validatorFormat: RegExp(r'^.{6,}$'),
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: ReusableTextFormField(
                        labelText: 'Weight',
                        icon: null,
                        validatorMessage: 'Invalid Weight',
                        validatorFormat: RegExp(r'^\d+(\.\d+)?$'),
                        controller: _weightController,
                        suffixText: 'kg',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(340, 50)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Color.fromARGB(255, 68, 37, 135)
                                .withOpacity(0.8);
                          } else if (states.contains(MaterialState.hovered)) {
                            return Color.fromARGB(255, 88, 71, 126)
                                .withOpacity(0.9);
                          }
                          return pinkColor;
                        },
                      ),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black12;
                          }
                          return Colors.transparent;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: _updateProfile,
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 18,
                        color: blueColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
