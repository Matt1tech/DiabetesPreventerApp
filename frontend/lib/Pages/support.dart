import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import '../services/fetch_user_data_service.dart';
import '../utils/logout_utility.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/widgets.dart'; // Barrel file for custom widgets
import '../utils/utils.dart'; // Barrel file for utilities

class ClientSupportPage extends StatefulWidget {
  const ClientSupportPage({super.key});

  @override
  _ClientSupportPageState createState() => _ClientSupportPageState();
}

class _ClientSupportPageState extends State<ClientSupportPage> {
  final storage = FlutterSecureStorage();
  String? userName;
  String? userProfilePicture;
  String adminEmail = 'mattalbukaai@gmail.com';
  String adminPhoneNumber = '+601172455491';
  String? user_id;
  final AuthService _authService = AuthService();
  late LogoutManager logoutManager;
  int _selectedIndex = 6;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    logoutManager = LogoutManager(context: context, authService: _authService);
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await loadUserInfo();
    if (mounted) {
      setState(() {
        userName = userInfo['userName'];
        userProfilePicture = userInfo['userProfilePicture'];
        user_id = userInfo['id'];
      });
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: adminEmail,
      query: Uri.encodeFull(
          'subject=Support Request&body=Hello, I need support with...'),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      print('Could not launch email client');
      print('URL: ${emailLaunchUri.toString()}');
    }
  }

  Future<void> _launchDialer() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: adminPhoneNumber,
    );

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      print('Could not launch phone dialer');
      print('URL: ${phoneLaunchUri.toString()}');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      print('Could not launch $url');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index);
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider =
        getImageProvider(null, userProfilePicture);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 217, 217),
      appBar: UserHeader(
        imageProvider: imageProvider,
        pageName: 'Client Support',
        welcomeMessage: 'Contact Us!',
        userName: userName,
        userStatus: 'Active',
        rightIcon: Icons.notifications,
        showWelcomeMessage: true,
        topPadding: 50.0,
      ),
      drawer: CustomDrawer(
        userName: userName,
        imageProvider: imageProvider,
        logoutManager:
            LogoutManager(context: context, authService: _authService),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              _aboutUsSection(),
              const SizedBox(height: 20),
              _contactSection(),
              const SizedBox(height: 20),
              _rulesAndRegulationsSection(),
              const SizedBox(height: 20),
              _faqSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _aboutUsSection() {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ExpansionTile(
        title: const Text(
          'About Us',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: blueColor,
          ),
        ),
        children: const [
          SizedBox(height: 10),
          Text(
            'Diabetes Preventer is an application designed to help you monitor and manage your health, especially focusing on preventing diabetes. Our goal is to provide you with the tools and information you need to stay healthy and informed.',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(134, 22, 22, 22),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Our application empowers users with innovative technology to analyze their data and provide information to support them in preventing diabetes and other diseases.',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(134, 22, 22, 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactSection() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ExpansionTile(
        title: const Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: blueColor,
          ),
        ),
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SupportButton(
                icon: Icons.email,
                text: 'Send Email',
                onPressed: _launchEmail,
              ),
              SupportButton(
                icon: Icons.phone,
                text: 'Call Us',
                onPressed: _launchDialer,
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            icon: const Icon(Icons.email),
            label: const Text(
              'Email: mattalbukaai@gmail.com',
              style: TextStyle(fontSize: 14),
            ),
            onPressed: _launchEmail,
          ),
          TextButton.icon(
            icon: const Icon(Icons.phone),
            label: const Text(
              'Phone: +601172455491',
              style: TextStyle(fontSize: 14),
            ),
            onPressed: _launchDialer,
          ),
          const SizedBox(height: 10),
          const Divider(),
          const Text(
            'Follow Us',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: blueColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.facebook, color: Colors.blue),
                onPressed: () => _launchURL('https://facebook.com/diabets'),
              ),
              IconButton(
                icon: const Icon(Icons.one_x_mobiledata_outlined,
                    color: Colors.blue),
                onPressed: () => _launchURL('https://twitter.com/yourpage'),
              ),
              IconButton(
                icon:
                    const Icon(Icons.camera_alt_outlined, color: Colors.purple),
                onPressed: () => _launchURL('https://instagram.com/yourpage'),
              ),
              IconButton(
                icon: const Icon(Icons.leave_bags_at_home, color: Colors.blue),
                onPressed: () => _launchURL('https://linkedin.com/yourpage'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rulesAndRegulationsSection() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ExpansionTile(
        title: const Text(
          'Rules and Regulations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: blueColor,
          ),
        ),
        children: const [
          SizedBox(height: 10),
          Text(
            '1. Users must provide accurate health information to ensure the application can provide the best support and advice.',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(134, 22, 22, 22),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '2. The application should not be used as a substitute for professional medical advice, diagnosis, or treatment.',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(134, 22, 22, 22),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '3. Users should regularly update their health records to ensure they receive the most accurate advice.',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(134, 22, 22, 22),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '4. The application reserves the right to modify these rules and regulations at any time.',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(134, 22, 22, 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqSection() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ExpansionTile(
        title: const Text(
          'FAQ',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: blueColor,
          ),
        ),
        children: const [
          SizedBox(height: 10),
          ListTile(
            title: Text(
              'Q: What is Diabetes Preventer?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'A: Diabetes Preventer is an application designed to help you monitor and manage your health, focusing on preventing diabetes through innovative technology and personalized advice.',
            ),
          ),
          ListTile(
            title: Text(
              'Q: How do I use the application?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'A: You can use the application by entering your health information regularly and following the personalized advice provided to you based on your data.',
            ),
          ),
          ListTile(
            title: Text(
              'Q: Is my health data secure?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'A: Yes, your health data is stored securely and used only to provide you with the best possible support and advice.',
            ),
          ),
          ListTile(
            title: Text(
              'Q: Can I use the application as a substitute for medical advice?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'A: No, the application should not be used as a substitute for professional medical advice, diagnosis, or treatment. Always consult with your healthcare provider for any medical concerns.',
            ),
          ),
        ],
      ),
    );
  }
}

class SupportButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const SupportButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(text, style: const TextStyle(fontSize: 18)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
