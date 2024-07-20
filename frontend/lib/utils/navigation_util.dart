import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../pages/pages.dart'; // Update this to your actual pages import path

const String apiKey =
    'uPsCgdLq.jIrKCQePQaXday8iQYsqEgzpcHT1r7Tr'; // Replace with your actual API key

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
        MaterialPageRoute(builder: (context) => MealRecommendationsPage()),
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
        MaterialPageRoute(builder: (context) => ReportsViewPage()),
      );
      break;
    case 6:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileUpdatePage()),
      );
      break;
  }
}
