import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../utilities.dart';
import 'login_page.dart';
import '../custom_header.dart';

final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmPasswordController = TextEditingController();

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Add TextEditingController for the date picker field
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(227, 249, 243, 243),
      appBar: CustomHeader(
        imagePath: 'assets/images/diabetesLogo.png',
        welcomeMessage: 'Welcome to Diabetes Preventer!',
        showWelcomeMessage:
            true, // Set to false if you don't want the welcome message
      ),
      body: bodyRegister(context,
          _dateController), // Using the body specific to family history
    );
  }
}

Widget bodyRegister(
    BuildContext context, TextEditingController dateController) {
  return Expanded(
    child: SingleChildScrollView(
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
              ReusableTextFormField(
                labelText: 'Name',
                icon: Icons.person,
                validatorMessage: 'Name should be at least 3 characters long',
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
                    'Password must include 6 number, a capital and a small letters,  and a special character',
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
                isSelected: [true, false], // Initial state
                onPressed: (int index) {
                  // Handle selection
                  print('Gender selected: ${index == 0 ? 'Male' : 'Female'}');
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
                isSelected: [true, false], // Initial state
                onPressed: (int index) {
                  // Handle selection
                  print(
                      'Marital Status selected: ${index == 0 ? 'Married' : 'Single'}');
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
                      validatorMessage: 'Please enter a valid height',
                      validatorFormat: RegExp(r'^\d+(\.\d+)?$'),
                      controller: TextEditingController(),
                      suffixText: 'cm',
                    ),
                  ),
                  const SizedBox(width: 25),
                  Container(
                    width: 145,
                    child: buildDatePickerField(context, 'Birthday', Icons.cake,
                        width: 150, controller: dateController),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(340, 50)),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Color.fromARGB(255, 68, 37, 135)
                              .withOpacity(0.8); // Slightly darker when pressed
                        } else if (states.contains(MaterialState.hovered)) {
                          return Color.fromARGB(255, 88, 71, 126).withOpacity(
                              0.9); // Slightly lighter when hovered
                        }
                        return pinkColor;
                      },
                    ),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black12; // Dark overlay when pressed
                        }
                        return Colors.transparent; // No overlay by default
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
                      // Handle successful form submission
                      // You can add code here to store information in the database
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
                    Navigator.pop(
                        context); // Navigate back to the previous screen
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
