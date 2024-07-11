import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage for storing and retrieving data securely
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/models.dart'; // Barrel file for models
import '../widgets/customized_widgets.dart'; // Barrel file for custom widgets
import '../utils/utils.dart'; // Barrel file for utilities
import '../components/components.dart'; // Barrel file for components
import '../utils/navigation_util.dart';

// HomePage widget which accepts userData as a parameter
class HomePage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  // Constructor for HomePage which takes userData as a required parameter
  const HomePage({Key? key, required this.userData}) : super(key: key);

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
  XFile? _profilePicture;
  final ImagePicker _picker = ImagePicker();
  final storage = FlutterSecureStorage();
  Map<String, dynamic>? userData; // Instance of secure storage
  // Variable to hold user data
  List<SuitableMenuModel> menu = [];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index, widget.userData);
  }

  // Function to pick a profile picture from the gallery
  Future<void> _pickProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePicture = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
    _getMenu();
  }

  void _getMenu() {
    menu = SuitableMenuModel.getMenu();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the profile picture URL from the user data and prepend the base URL
    String profilePictureUrl =
        'http://10.0.2.2:8000${userData!['profile_picture']}';
    print('Build User Data: $userData');
    ImageProvider<Object> imageProvider;
    if (_profilePicture != null) {
      imageProvider = FileImage(File(_profilePicture!.path));
    } else {
      imageProvider = NetworkImage('assets/images/diabetesLogo.png');
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: UserHeader(
        imageProvider: imageProvider,
        imagePath: 'assets/images/diabetesLogo.png',
        pageName: 'Home', // This will be shown as the page title
        welcomeMessage:
            'Hello Again!', // This will be shown as the welcome message
        userName: '${userData!['name']}',
        userStatus: 'Active',
        rightIcon: Icons.notifications,
        showWelcomeMessage: true,
        topPadding: 50.0,
      ),
      body: Column(
        children: [
          lowerContainer(),
          const SizedBox(height: 00),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  nutrientsDetailsSection(),
                  riskOverviewSection(),
                  const SizedBox(height: 20),
                  healthRecordSection(),
                  const SizedBox(height: 10),
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

//suitable menu sections
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

//suitable menu slider
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
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          separatorBuilder: (context, index) => SizedBox(width: 15),
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
}

//nutrientsDetails Section
Column nutrientsDetailsSection() {
  return Column(
    children: [
      const SizedBox(height: 4),
      Container(
        height: 195.0,
        width: 420,
        color: Color.fromARGB(217, 217, 217, 217),
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
            SizedBox(height: 10),
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
                  textColor: Color.fromARGB(255, 227, 204, 32),
                ),
                AnimatedNutritionContainer(
                  title: 'Fiber',
                  calories: 50, // Specific calories for Fiber
                  maxCalories: 100,
                  textColor: Color.fromARGB(255, 3, 58, 16),
                ),
              ],
            ),
          ],
        ),
      )

// Declare the variable somewhere in class
//int calories = 250; // Example variable for calories
    ],
  );
}

//Risk Overview Section
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
      const SizedBox(height: 10),
      monthlyRiskChart(),
      const SizedBox(height: 30),
      diabetesInfectionStatus(),
    ],
  );
}

//Risk Overview Section
Column healthRecordSection() {
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
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          glucoseRecord(),
          const SizedBox(width: 10),
          bloodPressureRecord(),
        ],
      ),
    ],
  );
}

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
      child: const Center(
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
            SizedBox(
              width: 5,
            ),
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
      ));
}

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
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the row's children
          children: [
            Text(
              'Blood Pressure:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: pinkColor,
              ),
            ),
            SizedBox(
              width: 5,
            ),
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
      ));
}

Container monthlyRiskChart() {
  return Container(
    width: 380,
    height: 250,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
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
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 25),
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
                lineTouchData:
                    LineTouchData(touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final textStyle = TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      );
                      return LineTooltipItem(
                          touchedSpot.y.toString(), textStyle);
                    }).toList();
                  },
                )),
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
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Transform.translate(
                      offset: Offset(26, -16),
                      child: Text(
                        'Risk Percentage (RP)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: blueColor,
                        ),
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 60,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text('Month of the Year'),
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

//Health Information Section
Container diabetesInfectionStatus() {
  return Container(
    width: 380,
    height: 245,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
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
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 25),
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

/*
 
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${userData!['name']}'),
                  Text('Email: ${userData!['email']}'),
                  Text('Gender: ${userData!['gender']}'),
                  Text('Marital Status: ${userData!['marital_status']}'),
                  Text('Height: ${userData!['height']}'),
                  Text('Birthdate: ${userData!['birthdate']}'),
                  Text('Family History: ${userData!['family_history']}'),
                  Text('Profile Picture: ${userData!['profile_picture']}'),
                ],
              ),
            ),
    );
  }
}

*/

/*

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}



  @override
  Widget build(BuildContext context) {
   
*/
