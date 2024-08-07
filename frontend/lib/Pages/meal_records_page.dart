import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/fetch_user_data_service.dart';
import '../services/meal_records_service.dart';
import '../utils/logout_utility.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/utils.dart';
import 'package:frontend/services/analyze_image.dart';
import '../models/meal.dart';

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
  String? user_id;
  Map<String, dynamic> _mealData = {};
  XFile? _profilePicture;
  final storage = FlutterSecureStorage();
  final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _proteinsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fiberController = TextEditingController();
  final TextEditingController _cholesterolController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  bool _isLoading = false;

  @override
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
    if (mounted) {
      setState(() {
        userName = userInfo['userName'];
        userProfilePicture = userInfo['userProfilePicture'];
        user_id = userInfo['id'];
      });
    }
  }

  Future<void> _loadUserData() async {
    final userName = await storage.read(key: 'user_name');
    final userId = await storage.read(key: 'user_id');
    if (mounted) {
      setState(() {
        this.userName = userName;
        userProfilePicture = userProfilePicture;
        user_id = userId;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _mealImageFile = image;
        });
      }
      await _analyzeImage(File(image.path));
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

  Future<void> _analyzeImage(File imageFile) async {
    final apiKey = 'uPsCgdLq.jIrKCQePQaXday8iQYsqEgzpcHT1r7Tr';
    final data = await analyzeImage(imageFile, apiKey);

    if (data['items'] != null && data['items'].isNotEmpty) {
      final nutrition = data['items'][0]['food'][0]['food_info']['nutrition'];
      final quantity =
          data['items'][0]['food'][0]['quantity']?.toString() ?? '0.0';

      setState(() {
        _mealData = {
          'name': data['items'][0]['food'][0]['food_info']['display_name'] ??
              'Unknown',
          'quantity': double.tryParse(quantity) ?? 0.0,
          'proteins': double.tryParse(
                  nutrition['proteins_100g']?.toString() ?? '0.0') ??
              0.0,
          'fat': double.tryParse(nutrition['fat_100g']?.toString() ?? '0.0') ??
              0.0,
          'carbs':
              double.tryParse(nutrition['carbs_100g']?.toString() ?? '0.0') ??
                  0.0,
          'fiber':
              double.tryParse(nutrition['fibers_100g']?.toString() ?? '0.0') ??
                  0.0,
          'cholesterol': double.tryParse(
                  nutrition['cholesterol_100g']?.toString() ?? '0.0') ??
              0.0,
          'calories': double.tryParse(
                  nutrition['calories_100g']?.toString() ?? '0.0') ??
              0.0,
        };

        _nameController.text = _mealData['name'];
        _quantityController.text = _mealData['quantity'].toString();
        _proteinsController.text = _mealData['proteins'].toString();
        _fatController.text = _mealData['fat'].toString();
        _carbsController.text = _mealData['carbs'].toString();
        _fiberController.text = _mealData['fiber'].toString();
        _cholesterolController.text = _mealData['cholesterol'].toString();
        _caloriesController.text = _mealData['calories'].toString();

        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Error: Invalid data structure');
    }
  }

  Future<void> _saveMealData() async {
    if (user_id == null || user_id!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in again to save meal data.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Meal meal = Meal(
        name: _nameController.text,
        quantity: double.tryParse(_quantityController.text) ?? 0.0,
        calories: double.tryParse(_caloriesController.text) ?? 0.0,
        protein: double.tryParse(_proteinsController.text) ?? 0.0,
        fats: double.tryParse(_fatController.text) ?? 0.0,
        carbs: double.tryParse(_carbsController.text) ?? 0.0,
        fiber: double.tryParse(_fiberController.text) ?? 0.0,
        cholesterol: double.tryParse(_cholesterolController.text) ?? 0.0,
        user: int.parse(user_id!),
      );

      await MealRecordsService.submitMealData(meal);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meal data saved successfully!')),
      );
      _resetFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save meal data. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? mealImageProvider =
        _mealImageFile != null ? FileImage(File(_mealImageFile!.path)) : null;
    ImageProvider<Object> imageProvider =
        getImageProvider(_profilePicture, userProfilePicture);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          imageProvider: imageProvider,
          pageName: 'Meal Records',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_isLoading) CircularProgressIndicator(),
              if (mealImageProvider != null)
                Image(
                  image: mealImageProvider,
                  width: 150,
                  height: 150,
                ),
              _buildTextField('Meal Name', _nameController),
              _buildTextField('Serve Qty', _quantityController),
              _buildTextField('Proteins', _proteinsController),
              _buildTextField('Fat', _fatController),
              _buildTextField('Carbs', _carbsController),
              _buildTextField('Fiber', _fiberController),
              _buildTextField('Cholesterol', _cholesterolController),
              _buildTextField('Total Calories', _caloriesController),
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
                  SizedBox(width: 20), // Add space between buttons
                  ElevatedButton(
                    onPressed: _saveMealData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pinkColor, // Background color
                    ),
                    child: Text('Save',
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          fillColor: Colors.white,
          filled: true,
        ),
        controller: controller,
      ),
    );
  }

  void _resetFields() {
    setState(() {
      _mealImageFile = null;
      _mealData = {
        'name': '',
        'quantity': '',
        'proteins': '',
        'fat': '',
        'carbs': '',
        'fiber': '',
        'cholesterol': '',
        'calories': '',
      };
      _nameController.clear();
      _quantityController.clear();
      _proteinsController.clear();
      _fatController.clear();
      _carbsController.clear();
      _fiberController.clear();
      _cholesterolController.clear();
      _caloriesController.clear();
    });
  }
}
