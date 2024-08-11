import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage for storing and retrieving data securely
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import '../models/models.dart'; // Barrel file for models
import '../services/customization_service.dart';
import '../services/fetch_user_data_service.dart';
import '../services/nutrients_service.dart';
import '../services/physical_activities_records_service.dart';
import '../utils/logout_utility.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/widgets.dart'; // Barrel file for custom widgets
import '../utils/utils.dart'; // Barrel file for utilities
import '../components/components.dart'; // Barrel file for components
import '../services/user_health_records_service.dart';
import 'recommendations_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

// State class for HomePage
class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  XFile? _profilePicture;
  final storage = FlutterSecureStorage();
  String? userName;
  String? userProfilePicture;
  late FetchHealthRecordService fetchHealthRecordService;
  late FetchUserCustomizationsService fetchUserCustomizationsService;
  final NutritionService nutritionService = NutritionService();
  Map<String, dynamic> nutritionData =
      {}; // Ensure this is initialized to handle null cases
  HealthRecord? lastHealthRecord;
  String? user_id;
  late LogoutManager logoutManager;
  // Variable to hold user data
  final List<SuitableMenuModel> menu = SuitableMenuModel.getMenu();

  int _selectedIndex = 0;
  final PhysicalActivityRecordsService service =
      PhysicalActivityRecordsService();
  Customizations? userCustomizations;
  final ImagePicker _picker = ImagePicker();
  List<double> monthlyRiskValues = []; // Default value

  void _navigateToRecommendationsPage(int initialSectionIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationsPage(
          initialSectionIndex: initialSectionIndex,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _loadUserInfo();
    _loadUserData();
    fetchHealthRecordService = FetchHealthRecordService();
    fetchUserCustomizationsService = FetchUserCustomizationsService();
    fetchLastHealthRecord();
    fetchDailyNutrition();
    fetchUserCustomizations();
    logoutManager = LogoutManager(context: context, authService: _authService);
    fetchRiskData(); // Fetch the risk data
  }

  Future<List<double>> fetchMonthlyRisk() async {
    if (user_id != null) {
      final int? userIdInt = int.tryParse(user_id!);
      if (userIdInt != null) {
        try {
          final monthlyRiskList = await RiskService.fetchMonthlyRisk(userIdInt);
          print(
              "Fetched monthly risk data: ${monthlyRiskList.map((risk) => risk.risk)}");
          return monthlyRiskList
              .map((risk) => double.parse((risk.risk).toStringAsFixed(6)))
              .toList();
        } catch (e) {
          print('Error fetching monthly risk data: $e');
        }
      }
    }
    return List.filled(
        6, 0.0); // Default to 0.0 for six months if there's an error
  }

  Future<void> fetchRiskData() async {
    final riskData = await fetchMonthlyRisk();
    if (mounted) {
      setState(() {
        monthlyRiskValues =
            riskData.reversed.toList(); // Reverse the list to correct order
        print("Monthly risk values set in state: $monthlyRiskValues");
      });
    }
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
            if (mounted) {
              setState(() {
                lastHealthRecord = record;
                print('Set lastHealthRecord: $lastHealthRecord');
              });
            }
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

  Future<void> fetchUserCustomizations() async {
    print('fetchUserCustomizations called');
    if (user_id != null) {
      print('user_id is not null: $user_id');
      final int? userIdInt = int.tryParse(user_id!);
      if (userIdInt != null) {
        try {
          final customizations = await fetchUserCustomizationsService
              .fetchUserCustomizations(userIdInt);
          print('Received customizations: $customizations');
          if (customizations != null) {
            if (mounted) {
              setState(() {
                userCustomizations = customizations;
                print('Set userCustomizations: $userCustomizations');
              });
            }
          }
        } catch (e) {
          print('Error fetching customizations: $e');
        }
      } else {
        print('Failed to parse user_id to int: $user_id');
      }
    }
  }

  Future<void> fetchDailyNutrition() async {
    print('fetchDailyNutrition called');
    if (user_id != null) {
      final double? parsedDouble = double.tryParse(user_id!);
      final int? userIdInt =
          parsedDouble?.toInt(); // Safely convert double to int
      if (userIdInt != null) {
        try {
          final nutritionData =
              await nutritionService.fetchDailyNutrition(userIdInt);
          if (mounted) {
            setState(() {
              this.nutritionData =
                  nutritionData; // This triggers the widget to rebuild
            });
          }
        } catch (e) {
          print('Error fetching nutrition data: $e');
        }
      } else {
        print('Failed to parse user_id to int: $user_id');
      }
    } else {
      print('user_id is null');
    }
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
      fetchLastHealthRecord();
      fetchDailyNutrition();
      fetchUserCustomizations();
      fetchRiskData(); // Fetch the risk data
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index);
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
      drawer: CustomDrawer(
        userName: userName,
        imageProvider: imageProvider,
        logoutManager:
            LogoutManager(context: context, authService: _authService),
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
                  const SizedBox(height: 20),
                  nutrientsDetailsSection(),
                  const SizedBox(height: 10),
                  riskOverviewSection(),
                  const SizedBox(height: 50),
                  healthRecordSection(),
                  const SizedBox(height: 50),
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
          height: 150.0,
          width: 420,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildMenuSlider(),
          ),
        ),
      ],
    );
  }

  // Suitable menu slider Section
  List<Widget> _buildMenuSlider() {
    return [
      const Padding(
        padding: EdgeInsets.only(left: 16, top: 8),
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
        width: double.infinity,
        child: ListView.separated(
          itemCount: menu.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 20, right: 20),
          separatorBuilder: (context, index) => const SizedBox(width: 20),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _navigateToRecommendationsPage(index + 1);
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

  // Nutrients Details Section
  Container nutrientsDetailsSection() {
    return Container(
      width: 380,
      height: 220,
      child: NutritionDetails(
        totalCalories: (nutritionData['total_calories'] ?? 0).toInt(),
        proteinCalories: (nutritionData['total_protein'] ?? 0).toInt(),
        fatsCalories: (nutritionData['total_fats'] ?? 0).toInt(),
        carbsCalories: (nutritionData['total_carbs'] ?? 0).toInt(),
        fiberCalories: (nutritionData['total_fiber'] ?? 0).toInt(),
        maxTotalCalories: (userCustomizations?.dailyCaloriesMax != null &&
                userCustomizations!.dailyCaloriesMax > 0)
            ? userCustomizations!.dailyCaloriesMax.toInt()
            : 2000,
        maxProteinCalories: (userCustomizations?.maxProtein != null &&
                userCustomizations!.maxProtein > 0)
            ? userCustomizations!.maxProtein.toInt()
            : 180,
        maxFatsCalories: (userCustomizations?.maxFat != null &&
                userCustomizations!.maxFat > 0)
            ? userCustomizations!.maxFat.toInt()
            : 250,
        maxCarbsCalories: (userCustomizations?.maxCarbs != null &&
                userCustomizations!.maxCarbs > 0)
            ? userCustomizations!.maxCarbs.toInt()
            : 300,
        maxFiberCalories: (userCustomizations?.maxFiber != null &&
                userCustomizations!.maxFiber > 0)
            ? userCustomizations!.maxFiber.toInt()
            : 105,
      ),
    );
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
        MonthlyRiskChart(
            monthlyRiskValues: monthlyRiskValues), // Use dynamic values here
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
                if (user_id != null) {
                  UserHealthRecordsService.inputBloodPressure(
                      int.parse(user_id!), value);
                }
              },
              width: 180, // Specify the width as needed
              height: 160, // Specify the height as needed
              cardColor: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            HealthMeasurementLogsCard(
              title: 'Glucose Level',
              name: 'glucoseLevel',
              onPressed: (int value) {
                if (user_id != null) {
                  UserHealthRecordsService.inputBloodGlucose(
                      int.parse(user_id!), value);
                }
              },
              width: 180, // Specify the width as needed
              height: 160, // Specify the height as needed
              cardColor: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        Center(
          child: HealthMeasurementLogsCard(
            title: 'Daily Weight',
            name: 'Weight',
            onPressed: (int value) {
              if (user_id != null) {
                UserHealthRecordsService.inputDailyWeight(
                    int.parse(user_id!), value);
              }
            },
            width: 370, // Specify the width as needed
            height: 160, // Specify the height as needed
            cardColor: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 1),
              ),
            ],
          ),
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
          padding: EdgeInsets.only(left: 32),
          child: Text(
            'Activity Logs',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blueColor,
              fontSize: 22.0,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            user_id != null
                ? ExerciseRecord(userId: user_id!, service: service)
                : Center(
                    child: CircularProgressIndicator(
                    semanticsLabel: 'Loading..',
                  )), // Show a loading indicator or a placeholder

            const SizedBox(height: 40),
            user_id != null
                ? StressLevelSelector(userId: user_id!, service: service)
                : Center(child: CircularProgressIndicator()),
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
            const Text(
              'Glucose Level:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: pinkColor,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              lastHealthRecord?.blood_glucose != null
                  ? lastHealthRecord!.blood_glucose!.toInt().toString()
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
            const Text(
              'Blood Pressure:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: pinkColor,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              lastHealthRecord?.blood_pressure != null
                  ? lastHealthRecord!.blood_pressure!.toInt().toString()
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
              child: OverallHealthStatusPieChart(
                healthyPercentage:
                    lastHealthRecord?.diabetes_risk_probability_class_0 != null
                        ? double.parse((lastHealthRecord!
                                    .diabetes_risk_probability_class_0! *
                                10)
                            .toStringAsFixed(2))
                        : 0,
                preDiabetesPercentage:
                    lastHealthRecord?.diabetes_risk_probability_class_1 != null
                        ? double.parse((lastHealthRecord!
                                    .diabetes_risk_probability_class_1! *
                                10)
                            .toStringAsFixed(2))
                        : 0,
                diabetesPercentage:
                    lastHealthRecord?.diabetes_risk_probability_class_2 != null
                        ? double.parse((lastHealthRecord!
                                    .diabetes_risk_probability_class_2! *
                                10)
                            .toStringAsFixed(2))
                        : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
