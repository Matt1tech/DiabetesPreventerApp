import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/models/suitable_menu_modal.dart';
import 'package:frontend/models/chart.dart';
import 'package:frontend/nutrition_container.dart';
import '../user_header.dart';
import '../utilities.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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

class _HomePageState extends State<HomePage> {
  List<SuitableMenuModel> menu = [];

  void _getMenu() {
    menu = SuitableMenuModel.getMenu();
  }

  int _selectedIndex = 0; // Define the selected index variable
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //suitable menu model
    _getMenu();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: UserHeader(
        imagePath: 'assets/images/diabetesLogo.png',
        pageName: 'Home', // This will be shown as the page title
        welcomeMessage:
            'Hello Again!', // This will be shown as the welcome message
        userName: 'MOHAMAD ALBUKAAI',
        userStatus: 'Active',
        rightIcon: Icons.notifications,
        showWelcomeMessage: true,
        topPadding: 50.0,
      ),
      body: Column(
        children: [
          lowerContainer(),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  nutrientsDetailsSection(),
                  const SizedBox(height: 10),
                  riskOverviewSection(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: blueColor, // Set the background color to blue
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Meal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: 'Custom',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_alt,
              size: 40,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Package',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Support',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: pinkColor, // Set the selected item color to pink
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }

//suitable menu sections
  Column lowerContainer() {
    return Column(
      children: [
        Container(
          color: pinkColor, // Background color
          height: 155.0,
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
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 20),
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
                  boxShadow: [
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
                      decoration: BoxDecoration(
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
                      style: TextStyle(
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
        height: 200.0,
        width: 420,
        color: Color.fromARGB(217, 217, 217, 217),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
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
      Padding(
        padding: const EdgeInsets.only(left: 4),
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
      healthInformationSection(),
    ],
  );
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
Container healthInformationSection() {
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
