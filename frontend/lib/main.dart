import 'package:flutter/material.dart';
import 'loginPage.dart'; // Correct relative import for login page

void main() {
  runApp(const MyApp());
}

// Main widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes Preventer',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // Set the initial route to LoginPage
    );
  }
}
