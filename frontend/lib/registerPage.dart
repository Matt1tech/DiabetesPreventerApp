import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'utilties.dart';
import 'loginPage.dart';

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
      backgroundColor: const Color.fromARGB(228, 238, 235, 235),
      body: Column(
        children: [
          header(
              imagePath: 'images/diabetesLogo.png',
              welcomeMessage: 'Welcome Healthy...'),
          bodyRegister(context, _dateController), // Pass the controller
          footer(),
        ],
      ),
    );
  }
}

Widget bodyRegister(
    BuildContext context, TextEditingController dateController) {
  return Expanded(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            buildTextField('Name', Icons.person),
            const SizedBox(height: 16),
            buildTextField('Email', Icons.email),
            const SizedBox(height: 16),
            buildTextField('Password', Icons.lock, obscureText: true),
            const SizedBox(height: 16),
            buildTextField('Confirm Password', Icons.lock, obscureText: true),
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
                buildTextField('Height', null, suffixText: 'cm', width: 150),
                const SizedBox(width: 40),
                buildDatePickerField(context, 'Birthday', Icons.cake,
                    width: 150, controller: dateController),
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
                        return Color.fromARGB(255, 88, 71, 126)
                            .withOpacity(0.9); // Slightly lighter when hovered
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
                onPressed: () {},
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
          ],
        ),
      ),
    ),
  );
}

Widget buildTextField(
  String labelText,
  IconData? icon, {
  bool obscureText = false,
  String? suffixText,
  double? width,
}) {
  return SizedBox(
    width: width,
    child: TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixText: suffixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        labelStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: 20.0,
          color: pinkColor,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelAlignment: FloatingLabelAlignment.start,
      ),
    ),
  );
}
