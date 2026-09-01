import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/utilities.dart';
import '../widgets/custom_text_form_field.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;

  VerifyOtpPage({required this.email});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await _authService.verifyOtp(
      widget.email,
      _otpController.text,
      _passwordController.text,
    );

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
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: AppBar(
        title: Text('Verify OTP'),
      ),
      body: Column(
        children: [
          Expanded(
            child: bodyVerifyOtp(context),
          ),
          footer(),
        ],
      ),
    );
  }

  Widget bodyVerifyOtp(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: pinkColor,
                ),
              ),
              const SizedBox(height: 24),
              ReusableTextFormField(
                labelText: 'OTP',
                icon: Icons.lock,
                controller: _otpController,
              ),
              const SizedBox(height: 16),
              ReusableTextFormField(
                labelText: 'New Password',
                icon: Icons.lock,
                validatorFormat: RegExp(
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$'),
                controller: _passwordController,
                obscureText: true,
                showPasswordToggle: true,
              ),
              const SizedBox(height: 16),
              ReusableTextFormField(
                labelText: 'Confirm Password',
                icon: Icons.lock,
                validatorMessage: 'Passwords do not match',
                validatorFormat: RegExp(r'^.{6,}$'),
                controller: _confirmPasswordController,
                obscureText: true,
                showPasswordToggle: true,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                  }
                  return null;
                },
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
                      onPressed: _verifyOtp,
                      child: const Text(
                        'Verify OTP',
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
