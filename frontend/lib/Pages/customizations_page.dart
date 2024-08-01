import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/Pages/pages.dart';
import 'package:frontend/services/fetch_user_data_service.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../utils/utilities.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/navigation_util.dart';
import '../urls.dart';

class CustomizationsPage extends StatefulWidget {
  CustomizationsPage({Key? key}) : super(key: key);

  @override
  _CustomizationsPageState createState() => _CustomizationsPageState();
}

class _CustomizationsPageState extends State<CustomizationsPage> {
  final AuthService _authService = AuthService();

  int _selectedIndex = 2;
  bool isLoading = false;
  XFile? _profilePicture;
  String? userProfilePicture;
  String? userName;
  final ImagePicker _picker = ImagePicker();
  final storage = FlutterSecureStorage();
  String? user_id;

  User userService = User();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index);
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await loadUserInfo();
    setState(() {
      userName = userInfo['userName'];
      userProfilePicture = userInfo['userProfilePicture'];
      user_id = userInfo['id'];
    });
  }

  Future<void> _loadUserData() async {
    final userName = await storage.read(key: 'user_name');
    final userId = await storage.read(key: 'user_id');

    setState(() {
      this.userName = userName;
      this.userProfilePicture = userProfilePicture;
      this.user_id = userId;
    });
  }

  Future<void> _handleLogout() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _authService.logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout Successful')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      // Show error message if logout fails
      print('Logout error: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Logout Failed'),
            content: const Text('An error occurred during logout.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePicture = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider =
        getImageProvider(_profilePicture, userProfilePicture);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          imageProvider: imageProvider,
          welcomeMessage: 'Hello Again!',
          userName: 'Matt',
          userStatus: 'Active',
          rightIcon: Icons.notifications,
          showWelcomeMessage: true,
          topPadding: 50.0,
        ),
      ),
      drawer: Drawer(
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
                // Navigate to profile settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                );
              },
            ),
            const Spacer(),
            ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: _handleLogout),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Customizations Page',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: FutureBuilder<List>(
              future: userService.getAllUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, i) {
                      var user = snapshot.data![i];
                      var healthRecords = user['health_records'] as List;
                      return Card(
                        child: ExpansionTile(
                          title: Text(
                            user['name'],
                            style: TextStyle(fontSize: 24),
                          ),
                          children: healthRecords.map<Widget>((record) {
                            return ListTile(
                              title: Text(
                                'Blood Glucose Level: ${record['blood_glucose']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No data found'));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
