import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage for storing and retrieving data securely
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/login_page.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/utils/image_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../models/models.dart'; // Barrel file for models
import '../widgets/widgets.dart'; // Barrel file for custom widgets
import '../utils/utils.dart'; // Barrel file for utilities
import '../components/components.dart'; // Barrel file for components

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// Example list of monthly risk values for diabetes
List<double> monthlyRiskValues = [10, 15, 14, 34, 0, 22];
// Function to convert the list of risk values into a list of FlSpot objects
List<FlSpot> getMonthlySpots(List<double> values) {
  return List.generate(
      values.length, (index) => FlSpot(index.toDouble(), values[index]));
}

// Function to create bottom titles for the months of the year
SideTitles monthOfYearBottomTitles() {
  return SideTitles(
    showTitles: true,
    getTitlesWidget: (value, meta) {
      const style = TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      );
      Widget text;
      switch (value.toInt()) {
        case 0:
          text = const Text('Jan', style: style);
          break;
        case 1:
          text = const Text('Feb', style: style);
          break;
        case 2:
          text = const Text('Mar', style: style);
          break;
        case 3:
          text = const Text('Apr', style: style);
          break;
        case 4:
          text = const Text('May', style: style);
          break;
        case 5:
          text = const Text('Jun', style: style);
          break;
        default:
          text = const Text('', style: style);
          break;
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 5.0, // Reduce the space between the chart and the titles
        child: text,
      );
    },
    interval: 1,
  );
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
  }

//handle the image of the profile picture
  Future<void> _loadUserInfo() async {
    final userInfo = await loadUserInfo();
    setState(() {
      userName = userInfo['userName'];
      userProfilePicture = userInfo['userProfilePicture'];
      user_id = userInfo['id'];
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
      Navigator.pushReplacementNamed(context, '/login');
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

  @override
  Widget build(BuildContext context) {
    final bloodGlucose = 'N/A';

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
                color: Colors.blue,
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
                Navigator.pushNamed(context, '/profile');
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
                  nutrientsDetailsSection(),
                  riskOverviewSection(),
                  const SizedBox(height: 30),
                  healthRecordSection(bloodGlucose),
                  const SizedBox(height: 30),
                  healthInformationLogsSection(),
                  const SizedBox(height: 30),
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

  // Nutrients Details Section
  Column nutrientsDetailsSection() {
    return Column(
      children: [
        const SizedBox(height: 4),
        Container(
          height: 195.0,
          width: 420,
          color: const Color.fromARGB(217, 217, 217, 217),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Nutrientation Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: AnimatedHorizontalContainer(
                  title: 'Total Calories',
                  calories: 1000, // Specific calories
                  maxCalories: 2000,
                  fillColor: pinkColor,
                  textColor: pinkColor,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedNutritionContainer(
                    title: 'Protein',
                    calories: 100, // Specific calories for Protein
                    maxCalories: 200,
                    textColor: const Color.fromARGB(255, 164, 103, 12),
                  ),
                  AnimatedNutritionContainer(
                    title: 'Fats',
                    calories: 150, // Specific calories for Fats
                    maxCalories: 300,
                    textColor: pinkColor,
                  ),
                  AnimatedNutritionContainer(
                    title: 'Carbs',
                    calories: 200, // Specific calories for Carbs
                    maxCalories: 400,
                    textColor: const Color.fromARGB(255, 227, 204, 32),
                  ),
                  AnimatedNutritionContainer(
                    title: 'Fiber',
                    calories: 50, // Specific calories for Fiber
                    maxCalories: 100,
                    textColor: const Color.fromARGB(255, 3, 58, 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Risk Overview Section
  Column riskOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'Risk Overview',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blueColor,
              fontSize: 18.0,
            ),
          ),
        ),
        const SizedBox(height: 20),
        monthlyRiskChart(),
        const SizedBox(height: 30),
        diabetesInfectionStatus(),
      ],
    );
  }

  // Health Record Section
  Column healthRecordSection(String bloodGlucose) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Health Records',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blueColor,
              fontSize: 18.0,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            glucoseRecord(bloodGlucose),
            const SizedBox(width: 10),
            bloodPressureRecord(),
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
              fontSize: 18.0,
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
            ), // Use the HealthMeasurementLogsCard widget,
            HealthMeasurementLogsCard(
              title: 'Glucose Level',
              name: 'glucoseLevel',
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
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Activity and Meal Logs',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blueColor,
              fontSize: 18.0,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [],
        ),
      ],
    );
  }

  // Glucose Record Widget
  Container glucoseRecord(String bloodGlucose) {
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
              '$bloodGlucose',
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
      child: const Center(
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
              '125 mg/dl',
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

  // Monthly Risk Chart Widget
  Container monthlyRiskChart() {
    return Container(
      width: 380,
      height: 250,
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
              'Monthly Risk',
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
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final textStyle = const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          );
                          return LineTooltipItem(
                              touchedSpot.y.toString(), textStyle);
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      color: blueColor,
                      spots: getMonthlySpots(monthlyRiskValues),
                      barWidth: 3,
                      isCurved: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color:
                                pinkColor, // Change this color to your desired color
                            strokeWidth: 2,
                            strokeColor: const Color.fromARGB(255, 78, 70, 70),
                          );
                        },
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Transform.translate(
                        offset: const Offset(26, -16),
                        child: const Text(
                          'Risk Percentage (RP)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: blueColor,
                          ),
                        ),
                      ),
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Month of the Year'),
                      sideTitles: monthOfYearBottomTitles(),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey,
                        strokeWidth: 0.5,
                      );
                    },
                    drawVerticalLine: true,
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
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
