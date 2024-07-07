import 'package:flutter/material.dart';
import '../utilities.dart'; // Correct relative import for utilities
import 'family_history.dart'; // Import for the sign-up page
import 'home.dart'; // Import for the home page after login
import '../custom_header.dart'; // Import for the custom header widget
import 'package:http/http.dart'
    as http; // HTTP package for making network requests
import 'dart:convert'; // JSON encoding and decoding
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage package for storing JWT token

// Define form key, text controllers, and secure storage instance
final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final storage = FlutterSecureStorage();

// Validator function for email/username input
String? emailUsernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  } else if (value.length < 3) {
    return 'Must be at least 3 characters long';
  }
  return null;
}

// Login page widget
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(227, 249, 243, 243), // Background color
      appBar: CustomHeader(
        imagePath: 'assets/images/diabetesLogo.png', // Logo image path
        welcomeMessage: 'Welcome to Diabetes Preventer!', // Welcome message
        showWelcomeMessage: true, // Display the welcome message
      ),
      body: Column(
        children: [
          Expanded(
            child: bodyLogin(context), // Login form body
          ),
          footer(), // Footer widget
        ],
      ),
    );
  }
}

// Widget for the login form body
Widget bodyLogin(BuildContext context) {
  return Expanded(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Form key for validation
          child: Column(
            children: [
              const SizedBox(height: 50), // Space at the top
              const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: pinkColor,
                ),
              ),
              const SizedBox(height: 24),
              ReusableTextFormField(
                labelText: 'Email / Username',
                icon: Icons.email,
                validator: emailUsernameValidator,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              ReusableTextFormField(
                labelText: 'Password',
                icon: Icons.lock,
                validatorMessage: 'Password is required',
                validatorFormat: RegExp(r'.+'),
                controller: _passwordController,
                obscureText: true, // Hide password text
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {}, // Remember Me checkbox
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {}, // Forgot password button
                    child: const Text('Forget password?'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      const Size(340, 50)), // Button size
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Color.fromARGB(255, 68, 37, 135)
                          .withOpacity(0.8); // Pressed color
                    } else if (states.contains(MaterialState.hovered)) {
                      return Color.fromARGB(255, 88, 71, 126)
                          .withOpacity(0.9); // Hover color
                    }
                    return pinkColor; // Default color
                  }),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black12; // Overlay color when pressed
                    }
                    return Colors.transparent; // Default overlay color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Button shape
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    login(
                        context,
                        _emailController.text.trim(),
                        _passwordController
                            .text); // Call login function on valid input
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text('-OR-'), // Separator text
              const Text('Don\'t have an account?'),
              const SizedBox(height: 8),
              Builder(
                builder: (context) => TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FamilyHistoryPage()), // Navigate to sign-up page
                    );
                  },
                  child: const Text("Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      )),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ),
  );
}

// Login function to handle user authentication
Future<void> login(BuildContext context, String email, String password) async {
  try {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/login/'), // API endpoint for login
      headers: {'Content-Type': 'application/json'}, // Set content type to JSON
      body: json.encode({
        'email': email,
        'password': password,
      }), // Request body with email and password
    );

    // Log the status code and response body for debugging
    print('Login Status code: ${response.statusCode}');
    print('Login Response body: ${response.body}');

    var responseJson = json.decode(response.body); // Decode the JSON response

    if (response.statusCode == 200) {
      String token = responseJson['token'];
      print('Storing Token: $token');
      await storage.write(
          key: 'jwt_token', value: token); // Store JWT token securely

      var userData = responseJson['user'];
      print('User Data: $userData'); // Log user data

      // Handle successful login, navigate to home page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                userData: userData)), // Navigate to home page with user data
      );
    } else {
      print('Login failed');
      showErrorDialog(context, 'Login Error',
          responseJson['error']); // Show error dialog on login failure
    }
  } catch (e) {
    print('Error: $e');
    showErrorDialog(
        context, 'Login Error', 'Error: $e'); // Show error dialog on exception
  }
}
