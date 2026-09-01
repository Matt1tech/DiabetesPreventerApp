import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';
import '../services/auth_service.dart';

class LogoutManager {
  final BuildContext context;
  final AuthService authService;

  LogoutManager({required this.context, required this.authService});

  Future<void> logout() async {
    try {
      await authService.logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout Successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Logout error: $e');
      _showLogoutFailedDialog();
    }
  }

  void _showLogoutFailedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout Failed'),
          content: const Text('An error occurred during logout.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
