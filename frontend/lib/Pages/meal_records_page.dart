import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/image_handler.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/utils.dart';
import 'package:frontend/services/analyze_image.dart';

class MealRecordsPage extends StatefulWidget {
  MealRecordsPage({Key? key}) : super(key: key);

  @override
  _MealRecordsPageState createState() => _MealRecordsPageState();
}

class _MealRecordsPageState extends State<MealRecordsPage> {
  int _selectedIndex = 1;
  XFile? _mealImageFile;
  final ImagePicker _picker = ImagePicker();
  String? userName;
  String? userProfilePicture;
  Map<String, dynamic> _mealData = {};

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
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
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _mealImageFile = image;
      });
      await _analyzeImage(File(image.path));
    }
  }

  Future<void> _analyzeImage(File imageFile) async {
    final apiKey = 'uPsCgdLq.jIrKCQePQaXday8iQYsqEgzpcHT1r7Tr';
    final data = await analyzeImage(imageFile, apiKey);

    setState(() {
      _mealData = {
        'meal_name': data['display_name'] ?? 'Unknown',
        'proteins': data['proteins_100g']?.toString() ?? 'N/A',
        'fat': data['fat_100g']?.toString() ?? 'N/A',
        'carbs': data['carbs_100g']?.toString() ?? 'N/A',
        'fiber': data['fibers_100g']?.toString() ?? 'N/A',
        'cholesterol': data['cholesterol_100g']?.toString() ?? 'N/A',
        'calories': data['calories_100g']?.toString() ?? 'N/A',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> headerImageProvider = userProfilePicture != null
        ? NetworkImage(userProfilePicture!)
        : AssetImage('assets/default_profile_picture.png')
            as ImageProvider<Object>;

    ImageProvider<Object>? mealImageProvider =
        _mealImageFile != null ? FileImage(File(_mealImageFile!.path)) : null;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          imageProvider: headerImageProvider,
          pageName: 'Meal Records Logs',
          welcomeMessage: 'Hello Again!',
          userName: userName ?? 'user name',
          userStatus: 'Active',
          rightIcon: Icons.notifications,
          showWelcomeMessage: true,
          topPadding: 50.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (mealImageProvider != null)
                Image(
                  image: mealImageProvider,
                  width: 150,
                  height: 150,
                ),
              _buildTextField('Meal Name', _mealData['meal_name']),
              _buildTextField('Serve Qty', '300 g'),
              _buildTextField('Proteins', _mealData['proteins']),
              _buildTextField('Fat', _mealData['fat']),
              _buildTextField('Carbs', _mealData['carbs']),
              _buildTextField('Fiber', _mealData['fiber']),
              _buildTextField('Cholesterol', _mealData['cholesterol']),
              _buildTextField('Total Calories', _mealData['calories']),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _resetFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pinkColor, // Background color
                    ),
                    child: Text('Reset',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 20), // Add space between buttons
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pinkColor, // Background color
                    ),
                    child: Text('Capture Meal',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildTextField(String label, String? initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          fillColor: Colors.white, // Set background color to white
          filled: true, // Enable filling
        ),
        controller: TextEditingController(text: initialValue),
      ),
    );
  }

  void _resetFields() {
    setState(() {
      _mealImageFile = null;
      _mealData = {
        'meal_name': '',
        'proteins': '',
        'fat': '',
        'carbs': '',
        'fiber': '',
        'cholesterol': '',
        'calories': '',
      };
    });
  }
}
