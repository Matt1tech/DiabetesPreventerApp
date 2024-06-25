import 'package:flutter/material.dart';
import '../utilties.dart';
import 'registerPage.dart';
import '../customHeader.dart';

class FamilyHistoryPage extends StatefulWidget {
  const FamilyHistoryPage({super.key});

  @override
  _FamilyHistoryPageState createState() => _FamilyHistoryPageState();
}

class _FamilyHistoryPageState extends State<FamilyHistoryPage> {
  // State for toggle buttons
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 141, 87, 255),
      appBar: CustomHeader(
        imagePath: 'assets/images/diabetesLogo.png',
        welcomeMessage: 'Select Carefully!',
        showWelcomeMessage:
            true, // Set to false if you don't want the welcome message
      ),
      body: Column(
        children: [
          Expanded(
            child:
                bodyFamilyHistory(), // Using the body specific to family history
          ),
          footer(), // Using footer widget
        ],
      ),
    );
  }

  Widget bodyFamilyHistory() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top image
            Image.asset(
              'assets/images/diabetesLogo.png',
              width: 120, // Adjust width as needed
              height: 120, // Adjust height as needed
            ),
            const SizedBox(height: 20),
            // Question text
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Do you have '),
                  TextSpan(
                    text: 'Family History',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' with '),
                  TextSpan(
                    text: 'Diabetes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' ?'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Using CustomToggleButtons for Yes/No selection
            CustomToggleButtons(
              options: const ['Yes', 'No'],
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    isSelected[buttonIndex] = buttonIndex == index;
                  }
                });
              },
            ),
            const SizedBox(height: 70),
            // Navigation buttons

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(120, 50), // Consistent button size
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Padding inside the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    foregroundColor: Colors.white,
                  ).copyWith(
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.white
                              .withOpacity(0.2); // Lighter overlay when pressed
                        }
                        return Colors.transparent; // Transparent by default
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back on button press
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Continue button
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(120, 50), // Consistent button size
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Padding inside the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    foregroundColor: Colors
                        .white, // Replace with your color variable if needed
                  ).copyWith(
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.white
                              .withOpacity(0.2); // Lighter overlay when pressed
                        }
                        return Colors.transparent; // Transparent by default
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
