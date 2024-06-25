import 'package:flutter/material.dart';

class SuitableMenuModel {
  String name;
  String imagePath;
  Color boxColor;

  //constructor
  SuitableMenuModel({
    required this.name,
    required this.imagePath,
    required this.boxColor,
  });
  static List<SuitableMenuModel> getMenu() {
    List<SuitableMenuModel> menu = [];
    menu.add(SuitableMenuModel(
      name: "Main",
      imagePath: "assets/icons/lunch.svg",
      boxColor: Color.fromARGB(255, 255, 255, 255),
    ));
    menu.add(SuitableMenuModel(
      name: "Deserts",
      imagePath: "assets/icons/piece-of-cake.svg",
      boxColor: Color.fromARGB(255, 255, 255, 255),
    ));
    menu.add(SuitableMenuModel(
      name: "Salad",
      imagePath: "assets/icons/salad.svg",
      boxColor: Color.fromARGB(255, 255, 255, 255),
    ));
    menu.add(SuitableMenuModel(
      name: "Snack",
      imagePath: "assets/icons/snack.svg",
      boxColor: Color.fromARGB(255, 255, 255, 255),
    ));

    menu.add(SuitableMenuModel(
      name: "Snack",
      imagePath: "assets/icons/snack.svg",
      boxColor: Color.fromARGB(255, 255, 255, 255),
    ));

    return menu;
  }
}
