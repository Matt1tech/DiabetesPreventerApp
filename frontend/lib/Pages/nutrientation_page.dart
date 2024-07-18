import 'package:flutter/material.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/navigation_util.dart';

class NutrientationPage extends StatefulWidget {
  NutrientationPage({Key? key}) : super(key: key);

  @override
  _NutrientationPageState createState() => _NutrientationPageState();
}

class _NutrientationPageState extends State<NutrientationPage> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index);
  }

  @override
  Widget build(BuildContext context) {
    /*String profilePictureUrl =
        'http://10.0.2.2:8000${widget.userData?['profile_picture']}';
    ImageProvider<Object> imageProvider;
    if (widget.userData?['profile_picture'] != null) {
      imageProvider = NetworkImage(profilePictureUrl);
    } else {
      imageProvider = AssetImage('assets/images/default_profile.png');
    }
*/
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          /*imageProvider: imageProvider,*/
          imagePath: 'assets/images/diabetesLogo.png',
          pageName: 'Nutrientation',
          welcomeMessage: 'Hello Again!',
          userName: 'Matt',
          userStatus: 'Active',
          rightIcon: Icons.notifications,
          showWelcomeMessage: true,
          topPadding: 50.0,
        ),
      ),
      body: Center(
        child: Text(
          'Nutrientation Page',
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
