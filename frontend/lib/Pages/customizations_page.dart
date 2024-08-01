import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/Pages/pages.dart';
import 'package:frontend/services/fetch_user_data_service.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../utils/logout_utility.dart';
import '../utils/utilities.dart';
import '../widgets/drawer_widget.dart';
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
  final storage = FlutterSecureStorage();
  String? user_id;

  User userService = User();

  void initState() {
    super.initState();
    _loadUserInfo();
    _loadUserData();
  }

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
          userName: userName ?? 'user name',
          userStatus: 'Active',
          rightIcon: Icons.notifications,
          showWelcomeMessage: true,
          topPadding: 50.0,
        ),
      ),
      drawer: CustomDrawer(
        userName: userName,
        imageProvider: imageProvider,
        logoutManager:
            LogoutManager(context: context, authService: _authService),
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
