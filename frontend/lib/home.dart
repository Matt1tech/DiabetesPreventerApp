import 'package:flutter/material.dart';
import 'utilties.dart';
import 'customHeader.dart';

final _formKey = GlobalKey<FormState>();

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(
        imagePath: 'images/diabetesLogo.png',
        welcomeMessage: 'Welcome to Diabetes Preventer!',
        showWelcomeMessage:
            true, // Set to false if you don't want the welcome message
      ),
    );
  }
}

final _nameController = TextEditingController();
final _emailController = TextEditingController();
String? validateEmail(String? email) {
  RegExp emailRegexp =
      RegExp(r'^[\w-]+(\. [\w-]+)*@[\w-]+(\.\w{2,3}(\.\w{2,3})?$');
  final isEmailValid = emailRegexp.hasMatch(email ?? '');
  if (!isEmailValid) {
    return 'Please enter a valid email';
  }
  return null;
}
