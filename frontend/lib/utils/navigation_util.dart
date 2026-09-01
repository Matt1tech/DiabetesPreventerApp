import 'package:flutter/material.dart';
import 'package:frontend/Pages/support.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../pages/pages.dart';

Future<void> navigateToPage(BuildContext context, int index,
    {int initialSectionIndex = 1}) async {
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
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NutrientationPage(
              imageFile: File(pickedFile.path),
            ),
          ),
        );
      } else {
        // Handle the case where the user didn't take a picture
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
        MaterialPageRoute(
            builder: (context) =>
                RecommendationsPage(initialSectionIndex: initialSectionIndex)),
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
