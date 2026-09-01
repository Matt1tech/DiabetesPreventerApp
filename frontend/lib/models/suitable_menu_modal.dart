import 'package:flutter/material.dart';

class SuitableMenuModel {
  String name;
  String imagePath;
  Color boxColor;

  // Constructor
  SuitableMenuModel({
    required this.name,
    required this.imagePath,
    required this.boxColor,
  });

  static List<SuitableMenuModel> getMenu() {
    return [
      SuitableMenuModel(
        name: "Main",
        imagePath: "assets/icons/lunch.svg",
        boxColor: Colors.white,
      ),
      SuitableMenuModel(
        name: "Deserts",
        imagePath: "assets/icons/piece-of-cake.svg",
        boxColor: Colors.white,
      ),
      SuitableMenuModel(
        name: "Salad",
        imagePath: "assets/icons/salad.svg",
        boxColor: Colors.white,
      ),
      SuitableMenuModel(
        name: "Snack",
        imagePath: "assets/icons/snack.svg",
        boxColor: Colors.white,
      ),
    ];
  }
}
