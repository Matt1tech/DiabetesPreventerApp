import 'package:flutter/material.dart';
import 'package:frontend/loginPage.dart';
import 'utilties.dart';
import 'registerPage.dart';

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
      body: Column(
        children: [
          header(
              imagePath: 'images/diabetesLogo.png',
              welcomeMessage: 'Select Carefully!'), // Using header widget
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
              'images/diabetesLogo.png',
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
                // Back button
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(75, 25)),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return blueColor
                            .withOpacity(0.8); // Slightly darker when pressed
                      } else if (states.contains(MaterialState.hovered)) {
                        return Color.fromARGB(255, 49, 107, 231)
                            .withOpacity(0.9); // Slightly lighter when hovered
                      }
                      return blueColor;
                    }),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black12; // Dark overlay when pressed
                      }
                      return Colors.transparent; // No overlay by default
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back on button press
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center the content horizontally
                    children: const [
                      Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ), // Back arrow icon
                      SizedBox(width: 15), // Space between icon and text
                      Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white, // Text color set correctly
                        ),
                      ),
                    ],
                  ),
                ),

                // Continue button
                Builder(
                  builder: (context) => TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      'Continue >>',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
