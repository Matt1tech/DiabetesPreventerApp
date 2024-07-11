import 'package:flutter/material.dart';
import '../pages/pages.dart'; // Update this to your actual pages import path

void navigateToPage(
    BuildContext context, int index, Map<String, dynamic>? userData) {
  switch (index) {
    case 0:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userData: userData)),
      );
      break;
    case 1:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MealRecommendationsPage(userData: userData)),
      );
      break;
    case 2:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CustomizationsPage(userData: userData)),
      );
      break;
    case 3:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => NutrientationPage(userData: userData)),
      );
      break;
    case 4:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ReportsGenerationPage(userData: userData)),
      );
      break;
    case 5:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ReportsViewPage(userData: userData)),
      );
      break;
    case 6:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileUpdatePage(userData: userData)),
      );
      break;
  }
}
