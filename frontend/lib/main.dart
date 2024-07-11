import 'package:flutter/material.dart';
import 'Pages/login_page.dart'; // Correct relative import for login page
// Correct relative import for home

void main() {
  runApp(const MyApp());
}

// Main widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const LoginPage(), // Set the initial route to LoginPage
    );
  }
}
