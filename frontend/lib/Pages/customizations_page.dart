import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/services/fetch_user_data_service.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/customization_service.dart';
import '../utils/logout_utility.dart';
import '../utils/utilities.dart';
import '../widgets/customization_button.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/health_measurement_logs_card.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/navigation_util.dart';

class CustomizationsPage extends StatefulWidget {
  CustomizationsPage({Key? key}) : super(key: key);

  @override
  _CustomizationsPageState createState() => _CustomizationsPageState();
}

class _CustomizationsPageState extends State<CustomizationsPage> {
  final AuthService _authService = AuthService();

  int _selectedIndex = 2;
  bool isLoading = false;
  XFile? _profilePicture;
  String? userProfilePicture;
  String? userName;
  final storage = FlutterSecureStorage();
  String? user_id;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadUserData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index);
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

  Future<void> _loadUserData() async {
    final userName = await storage.read(key: 'user_name');
    final userId = await storage.read(key: 'user_id');
    if (mounted) {
      setState(() {
        this.userName = userName;
        userProfilePicture = userProfilePicture;
        user_id = userId;
      });
    }
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
  void dispose() {
    super.dispose();
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
          imageProvider: imageProvider,
          pageName: 'Customization',
          welcomeMessage: 'Make a plan!',
          userName: userName ?? 'user name',
          userStatus: 'Active',
          rightIcon: Icons.notifications,
          showWelcomeMessage: true,
          topPadding: 50.0,
        ),
      ),
      drawer: CustomDrawer(
        userName: userName,
        imageProvider: imageProvider,
        logoutManager:
            LogoutManager(context: context, authService: _authService),
      ),
      body: Column(
        children: [
          const SizedBox(height: 0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  mealPerDaySection(),
                  const SizedBox(height: 10),
                  alergiesSection(),
                  const SizedBox(height: 10),
                  dietsFollowedSection(),
                  const SizedBox(height: 10),
                  dailyCalories(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Container mealPerDaySection() {
    return Container(
      width: 360,
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(right: 220),
            child: Text(
              'Meals a day',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: blueColor,
                fontSize: 22.0,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 12),
              CustomTag(
                tagName: "Breakfast",
                onTagClick: handleTagClick,
              ),
              SizedBox(width: 40),
              CustomTag(
                tagName: "Lunch",
                onTagClick: handleTagClick,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              CustomTag(
                tagName: "Dinner",
                onTagClick: handleTagClick,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container alergiesSection() {
    return Container(
      width: 360,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 250),
            child: Text(
              'Allergies',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: blueColor,
                fontSize: 22.0,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 12),
              CustomTag(
                tagName: "Soy-free",
                onTagClick: handleTagClick,
              ),
              SizedBox(width: 25),
              CustomTag(
                tagName: "Gluten-free",
                onTagClick: handleTagClick,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 12),
              CustomTag(
                tagName: "Wheat-free",
                onTagClick: handleTagClick,
              ),
              SizedBox(width: 25),
              CustomTag(
                tagName: "Egg-free",
                onTagClick: handleTagClick,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container dietsFollowedSection() {
    return Container(
      width: 360,
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 180),
            child: Text(
              'Diets  Followed',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: blueColor,
                fontSize: 22.0,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 12),
              CustomTag(
                tagName: "Low-Fat",
                onTagClick: handleTagClick,
              ),
              SizedBox(width: 25),
              CustomTag(
                tagName: "No-sugar",
                onTagClick: handleTagClick,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 12),
              CustomTag(
                tagName: "High-Protein",
                onTagClick: handleTagClick,
              ),
              SizedBox(width: 22),
              CustomTag(
                tagName: "Low-Carb",
                onTagClick: handleTagClick,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container dailyCalories() {
    return Container(
      width: 390,
      height: 580,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 190),
            child: Text(
              'Daily Calories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: blueColor,
                fontSize: 22.0,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 10),
              HealthMeasurementLogsCard(
                title: 'Max Protein',
                name: 'maxDailyProtein',
                onPressed: (int value) {
                  if (user_id != null) {
                    UserCustomizationService.setMaxDailyProtein(
                        int.parse(user_id!), value);
                  }
                },
                width: 170,
                height: 160,
                cardColor: Color.fromARGB(221, 255, 250, 250),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              SizedBox(width: 10),
              HealthMeasurementLogsCard(
                title: 'Max Carbs',
                name: 'totalCarbs',
                onPressed: (int value) {
                  if (user_id != null) {
                    UserCustomizationService.setMaxDailyCarbs(
                        int.parse(user_id!), value);
                  }
                },
                width: 170,
                height: 160,
                cardColor: Color.fromARGB(221, 255, 250, 250),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10),
              HealthMeasurementLogsCard(
                title: 'Max Fiber',
                name: 'totalFiber',
                onPressed: (int value) {
                  if (user_id != null) {
                    UserCustomizationService.setMaxDailyFiber(
                        int.parse(user_id!), value);
                  }
                },
                width: 170,
                height: 160,
                cardColor: Color.fromARGB(221, 255, 250, 250),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              SizedBox(width: 10),
              HealthMeasurementLogsCard(
                title: 'Max Fat',
                name: 'totalFat',
                onPressed: (int value) {
                  if (user_id != null) {
                    UserCustomizationService.setMaxDailyFat(
                        int.parse(user_id!), value);
                  }
                },
                width: 170,
                height: 160,
                cardColor: Color.fromARGB(221, 255, 250, 250),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            HealthMeasurementLogsCard(
              title: 'Max Daily Calories',
              name: 'totalDailyCalories',
              onPressed: (int value) {
                if (user_id != null) {
                  UserCustomizationService.setMaxDailyCalories(
                      int.parse(user_id!), value);
                }
              },
              width: 350,
              height: 150,
              cardColor: Color.fromARGB(221, 255, 250, 250),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ])
        ],
      ),
    );
  }

  void handleTagClick(String tagName) async {
    if (user_id == null) {
      print("User ID is null");
      return;
    }

    List<String> tagList = [tagName];

    // Determine the category of the tag
    if (tagName.contains('-free')) {
      await UserCustomizationService.allergies(int.parse(user_id!), tagList);
    } else if (tagName.contains('Low') ||
        tagName.contains('High') ||
        tagName.contains('No')) {
      await UserCustomizationService.dietsFollowed(
          int.parse(user_id!), tagList);
    } else {
      await UserCustomizationService.setMealPerDay(
          int.parse(user_id!), tagList);
    }

    print("Tag clicked: $tagName");

    // Show snackbar upon successful submission
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$tagName saved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
