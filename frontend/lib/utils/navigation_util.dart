import 'package:flutter/material.dart';
import '../pages/pages.dart'; // Update this to your actual pages import path

void navigateToPage(BuildContext context, int index) {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NutrientationPage()),
      );
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
