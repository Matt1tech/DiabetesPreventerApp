import 'package:flutter/material.dart';
import 'utilities.dart';

class UserHeader extends StatelessWidget implements PreferredSizeWidget {
  final String imagePath;
  final String welcomeMessage; // Renamed for clarity (was pageName)
  final String? pageName; // Renamed for clarity (was welcomeMessage)
  final String? userName; // Optional argument for user's name
  final String? userStatus; // Optional argument for user's status
  final IconData? rightIcon; // Optional argument for right-side icon
  final bool showWelcomeMessage;
  final double topPadding;

  UserHeader({
    required this.imagePath,
    required this.welcomeMessage, // Required welcome message
    this.pageName, // Optional page name
    this.userName,
    this.userStatus,
    this.rightIcon,
    this.showWelcomeMessage = true,
    this.topPadding = 50.0, // Default top padding to lower the header
  });

  @override
  Size get preferredSize => showWelcomeMessage
      ? const Size.fromHeight(170.0)
      : const Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(top: topPadding), // Adjust top padding here
          child: AppBar(
            backgroundColor: blueColor,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Space between avatar and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        welcomeMessage, // Now showing the welcome message
                        style: const TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                        ),
                      ),
                      if (userName != null) // Display user's name if provided
                        const SizedBox(height: 5),
                      if (userName != null)
                        Text(
                          userName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  if (rightIcon != null) const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      rightIcon,
                      color: Colors.white,
                    ),
                    iconSize: 30.0,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showWelcomeMessage)
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(217, 217, 217, 217),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // Shadow color
                  blurRadius: 2.0, // Shadow blur radius
                  offset: Offset(0, 2), // Shadow position
                ),
              ],
            ),
            height: 50,
            width: double.infinity, // Full width
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pageName ?? '', // Now showing the page name
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: blueColor,
                    ),
                  ),
                  if (userStatus != null)
                    Text(
                      userStatus!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromRGBO(16, 103, 12, 1),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
