import 'package:flutter/material.dart';
import '../utils/utilities.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Set the type to fixed
      backgroundColor: Colors.white, // Set the background color to white
      unselectedItemColor: blueColor, // Set the unselected item color to blue
      selectedItemColor: pinkColor, // Set the selected item color to pink
      selectedLabelStyle: TextStyle(
        fontSize: 10, // Set the desired font size for selected labels
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10, // Set the desired font size for unselected labels
      ),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: 'Meal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tune),
          label: 'Custom',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.camera_alt,
            size: 40, // Set the desired size for the camera icon
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_chart),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.recommend),
          label: 'For You',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support_agent),
          label: 'Support',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      showUnselectedLabels: true,
      elevation: 0,
    );
  }
}
