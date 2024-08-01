import 'package:flutter/material.dart';
import 'package:frontend/utils/utilities.dart';
import '../pages/pages.dart';
import '../utils/logout_utility.dart'; // Adjust import paths as needed

class CustomDrawer extends StatelessWidget {
  final String? userName;
  final ImageProvider imageProvider;
  final LogoutManager logoutManager;

  CustomDrawer({
    Key? key,
    this.userName,
    required this.imageProvider,
    required this.logoutManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: blueColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userName ?? 'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Profile Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => logoutManager.logout(),
          ),
        ],
      ),
    );
  }
}
