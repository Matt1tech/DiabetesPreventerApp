import 'package:flutter/material.dart';
import 'utilties.dart'; // Correct relative import for login page
import 'familyHistory.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(228, 238, 235, 235),
      body: Column(
        children: [
          header(
              imagePath: 'images/diabetesLogo.png',
              welcomeMessage: 'Welcome Healthy...'),
          bodyLogin(),
          footer(),
        ],
      ),
    );
  }
}

Widget bodyLogin() {
  return Expanded(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            TextField(
              decoration: InputDecoration(
                labelText: 'Email / Username',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
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
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
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
              onPressed: () {},
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white, // Text color set correctly
                ),
              ),
            ),
            const SizedBox(height: 24),
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
                child: const Text("Sign Up"),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}
