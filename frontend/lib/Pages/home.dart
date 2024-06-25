import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/models/suitableMenu_modal.dart';
import 'package:frontend/nutritionContainer.dart';
import '../userHeader.dart';
import '../utilties.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SuitableMenuModel> menu = [];

  void _getMenu() {
    menu = SuitableMenuModel.getMenu();
  }

  @override
  Widget build(BuildContext context) {
    _getMenu();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: UserHeader(
        imagePath: 'assets/images/diabetesLogo.png',
        pageName: 'Home', // This will be shown as the page title
        welcomeMessage:
            'Hello Again!', // This will be shown as the welcome message
        userName: 'ALBUKAAI MOHAMAD',
        userStatus: 'Active',
        rightIcon: Icons.notifications,
        showWelcomeMessage: true,
        topPadding: 50.0,
      ),
      body: Column(children: [
        lowerContainer(),
        const SizedBox(height: 10),
        nutrientsDetailsSection(),
      ]),
    );
  }

//suitable menu sections
  Column lowerContainer() {
    return Column(
      children: [
        Container(
          color: pinkColor, // Background color
          height: 160.0,
          width: 420,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: menuSlider,
          ),
        ),

        // You can add more widgets here
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
        height: 100,
        child: ListView.separated(
            itemCount: menu.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            separatorBuilder: (context, index) => SizedBox(width: 15),
            itemBuilder: (context, index) {
              return Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: menu[index].boxColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
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
                      )
                    ],
                  ));
            }),
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
        height: 170.0,
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
                  calories: 90, // Specific calories for Protein
                  maxCalories: 200,
                  textColor: const Color.fromARGB(255, 164, 103, 12),
                ),
                AnimatedNutritionContainer(
                  title: 'Fats',
                  calories: 70, // Specific calories for Fats
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
                  calories: 40, // Specific calories for Fiber
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
