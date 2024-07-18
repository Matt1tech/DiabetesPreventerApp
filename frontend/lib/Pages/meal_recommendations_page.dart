import 'package:flutter/material.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/navigation_util.dart';

class MealRecommendationsPage extends StatefulWidget {
  MealRecommendationsPage({Key? key}) : super(key: key);

  @override
  _MealRecommendationsPageState createState() =>
      _MealRecommendationsPageState();
}

class _MealRecommendationsPageState extends State<MealRecommendationsPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index);
  }

  @override
  Widget build(BuildContext context) {
    /* String profilePictureUrl =
        'http://10.0.2.2:8000${widget.userData!['profile_picture']}';
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
          /*imageProvider: 'assets/images/diabetesLogo.png',*/
          imagePath: 'assets/images/diabetesLogo.png',
          pageName: 'Meal Recommendations',
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
          'Meal Recommendations Page',
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
