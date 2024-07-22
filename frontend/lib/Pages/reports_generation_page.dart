import 'package:flutter/material.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/navigation_util.dart';

class ReportsGenerationPage extends StatefulWidget {
  ReportsGenerationPage({Key? key}) : super(key: key);

  @override
  _ReportsGenerationPageState createState() => _ReportsGenerationPageState();
}

class _ReportsGenerationPageState extends State<ReportsGenerationPage> {
  int _selectedIndex = 4;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          /* imageProvider: imageProvider,*/
          imagePath: 'assets/images/diabetesLogo.png',
          pageName: 'Reports Generation',
          welcomeMessage: 'Hello Again!',
          userName: 'user name',
          userStatus: 'Active',
          rightIcon: Icons.notifications,
          showWelcomeMessage: true,
          topPadding: 50.0,
        ),
      ),
      body: Center(
        child: Text(
          'Reports Generation Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
