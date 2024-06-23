import 'package:flutter/material.dart';
import 'utilties.dart'; // Correct relative import for login page
import 'familyHistory.dart';
import 'customHeader.dart';

final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();

String? emailUsernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  } else if (value.length < 3) {
    return 'Must be at least 3 characters long';
  }
  return null;
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(228, 238, 235, 235),
      appBar: CustomHeader(
        imagePath: 'images/diabetesLogo.png',
        welcomeMessage: 'Welcome to Diabetes Preventer!',
        showWelcomeMessage:
            true, // Set to false if you don't want the welcome message
      ),
      body: Column(
        children: [
          Expanded(
            child:
                bodyLogin(context), // Using the body specific to family history
          ),
          footer(), // Using footer widget
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
                  color: pinkColor,
                ),
              ),
              const SizedBox(height: 24),
              ReusableTextFormField(
                labelText: 'Email / Username',
                icon: Icons.email,
                validator:
                    emailUsernameValidator, // Use the custom validator here
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              ReusableTextFormField(
                labelText: 'Password',
                icon: Icons.lock,
                validatorMessage: 'Password is required',
                validatorFormat: RegExp(r'.+'), // At least one character
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
                        onChanged: (value) {},
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
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
                      return Color.fromARGB(255, 68, 37, 135)
                          .withOpacity(0.8); // Slightly darker when pressed
                    } else if (states.contains(MaterialState.hovered)) {
                      return Color.fromARGB(255, 88, 71, 126)
                          .withOpacity(0.9); // Slightly lighter when hovered
                    }
                    return pinkColor;
                  }),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black12; // Dark overlay when pressed
                    }
                    return Colors.transparent; // No overlay by default
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle successful form submission
                    // Add code here to handle login
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white, // Text color set correctly
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
                          builder: (context) => FamilyHistoryPage()),
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
