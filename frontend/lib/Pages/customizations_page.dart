import 'package:flutter/material.dart';
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
  int _selectedIndex = 2;

  User userService = User();
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          imagePath: 'assets/images/diabetesLogo.png',
          pageName: 'Customizations',
          welcomeMessage: 'Hello Again!',
          userName: 'Matt',
          userStatus: 'Active',
          rightIcon: Icons.notifications,
          showWelcomeMessage: true,
          topPadding: 50.0,
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
