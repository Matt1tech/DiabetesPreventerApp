import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:frontend/Pages/login_page.dart';
import 'Pages/verify_otp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final path = uri.path;
        final segments = uri.pathSegments;

        // Handle deep link for password reset via OTP
        if (segments.length == 1 && segments[0] == 'verify_otp') {
          final email = uri.queryParameters['email'];
          if (email != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyOtpPage(email: email),
              ),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoginPage(),
      ),
    );
  }
}
