import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Pages/support.dart';
import '../pages/pages.dart';

const String apiKey =
    'uPsCgdLq.jIrKCQePQaXday8iQYsqEgzpcHT1r7Tr'; // Replace with  API key

Future<void> navigateToPage(BuildContext context, int index) async {
  switch (index) {
    case 0:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      break;
    case 1:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MealRecordsPage()),
      );
      break;
    case 2:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomizationsPage()),
      );
      break;
    case 3:
      // Open camera and take picture for NutrientationPage
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NutrientationPage(
              imageFile: File(pickedFile.path),
              apiKey: apiKey,
            ),
          ),
        );
      } else {
        // Handle the case where the user didn't take a picture
        // For now, we'll just return to the current page
      }
      break;
    case 4:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ReportsGenerationPage()),
      );
      break;
    case 5:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RecommendationsPage()),
      );
      break;
    case 6:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ClientSupportPage()),
      );
      break;
  }
}
