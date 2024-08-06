import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/fetch_user_data_service.dart';
import '../utils/utilities.dart';
import '../widgets/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import 'home_page.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  List<bool> isSelectedGender = [true, false];
  List<bool> isSelectedMaritalStatus = [true, false];
  final FlutterSecureStorage storage = FlutterSecureStorage();
  XFile? _profilePicture;
  final ImagePicker _picker = ImagePicker();
  String? userName;
  String? userProfilePicture;
  String? userId;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadUserData();
  }

/*
  Future<void> _loadUserInfo() async {
    final userInfo = await loadUserInfo();
    setState(() {
      _nameController.text = userInfo['userName'] ?? '';
      _emailController.text = userInfo['userEmail'] ?? ''; // Set email here
      _dateController.text = userInfo['userBirthdate'] ?? '';
      _heightController.text = userInfo['userHeight'] ?? '';
      isSelectedGender =
          userInfo['userGender'] == 'Male' ? [true, false] : [false, true];
      isSelectedMaritalStatus = userInfo['userMaritalStatus'] == 'Married'
          ? [true, false]
          : [false, true];
      _profilePicture = userInfo['userProfilePicture'] != null
          ? XFile(userInfo['userProfilePicture']!)
          : null;
      userName = userInfo['userName'];
      userProfilePicture = userInfo['userProfilePicture'];
      userId = userInfo['userId'];
      userEmail = userInfo['userEmail'];
    });
  }
/*
  Future<Map<String, String?>> loadUserInfo() async {
    final userJson = await storage.read(key: 'user_data');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      final userName = userMap['name'];
      final userEmail = userMap['email'];
      final userBirthdate = userMap['birthdate'];
      final userHeight = userMap['height'];
      final userGender = userMap['gender'];
      final userMaritalStatus = userMap['marital_status'];
      final userProfilePicture = userMap['profile_picture'] != null
          ? 'http://10.0.2.2:8000/media/${userMap['profile_picture']}'
          : null;
      final userId = userMap['id'].toString();
      return {
        'userName': userName,
        'userEmail': userEmail,
        'userBirthdate': userBirthdate,
        'userHeight': userHeight,
        'userGender': userGender,
        'userMaritalStatus': userMaritalStatus,
        'userProfilePicture': userProfilePicture,
        'userId': userId,
      };
    } else {
      return {
        'userName': null,
        'userEmail': null,
        'userBirthdate': null,
        'userHeight': null,
        'userGender': null,
        'userMaritalStatus': null,
        'userProfilePicture': null,
        'userId': null,
      };
    }
  }
  */
*/
  Future<void> _loadUserInfo() async {
    final userInfo = await loadUserInfo();
    if (mounted) {
      setState(() {
        userName = userInfo['userName'];
        userProfilePicture = userInfo['userProfilePicture'];
        userEmail = userInfo['userEmail'];
      });
    }
  }

  Future<void> _loadUserData() async {
    final userName = await storage.read(key: 'user_name');
    final userEmail = await storage.read(key: 'email');
    if (mounted) {
      setState(() {
        this.userName = userName;
        this.userEmail = userEmail;
        userProfilePicture = userProfilePicture;
      });
    }
  }

  Future<void> _pickProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePicture = image;
    });
  }

  void _removeProfilePicture() {
    setState(() {
      _profilePicture = null;
      userProfilePicture = null; // Also clear the userProfilePicture
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      // Collect current password from the user for confirmation
      String currentPassword = await _promptForPassword();

      // Existing code for collecting update details
      String userId = (await storage.read(key: 'user_id'))!;
      String name = _nameController.text;
      String email = _emailController.text;
      String? password =
          _passwordController.text.isEmpty ? null : _passwordController.text;
      double height = double.parse(_heightController.text);
      String maritalStatus = isSelectedMaritalStatus[0] ? 'Married' : 'Single';

      var response = await AuthService().updateUserProfile(
        userId,
        name,
        email,
        password,
        height,
        maritalStatus,
        _profilePicture != null ? File(_profilePicture!.path) : null,
        currentPassword, // Pass the current password
      );

      if (response.statusCode == 200) {
        final snackBar =
            SnackBar(content: Text('Profile updated successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Update user data in storage
        final updatedUser = {
          'name': name,
          'email': email,
          'birthdate': _dateController.text,
          'height': height.toString(),
          'gender': isSelectedGender[0] ? 'Male' : 'Female',
          'marital_status': maritalStatus,
          'profile_picture':
              _profilePicture != null ? _profilePicture!.path : null,
          'id': userId,
        };
        await storage.write(key: 'user_data', value: jsonEncode(updatedUser));

        // Reload user info to reflect changes
        await _loadUserInfo(); // Ensure this is awaited
        await _loadUserData(); // Ensure this is awaited
      } else {
        final snackBar =
            SnackBar(content: Text('Update failed: ${response.body}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<String> _promptForPassword() async {
    String currentPassword = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Current Password'),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              currentPassword = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
    return currentPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 236, 236),
      appBar: AppBar(
        backgroundColor: blueColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white), // Set the color to white
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
            icon:
                Icon(Icons.add, color: Colors.white), // Set the color to white
            onPressed: _pickProfilePicture,
          ),
          IconButton(
            icon: Icon(Icons.delete,
                color: Colors.white), // Set the color to white
            onPressed: _removeProfilePicture,
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
                    onTap:
                        _pickProfilePicture, // Ensure this is the tap handler
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profilePicture != null
                          ? FileImage(File(_profilePicture!.path))
                          : (userProfilePicture != null
                              ? NetworkImage(userProfilePicture!)
                              : null) as ImageProvider?,
                      child:
                          _profilePicture == null && userProfilePicture == null
                              ? Icon(Icons.camera_alt,
                                  size: 40, color: Colors.grey[800])
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ReusableTextFormField(
                  labelText: 'Name',
                  icon: Icons.person,
                  validatorMessage: 'Must include at least 3 characters',
                  validatorFormat: RegExp(r'^.{3,}$'),
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // Do nothing on tap to ensure it remains read-only
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true, // Ensures the field is read-only
                      decoration: InputDecoration(
                        labelText: userEmail.toString(),
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                          color: const Color.fromARGB(255, 49, 47, 47),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
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
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
                          .hasMatch(value)) {
                        return 'Must include 6 numbers, a capital letter, a small letter, and a special character';
                      }
                    }
                    return null;
                  },
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
                    if (value != null && value.isNotEmpty) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Marital Status',
                  style: TextStyle(
                    fontSize: 16,
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomToggleButtons(
                  options: const ['Married', 'Single'],
                  isSelected: isSelectedMaritalStatus,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelectedMaritalStatus.length; i++) {
                        isSelectedMaritalStatus[i] = i == index;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                ReusableTextFormField(
                  labelText: 'Height',
                  icon: null,
                  validatorMessage: 'Invalid Height',
                  validatorFormat: RegExp(r'^\d+(\.\d+)?$'),
                  controller: _heightController,
                  suffixText: 'cm',
                ),
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
