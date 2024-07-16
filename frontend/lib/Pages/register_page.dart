import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/utilities.dart';
import 'login_page.dart';
import '../widgets/widgets.dart';
import 'package:frontend/services/auth_service.dart';

final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();

class RegisterPage extends StatefulWidget {
  final bool familyHistory;

  const RegisterPage({Key? key, required this.familyHistory}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  List<bool> isSelectedGender = [true, false];
  List<bool> isSelectedMaritalStatus = [true, false];

  XFile? _profilePicture;
  final ImagePicker _picker = ImagePicker();
  final AuthService _authService = AuthService();

  Future<void> _pickProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePicture = image;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(227, 249, 243, 243),
      appBar: CustomHeader(
        imageProvider: _profilePicture != null
            ? FileImage(File(_profilePicture!.path))
            : null,
        imagePath: 'assets/images/diabetesLogo.png',
        welcomeMessage: 'Welcome to Diabetes Preventer!',
        showWelcomeMessage: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: pinkColor,
                    ),
                  ),
                ),
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
                ReusableTextFormField(
                  labelText: 'Name',
                  icon: Icons.person,
                  validatorMessage: 'Must include at least 3 characters',
                  validatorFormat: RegExp(r'^.{3,}$'),
                  controller: _nameController,
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
                const Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 16,
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomToggleButtons(
                  options: const ['Male', 'Female'],
                  isSelected: isSelectedGender,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelectedGender.length; i++) {
                        isSelectedGender[i] = i == index;
                      }
                    });
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
                Row(
                  children: [
                    Container(
                      width: 130,
                      child: ReusableTextFormField(
                        labelText: 'Height',
                        icon: null,
                        validatorMessage: 'Invalid Height',
                        validatorFormat: RegExp(r'^\d+(\.\d+)?$'),
                        controller: _heightController,
                        suffixText: 'cm',
                      ),
                    ),
                    const SizedBox(width: 25),
                    Container(
                      width: 145,
                      child: buildDatePickerField(
                          context, 'Birthday', Icons.cake,
                          width: 150, controller: _dateController),
                    ),
                  ],
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print('Name: ${_nameController.text.trim()}');
                        print('Email: ${_emailController.text.trim()}');
                        print('Password: ${_passwordController.text}');
                        print(
                            'Gender: ${isSelectedGender[0] ? 'Male' : 'Female'}');
                        print(
                            'Marital Status: ${isSelectedMaritalStatus[0] ? 'Married' : 'Single'}');
                        print('Height: ${_heightController.text.trim()}');
                        print('Birthdate: ${_dateController.text.trim()}');
                        print('Family History: ${widget.familyHistory}');
                        print(
                            'Profile Picture Path: ${_profilePicture?.path ?? 'null'}');

                        _authService
                            .register(
                          _nameController.text.trim(),
                          _emailController.text.trim(),
                          _passwordController.text,
                          isSelectedGender[0] ? 'Male' : 'Female',
                          isSelectedMaritalStatus[0] ? 'Married' : 'Single',
                          _heightController.text.trim(),
                          _dateController.text.trim(),
                          widget.familyHistory,
                          _profilePicture?.path ?? '',
                        )
                            .then((_) {
                          showConfirmationDialog(
                                  context,
                                  'Registration Successful',
                                  'You have successfully registered.')
                              .then((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          });
                        }).catchError((error) {
                          showErrorDialog(
                              context, 'Registration Error', 'Error: $error');
                        });
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Have an account? '),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: pinkColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
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

























/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/utilities.dart';
import 'login_page.dart';
import '../widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/services/auth_service.dart';

final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();

class RegisterPage extends StatefulWidget {
  final bool familyHistory;

  const RegisterPage({Key? key, required this.familyHistory}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  List<bool> isSelectedGender = [true, false];
  List<bool> isSelectedMaritalStatus = [true, false];

  XFile? _profilePicture;
  final ImagePicker _picker = ImagePicker();

  /// Pick a profile picture from the gallery
  Future<void> _pickProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePicture = image;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(227, 249, 243, 243),
      appBar: CustomHeader(
        imageProvider: _profilePicture != null
            ? FileImage(File(_profilePicture!.path))
            : null,
        imagePath: 'assets/images/diabetesLogo.png',
        welcomeMessage: 'Welcome to Diabetes Preventer!',
        showWelcomeMessage: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: pinkColor,
                    ),
                  ),
                ),
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
                ReusableTextFormField(
                  labelText: 'Name',
                  icon: Icons.person,
                  validatorMessage: 'Must include at least 3 characters',
                  validatorFormat: RegExp(r'^.{3,}$'),
                  controller: _nameController,
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
                const Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 16,
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomToggleButtons(
                  options: const ['Male', 'Female'],
                  isSelected: isSelectedGender,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelectedGender.length; i++) {
                        isSelectedGender[i] = i == index;
                      }
                    });
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
                Row(
                  children: [
                    Container(
                      width: 130,
                      child: ReusableTextFormField(
                        labelText: 'Height',
                        icon: null,
                        validatorMessage: 'Invalid Height',
                        validatorFormat: RegExp(r'^\d+(\.\d+)?$'),
                        controller: _heightController,
                        suffixText: 'cm',
                      ),
                    ),
                    const SizedBox(width: 25),
                    Container(
                      width: 145,
                      child: buildDatePickerField(
                          context, 'Birthday', Icons.cake,
                          width: 150, controller: _dateController),
                    ),
                  ],
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        register(
                          _nameController.text.trim(),
                          _emailController.text.trim(),
                          _passwordController.text,
                          isSelectedGender[0] ? 'Male' : 'Female',
                          isSelectedMaritalStatus[0] ? 'Married' : 'Single',
                          _heightController.text.trim(),
                          _dateController.text.trim(),
                          widget.familyHistory,
                          _profilePicture,
                        );
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Have an account? '),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: pinkColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
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

  /// Registers a new user by sending the provided data to the backend.
  ///
  /// The [name], [email], [password], [gender], [maritalStatus], [height], [birthdate], and [familyHistory]
  /// parameters are required for registration. The [profilePicture] parameter is optional.
  ///
  /// Displays a confirmation dialog on successful registration and navigates to the login page.
  /// Displays an error dialog if registration fails.
  Future<void> register(
    String name,
    String email,
    String password,
    String gender,
    String maritalStatus,
    String height,
    String birthdate,
    bool familyHistory,
    XFile? profilePicture,
  ) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2:8000/api/register/'));
      request.fields['name'] = name;
      request.fields['email'] = email.toLowerCase();
      request.fields['password'] = password;
      request.fields['gender'] = gender;
      request.fields['marital_status'] = maritalStatus;
      request.fields['height'] = height;
      request.fields['birthdate'] = birthdate;
      request.fields['family_history'] = familyHistory.toString();

      if (profilePicture != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_picture', profilePicture.path));
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        // Show confirmation dialog on successful registration
        showConfirmationDialog(context, 'Registration Successful',
                'You have successfully registered.')
            .then((_) {
          // Navigate to login page after dialog is dismissed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        });
      } else {
        var responseJson = json.decode(responseBody.body);
        showErrorDialog(context, 'Registration Error', responseJson['error']);
      }
    } catch (e) {
      showErrorDialog(context, 'Registration Error', 'Error: $e');
    }
  }
}


*/