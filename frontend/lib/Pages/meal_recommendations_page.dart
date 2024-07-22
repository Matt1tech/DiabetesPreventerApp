import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/utils.dart';

class MealRecommendationsPage extends StatefulWidget {
  MealRecommendationsPage({Key? key}) : super(key: key);

  @override
  _MealRecommendationsPageState createState() =>
      _MealRecommendationsPageState();
}

class _MealRecommendationsPageState extends State<MealRecommendationsPage> {
  int _selectedIndex = 1;
  XFile? _profilePicture;
  final ImagePicker _picker = ImagePicker();
  String? userName;
  String? userProfilePicture;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index);
  }

  //handle the image of the profile picture
  Future<void> _loadUserInfo() async {
    final userInfo = await loadUserInfo();
    setState(() {
      userName = userInfo['userName'];
      userProfilePicture = userInfo['userProfilePicture'];
    });
  }

  Future<void> _pickProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePicture = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider =
        getImageProvider(_profilePicture, userProfilePicture);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          /*imageProvider: 'assets/images/diabetesLogo.png',*/
          imageProvider: imageProvider,
          pageName: 'Meal Recommendations',
          welcomeMessage: 'Hello Again!',
          userName: userName ?? 'user name',
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
