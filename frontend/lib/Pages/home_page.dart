import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage for storing and retrieving data securely
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/login_page.dart';
import 'package:frontend/Pages/profile_update_page.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import '../models/models.dart'; // Barrel file for models
import '../services/fetch_user_data_service.dart';
import '../services/meals_ nutrients_service.dart';
import '../widgets/widgets.dart'; // Barrel file for custom widgets
import '../utils/utils.dart'; // Barrel file for utilities
import '../components/components.dart'; // Barrel file for components
import '../services/user_health_records_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// State class for HomePage
class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  XFile? _profilePicture;
  final ImagePicker _picker = ImagePicker();
  final storage = FlutterSecureStorage();
  // Variable to hold user data
  String? userName;
  String? userProfilePicture;
  late FetchHealthRecordService fetchHealthRecordService;
  late FetchMealsNutrientsService fetchMealsNutrientsService;

  HealthRecord? lastHealthRecord;
  Meal? mealsNutrients;
  String? user_id;
  // Instance of secure storage
  // Variable to hold user data
  List<SuitableMenuModel> menu = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getMenu();
    _loadUserInfo();
    _loadUserData();
    fetchHealthRecordService = FetchHealthRecordService();
    fetchLastHealthRecord();
    fetchMealsNutrientsService = FetchMealsNutrientsService();
    fetchLastMealsNutrients();
  }

  Future<void> fetchLastHealthRecord() async {
    print('fetchLastHealthRecord called');
    if (user_id != null) {
      print('user_id is not null: $user_id');
      final int? userIdInt = int.tryParse(user_id!);
      if (userIdInt != null) {
        print('Parsed user_id to int: $userIdInt');
        try {
          final record =
              await fetchHealthRecordService.fetchLastHealthRecord(userIdInt);
          print('Received record: $record');
          if (record != null) {
            setState(() {
              lastHealthRecord = record;
              print('Set lastHealthRecord: $lastHealthRecord');
            });
          } else {
            print('No health record found for user');
          }
        } catch (e) {
          print('Error fetching health record: $e');
        }
      } else {
        print('Failed to parse user_id to int: $user_id');
      }
    } else {
      print('user_id is null');
    }
  }

  Future<void> fetchLastMealsNutrients() async {
    print('fetchMealsNutrients called');
    if (user_id != null) {
      print('user_id is not null: $user_id');
      final int? userIdInt = int.tryParse(user_id!);
      if (userIdInt != null) {
        print('Parsed user_id to int: $userIdInt');
        try {
          final record =
              await fetchMealsNutrientsService.fetchMealsNutrients(userIdInt);
          print('Received record: $record');
          if (record != null) {
            setState(() {
              mealsNutrients = record as Meal?;
              print('Set mealsNutrients: $mealsNutrients');
            });
          } else {
            print('No meals nutrients record found for user');
          }
        } catch (e) {
          print('Error fetching meals nutrients record: $e');
        }
      } else {
        print('Failed to parse user_id to int: $user_id');
      }
    } else {
      print('user_id is null');
    }
  }

