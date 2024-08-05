import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/utilities.dart';
import '../widgets/custom_text_form_field.dart';
import 'login_page.dart';
import 'verify_otp.dart';

class RequestOtpPage extends StatefulWidget {
  @override
  _RequestOtpPageState createState() => _RequestOtpPageState();
}

class _RequestOtpPageState extends State<RequestOtpPage> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _requestOtp() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _authService.requestOtp(_emailController.text);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to your email')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyOtpPage(email: _emailController.text)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(227, 249, 243, 243),
      appBar: AppBar(
        title: Text('Request OTP'),
      ),
      body: Column(
        children: [
          Expanded(
            child: bodyRequestOtp(context),
          ),
          footer(),
        ],
      ),
    );
  }

  Widget bodyRequestOtp(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Request OTP',
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
                      onPressed: _requestOtp,
                      child: const Text(
                        'Request OTP',
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
