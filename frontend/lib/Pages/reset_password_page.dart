import 'package:flutter/material.dart';
import 'package:frontend/widgets/widgets.dart';
import '../services/auth_service.dart';
import '../utils/utilities.dart';
import 'login_page.dart';

class PasswordResetRequestPage extends StatefulWidget {
  @override
  _PasswordResetRequestPageState createState() =>
      _PasswordResetRequestPageState();
}

class _PasswordResetRequestPageState extends State<PasswordResetRequestPage> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _requestPasswordReset() async {
    setState(() {
      _isLoading = true;
    });

    final response =
        await _authService.requestPasswordReset(_emailController.text);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to your email')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(227, 249, 243, 243),
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Column(
        children: [
          Expanded(
            child: bodyPasswordResetRequest(context),
          ),
          footer(),
        ],
      ),
    );
  }

  Widget bodyPasswordResetRequest(BuildContext context) {
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
                  color: pinkColor,
                ),
              ),
              const SizedBox(height: 24),
              ReusableTextFormField(
                labelText: 'Email',
                icon: Icons.email,
                validator: emailUsernameValidator,
                controller: _emailController,
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
                      onPressed: _requestPasswordReset,
                      child: const Text(
                        'Send Reset Link',
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
