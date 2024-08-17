import 'package:flutter/material.dart';
import '../utils/utilities.dart'; // Correct relative import for utilities
import '../widgets/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage package for storing JWT token
import '../services/auth_service.dart';
import 'pages.dart';
import 'request_otp.dart';

// Define form key, text controllers, and secure storage instance
final _formKey = GlobalKey<FormState>();
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final storage = FlutterSecureStorage();
final AuthService authService =
    AuthService(); // Create an instance of AuthService

// Validator function for email/username input
String? emailUsernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  } else if (value.length < 3) {
    return 'Must be at least 3 characters long';
  }
  return null;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false; // Define isLoading as a state variable
  bool rememberMe = false; // Define rememberMe as a state variable

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Load saved credentials if any
  }

  void _clearFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _loadSavedCredentials() async {
    String? savedEmail = await storage.read(key: 'email');
    String? savedPassword = await storage.read(key: 'password');
    if (savedEmail != null && savedPassword != null) {
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;
      setState(() {
        rememberMe = true;
      });
    }
  }

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
    });
    try {
      await authService.login(
          _emailController.text.toLowerCase(), _passwordController.text);
      if (rememberMe) {
        await storage.write(key: 'email', value: _emailController.text);
        await storage.write(key: 'password', value: _passwordController.text);
      } else {
        await storage.delete(key: 'email');
        await storage.delete(key: 'password');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      // Show error message if login fails
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Please check your email and password.'),
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    await storage.delete(key: 'email');
    await storage.delete(key: 'password');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 217, 217, 217), // Background color
      appBar: CustomHeader(
        imagePath:
            'assets/images/diabetesLogo.png', // Default profile picture if not available
        welcomeMessage: 'Welcome back..', // Welcome message with user's name
        showWelcomeMessage: true, // Display the welcome message
      ),
      body: Column(
        children: [
          Expanded(
            child: bodyLogin(context), // Login form body
          ),
          footer(), // Footer widget
        ],
      ),
    );
  }

  Widget bodyLogin(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: pinkColor, // Replace with your pinkColor variable
                ),
              ),
              const SizedBox(height: 24),
              ReusableTextFormField(
                labelText: 'Email / Username',
                icon: Icons.email,
                validator: emailUsernameValidator,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              ReusableTextFormField(
                labelText: 'Password',
                icon: Icons.lock,
                validatorMessage: 'Password is required',
                validatorFormat: RegExp(r'.+'),
                controller: _passwordController,
                obscureText: true,
                showPasswordToggle: true,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
                        .hasMatch(value)) {
                      return 'Must have 6 No, a capital letter, a small letter, and a special character';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        }, // Remember Me checkbox
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestOtpPage()),
                      );
                    }, // Forgot password button
                    child: const Text('Forget password?'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              isLoading
                  ? const CircularProgressIndicator(
                      semanticsLabel: 'Loading...',
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        minimumSize:
                            WidgetStateProperty.all(const Size(340, 50)),
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const Color.fromARGB(255, 68, 37, 135)
                                .withOpacity(0.8);
                          } else if (states.contains(MaterialState.hovered)) {
                            return const Color.fromARGB(255, 88, 71, 126)
                                .withOpacity(0.9);
                          }
                          return pinkColor; // Replace with your pinkColor variable
                        }),
                        overlayColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.black12;
                          }
                          return Colors.transparent;
                        }),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: _handleLogin,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
              const SizedBox(height: 30),
              const Text('-OR-'),
              const Text('Don\'t have an account?'),
              const SizedBox(height: 8),
              Builder(
                builder: (context) => TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FamilyHistoryPage(),
                      ),
                    );
                  },
                  child: const Text("Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      )),
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
