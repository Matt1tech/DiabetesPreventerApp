import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/fetch_user_data_service.dart';
import '../utils/utilities.dart';
import '../widgets/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
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
  double? userHeight;

  @override
  void initState() {
    super.initState();

    _loadUserData();
    _loadUserInfo();
  }

  Future<void> _loadUserData() async {
    final userJson = await storage.read(key: 'user_data');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      if (mounted) {
        setState(() {
          userName = userMap['name'];
          userEmail = userMap['email'];
          userHeight = userMap['height'];
          userProfilePicture = userMap['profile_picture'] != null
              ? 'http://10.0.2.2:8000/media/${userMap['profile_picture']}'
              : null;
        });
      }
    }
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await loadUserInfo();
    if (mounted) {
      setState(() {
        userName = userInfo['userName'];
        userProfilePicture = userInfo['userProfilePicture'];
      });
    }
  }

  Future<void> _pickProfilePicture() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profile Picture'),
          content: const Text(
              'Would you like to update or remove your profile picture?',
              style: TextStyle(color: pinkColor)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _removeProfilePicture(); // Call the remove method
              },
              child: const Text('Remove', style: TextStyle(color: pinkColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery); // Pick new image
                if (image != null) {
                  setState(() {
                    _profilePicture = image;
                  });
                }
              },
              child: const Text('Update', style: TextStyle(color: blueColor)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without doing anything
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _removeProfilePicture() async {
    setState(() {
      _profilePicture = null;
      userProfilePicture = null; // Also clear the userProfilePicture
    });
    await storage.write(
        key: 'user_profile_picture', value: userProfilePicture!);
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
      String currentPassword = await _promptForPassword();

      if (currentPassword.isEmpty) {
        final snackBar =
            SnackBar(content: Text('Current password is required.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      String userId = (await storage.read(key: 'user_id'))!;
      Map<String, String> updatedFields = {};

      if (_nameController.text.isNotEmpty) {
        updatedFields['name'] = _nameController.text;
      }
      if (_passwordController.text.isNotEmpty) {
        updatedFields['password'] = _passwordController.text;
      }
      if (_heightController.text.isNotEmpty) {
        updatedFields['height'] = _heightController.text;
      }
      updatedFields['marital_status'] =
          isSelectedMaritalStatus[0] ? 'Married' : 'Single';
      updatedFields['current_password'] = currentPassword;

      bool removeProfilePicture =
          _profilePicture == null && userProfilePicture == null;

      var response = await AuthService().updateUserProfile(
        userId,
        updatedFields,
        _profilePicture != null ? File(_profilePicture!.path) : null,
        removeProfilePicture,
      );

      if (response.statusCode == 200) {
        final updatedUser = jsonDecode(response.body);

        setState(() {
          if (updatedFields.containsKey('name')) {
            userName = updatedFields['name'];
          }
          if (updatedFields.containsKey('password')) {
            // Handle any specific UI updates for password change if needed
          }
          if (updatedFields.containsKey('height')) {
            userHeight = double.tryParse(updatedFields['height']!);
          }
          userProfilePicture = _profilePicture != null
              ? _profilePicture!.path
              : (removeProfilePicture ? null : userProfilePicture);
          isSelectedMaritalStatus = [
            updatedFields['marital_status'] == 'Married',
            updatedFields['marital_status'] == 'Single'
          ];
        });

        await storage.write(key: 'user_name', value: userName!);
        await storage.write(
            key: 'user_profile_picture', value: userProfilePicture ?? '');
        await storage.write(key: 'user_data', value: jsonEncode(updatedUser));

        final snackBar =
            SnackBar(content: Text('Profile updated successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final errorResponse = jsonDecode(response.body);
        final snackBar =
            SnackBar(content: Text('Update failed: ${errorResponse['error']}'));
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
          title: Text('Enter Current Password',
              style: TextStyle(color: pinkColor)),
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(currentPassword);
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
    ImageProvider<Object> imageProvider =
        getImageProvider(_profilePicture, userProfilePicture);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
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
        title: Text(
          'Update Profile',
          style: TextStyle(color: Colors.white),
        ),
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
                    onTap: _pickProfilePicture, // Shows dialog with options
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          userProfilePicture != null ? imageProvider : null,
                      // Use ImageProvider if userProfilePicture is not null, else null
                      child: (_profilePicture == null &&
                              userProfilePicture == null)
                          ? Icon(Icons.camera_alt,
                              size: 40, color: Colors.grey[800])
                          : null, // Show icon if there's no image
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ReusableTextFormField(
                  labelText: 'Name',
                  icon: Icons.person,
                  validatorMessage:
                      'Must include at least 3 characters if provided',
                  validatorFormat: RegExp(r'^.{3,}$'),
                  controller: _nameController,
                  validator: (value) {
                    // If the value is not empty, check for at least 3 characters
                    if (value != null &&
                        value.isNotEmpty &&
                        !RegExp(r'^.{3,}$').hasMatch(value)) {
                      return 'Must include at least 3 characters';
                    }
                    return null; // Allow the field to be empty
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _emailController,
                      readOnly: true, // Ensures the field is read-only
                      decoration: InputDecoration(
                        labelText: userEmail,
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
                        return 'Must have 6 No, a capital letter, a small letter, and a special character';
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
                  icon: Icons.height,
                  validatorMessage: 'Invalid Height',
                  validatorFormat: RegExp(r'^\d+(\.\d+)?$'),
                  controller: _heightController,
                  suffixText: 'cm',
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                      return 'Invalid Height';
                    }
                    return null; // Allow empty values
                  },
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
