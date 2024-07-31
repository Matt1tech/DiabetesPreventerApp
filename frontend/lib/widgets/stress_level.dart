import 'package:flutter/material.dart';
import 'package:frontend/utils/utilities.dart';

/// A widget that allows users to select their stress level.
class StressLevelSelector extends StatefulWidget {
  @override
  _StressLevelSelectorState createState() => _StressLevelSelectorState();
}

class _StressLevelSelectorState extends State<StressLevelSelector> {
  int selectedStressLevel = -1;

  /// List of stress level descriptions.
  final List<String> stressDescriptions = [
    "0 - No Stress",
    "1 - Low",
    "2 - Mild",
    "3 - Moderate",
    "4 - High",
    "5 - Very High",
    "6 - Severe",
    "7 - Max Stress"
  ];

  /// List of colors corresponding to each stress level.
  final List<Color> stressColors = [
    Colors.green,
    Color.fromARGB(255, 18, 101, 61),
    const Color.fromARGB(255, 82, 139, 17),
    Color.fromARGB(255, 169, 152, 1),
    const Color.fromARGB(255, 221, 128, 122),
    Colors.orange,
    Colors.deepOrange,
    Colors.red,
    Colors.redAccent,
    Colors.red,
    Colors.red[900]!,
  ];

  /// List of icons corresponding to each stress level.
  final List<IconData> stressIcons = [
    Icons.sentiment_very_satisfied,
    Icons.sentiment_satisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_very_dissatisfied,
  ];

  /// Method to handle saving the selected stress level.
  void saveStressLevel() {
    if (selectedStressLevel != -1) {
      print('Selected Stress Level: $selectedStressLevel');
      // Add further handling logic here, e.g., sending the value to a server
    } else {
      print('No stress level selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stress Level',
              style: TextStyle(
                fontSize: 22,
                color: pinkColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: stressDescriptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStressLevel = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: selectedStressLevel == index
                            ? stressColors[index].withOpacity(0.3)
                            : Colors.white,
                        border: Border.all(
                          color: selectedStressLevel == index
                              ? stressColors[index]
                              : const Color.fromARGB(255, 158, 158, 158),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20, // Make the CircleAvatar slightly larger
                            child: Icon(
                              stressIcons[index],
                              color: selectedStressLevel == index
                                  ? stressColors[index]
                                  : Color.fromARGB(255, 235, 200, 6),
                              size: 30, // Make the emoji icon slightly larger
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            stressDescriptions[index],
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedStressLevel == index
                                  ? stressColors[index]
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: saveStressLevel,
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
