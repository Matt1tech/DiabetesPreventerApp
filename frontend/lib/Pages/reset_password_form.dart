import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/utilities.dart';
import '../widgets/custom_text_form_field.dart'; // Import utilities for consistent styling

class PasswordResetFormPage extends StatefulWidget {
  final String token;
  final String uidb64;

  PasswordResetFormPage({required this.token, required this.uidb64});

  @override
  _PasswordResetFormPageState createState() => _PasswordResetFormPageState();
}

class _PasswordResetFormPageState extends State<PasswordResetFormPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await _authService.confirmPasswordReset(
        widget.uidb64, widget.token, _passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(227, 249, 243, 243),
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Column(
        children: [
          Expanded(
            child: bodyPasswordResetForm(context),
          ),
          footer(), // Footer widget for consistency
        ],
      ),
    );
  }

  Widget bodyPasswordResetForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: pinkColor, // Use your consistent pinkColor variable
                ),
              ),
              const SizedBox(height: 24),
              ReusableTextFormField(
                labelText: 'New Password',
                icon: Icons.lock,
                validatorMessage: 'Password is required',
                validatorFormat: RegExp(r'.+'),
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ReusableTextFormField(
                labelText: 'Confirm Password',
                icon: Icons.lock,
                validatorMessage: 'Password confirmation is required',
                validatorFormat: RegExp(r'.+'),
                controller: _confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(340, 50)),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color.fromARGB(255, 68, 37, 135)
                                  .withOpacity(0.8);
                            } else if (states.contains(MaterialState.hovered)) {
                              return const Color.fromARGB(255, 88, 71, 126)
                                  .withOpacity(0.9);
                            }
                            return pinkColor;
                          },
                        ),
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black12;
                            }
                            return Colors.transparent;
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: _resetPassword,
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
