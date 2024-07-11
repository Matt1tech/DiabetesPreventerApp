import 'package:flutter/material.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/navigation_util.dart';

class ProfileUpdatePage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  ProfileUpdatePage({Key? key, required this.userData}) : super(key: key);

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  int _selectedIndex = 6;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index, widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    String profilePictureUrl =
        'http://10.0.2.2:8000${widget.userData?['profile_picture']}';
    ImageProvider<Object> imageProvider;
    if (widget.userData?['profile_picture'] != null) {
      imageProvider = NetworkImage(profilePictureUrl);
    } else {
      imageProvider = AssetImage('assets/images/default_profile.png');
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          imageProvider: imageProvider,
          imagePath: 'assets/images/diabetesLogo.png',
          pageName: 'Profile Update',
          welcomeMessage: 'Hello Again!',
          userName: '${widget.userData?['name']}',
          userStatus: 'Active',
          rightIcon: Icons.notifications,
          showWelcomeMessage: true,
          topPadding: 50.0,
        ),
      ),
      body: Center(
        child: Text(
          'Profile Update Page',
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
