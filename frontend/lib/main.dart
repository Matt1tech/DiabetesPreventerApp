import 'package:flutter/material.dart';
import 'package:frontend/Pages/login_page.dart';
import 'package:frontend/Pages/profile_update_page.dart';
//import '../Pages/pages.dart';
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
