import 'package:flutter/material.dart';
import 'package:frontend/Pages/pages.dart';
import '../utils/utilities.dart'; // Correct relative import for utilities
import '../widgets/widgets.dart';
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

Widget bodyLogin(BuildContext context) {
  return Expanded(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: pinkColor, // Replace with your pinkColor variable
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
                obscureText: true,
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
                  minimumSize: MaterialStateProperty.all(const Size(340, 50)),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Color.fromARGB(255, 68, 37, 135).withOpacity(0.8);
                    } else if (states.contains(MaterialState.hovered)) {
                      return Color.fromARGB(255, 88, 71, 126).withOpacity(0.9);
                    }
                    return pinkColor; // Replace with your pinkColor variable
                  }),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black12;
                    }
                    return Colors.transparent;
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
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
              const Text('-OR-'),
              const Text('Don\'t have an account?'),
              const SizedBox(height: 8),
              Builder(
                builder: (context) => TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
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
