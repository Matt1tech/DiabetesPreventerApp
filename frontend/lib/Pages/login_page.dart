import 'package:flutter/material.dart';
import '../utils/utilities.dart'; // Correct relative import for utilities
import 'family_history.dart'; // Import for the sign-up page
import 'home_page.dart'; // Import for the home page after login
import '../widgets/custom_header.dart'; // Import for the custom header widget
import 'package:frontend/services/auth_service.dart';
import '../widgets/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage package for storing JWT token

// Define form key, text controllers, and secure storage instance
final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final storage = FlutterSecureStorage();
final AuthService _authService = AuthService();

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
                    _authService
                        .login(
                      _emailController.text.trim(),
                      _passwordController.text,
                    )
                        .then((userData) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(userData: userData),
                        ),
                      );
                    }).catchError((error) {
                      showErrorDialog(context, 'Login Error', 'Error: $error');
                    });
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