// Handle the image of the profile picture
  Future<void> _loadUserInfo() async {
    final userInfo = await loadUserInfo();
    setState(() {
      userName = userInfo['userName'];
      userProfilePicture = userInfo['userProfilePicture'];
      user_id = userInfo['id'];
    });
  }

  Future<void> _loadUserData() async {
    final userName = await storage.read(key: 'user_name');
    final userId = await storage.read(key: 'user_id');

    setState(() {
      this.userName = userName;
      this.userProfilePicture = userProfilePicture;
      this.user_id = userId;
    });
    fetchLastHealthRecord();
    fetchLastMealsNutrients();
  }

  Future<void> _pickProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePicture = image;
      });
    }
  }

  void _getMenu() {
    menu = SuitableMenuModel.getMenu();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index);
  }

  Future<void> _handleLogout() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _authService.logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout Successful')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      // Show error message if logout fails
      print('Logout error: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Logout Failed'),
            content: const Text('An error occurred during logout.'),
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

  // Nutrients Details Section
  Column nutrientsDetailsSection() {
    return Column(
      children: [
        NutritionDetails(
          totalCalories: 0,
          proteinCalories: 0,
          fatsCalories: 0,
          carbsCalories: 0,
          fiberCalories: 0, // Ensure this key exists in the API response
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building HomePage. lastHealthRecord: $lastHealthRecord');
    ImageProvider<Object> imageProvider =
        getImageProvider(_profilePicture, userProfilePicture);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 217, 217),
      appBar: UserHeader(
        imageProvider: imageProvider,
        pageName: 'Home', // This will be shown as the page title
        welcomeMessage:
            'Hello Again!', // This will be shown as the welcome message
        userName: userName, // Use Text widget to display the user name
        userStatus: 'Active',
        rightIcon: Icons.notifications,
        showWelcomeMessage: true,
        topPadding: 50.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: blueColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName ?? 'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Profile Settings'),
              onTap: () {
                // Navigate to profile settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                );
              },
            ),
            const Spacer(),
            ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: _handleLogout),
          ],
        ),
      ),
      body: Column(
        children: [
          lowerContainer(),
          const SizedBox(height: 0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  nutrientsDetailsSection(),
                  riskOverviewSection(),
                  const SizedBox(height: 30),
                  healthRecordSection(),
                  const SizedBox(height: 40),
                  healthInformationLogsSection(),
                  const SizedBox(height: 40),
                  activityLogsSection(),
                  const SizedBox(height: 30),
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

  // Suitable menu sections
  Column lowerContainer() {
    return Column(
      children: [
        Container(
          color: pinkColor, // Background color
          height: 140.0,
          width: 420,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: menuSlider,
          ),
        ),
      ],
    );
  }

  // Suitable menu slider Section
  List<Widget> get menuSlider {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 3),
        child: Text(
          'Suitable Menu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Container(
        height: 95,
        child: ListView.separated(
          itemCount: menu.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 20, right: 20),
          separatorBuilder: (context, index) => const SizedBox(width: 15),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // Handle button press
                print('Item ${menu[index].name} pressed');
                // Add navigation or other logic here
              },
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  color: menu[index].boxColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(menu[index].imagePath),
                      ),
                    ),
                    Text(
                      menu[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  // Risk Overview Section
  Column riskOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Risk Overview',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blueColor,
              fontSize: 22.0,
            ),
          ),
        ),
        const SizedBox(height: 15),
        MonthlyRiskChart(monthlyRiskValues: [1, 1, 1, 1, 5, 22]),
        const SizedBox(height: 40),
        diabetesInfectionStatus(),
      ],
    );
  }

  // Health Record Section
  Column healthRecordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Health Records',
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
            bloodPressureRecord(),
            const SizedBox(width: 10),
            glucoseRecord(),
          ],
        ),
      ],
    );
  }

  // Health Information Logs Section
  Column healthInformationLogsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Health Information Logs',
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
            HealthMeasurementLogsCard(
                title: 'Blood Pressure',
                name: 'bloodPressure',
                onPressed: (int value) {
                  // Implement your backend sending logic here
                  if (user_id != null) {
                    UserHealthRecordsService.inputBloodPressure(
                        int.parse(user_id!), value.toString());
                  }
                }), // Use the HealthMeasurementLogsCard widget,
            HealthMeasurementLogsCard(
              title: 'Glucose Level',
              name: 'glucoseLevel',
              onPressed: (int value) {
                if (user_id != null) {
                  UserHealthRecordsService.inputBloodGlucose(
                      int.parse(user_id!), value);
                }
              },
            ), // Use the HealthMeasurementLogsCard widget
          ],
        ),
      ],
    );
  }

  // Activity Logs Section
  Column activityLogsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Activity Logs',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blueColor,
              fontSize: 22.0,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Container(
              width: 390, // Adjusted width for better alignment
              height: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(21, 18, 18, 18),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ExerciseRecord(),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 360, // Adjusted width for better alignment
              height: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 255, 255, 255),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: StressLevelSelector(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Glucose Record Widget
  Container glucoseRecord() {
    return Container(
      width: 180,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Glucose Level:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: pinkColor,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              lastHealthRecord != null
                  ? '${lastHealthRecord!.blood_glucose?.toString()}'
                  : 'N/A',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Blood Pressure Record Widget
  Container bloodPressureRecord() {
    return Container(
      width: 180,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Blood Pressure:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: pinkColor,
              ),
            ),
            SizedBox(width: 5),
            Text(
              lastHealthRecord != null
                  ? '${lastHealthRecord!.blood_pressure}/d'
                  : 'N/A',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Health Information Section
  Container diabetesInfectionStatus() {
    return Container(
      width: 380,
      height: 245,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0, left: 25),
            child: Text(
              'Overall Health Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: pinkColor,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(23.0),
              child: OverallHealthStatusPieChart(),
            ),
          ),
        ],
      ),
    );
  }
}
