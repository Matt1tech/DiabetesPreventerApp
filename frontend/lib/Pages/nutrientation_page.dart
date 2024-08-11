import 'package:flutter/material.dart';
import 'package:frontend/Pages/home_page.dart';
import 'package:frontend/utils/utilities.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/meal.dart';
import '../services/analyze_image.dart';
import '../services/fetch_user_data_service.dart';
import '../services/meal_records_service.dart';
import '../widgets/widgets.dart';
import '../utils/utils.dart';

class NutrientationPage extends StatefulWidget {
  final File imageFile;
  final String apiKey;

  NutrientationPage({required this.imageFile, required this.apiKey});

  @override
  _NutrientationPageState createState() => _NutrientationPageState();
}

class _NutrientationPageState extends State<NutrientationPage> {
  Map<String, dynamic>? analysisData;
  bool isLoading = false;
  XFile? _profilePicture;
  String? userName;
  String? userProfilePicture;
  String? user_id;

  @override
  void initState() {
    super.initState();
    _analyzeImage();
    _loadUserInfo();
    _loadUserData();
  }

  Future<void> _analyzeImage() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await analyzeImage(widget.imageFile, widget.apiKey);
      print('Full Response data: $data');

      if (data['items'] != null && data['items'].isNotEmpty) {
        final foodItem = data['items'][0]['food'][0];
        final foodInfo = foodItem['food_info'] ?? {};
        final nutrition = foodInfo['nutrition'] ?? {};

        print('Food Item: $foodItem');
        print('Food Info: $foodInfo');
        print('Nutrition: $nutrition');

        setState(() {
          analysisData = {
            'quantity': foodInfo['quantity'] ?? 'Unknown',
            'display_name': foodInfo['display_name'] ?? 'Unknown',
            'proteins': nutrition['proteins_100g']?.toString() ?? 'N/A',
            'fat': nutrition['fat_100g']?.toString() ?? 'N/A',
            'cholesterol': nutrition['cholesterol_100g']?.toString() ?? 'N/A',
            'calories': nutrition['calories_100g']?.toString() ?? 'N/A',
            'fibers': nutrition['fibers_100g']?.toString() ?? 'N/A',
            'carbs': nutrition['carbs_100g']?.toString() ?? 'N/A',
          };
        });
      } else {
        throw Exception('Invalid data structure: "items" not found or empty');
      }
    } catch (e) {
      print('Error analyzing image: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveMealData() async {
    if (user_id == null || user_id!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in again to save meal data.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Meal meal = Meal(
        name: analysisData!['display_name'],
        quantity: double.tryParse(analysisData!['quantity']) ?? 0.0,
        calories: double.tryParse(analysisData!['calories']) ?? 0.0,
        protein: double.tryParse(analysisData!['proteins']) ?? 0.0,
        fats: double.tryParse(analysisData!['fat']) ?? 0.0,
        carbs: double.tryParse(analysisData!['carbs']) ?? 0.0,
        fiber: double.tryParse(analysisData!['fibers']) ?? 0.0,
        cholesterol: double.tryParse(analysisData!['cholesterol']) ?? 0.0,
        user: int.parse(user_id!),
      );

      await MealRecordsService.submitMealData(meal);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal data saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to save meal data. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _resetFields() {
    setState(() {
      analysisData = {
        'display_name': '',
        'proteins': '',
        'fat': '',
        'carbs': '',
        'fiber': '',
        'cholesterol': '',
        'calories': '',
      };
      _profilePicture = null;
    });
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

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider =
        getImageProvider(_profilePicture, userProfilePicture);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: UserHeader(
        imageProvider: imageProvider,
        pageName: 'Meal Recognition',
        welcomeMessage: 'Hello Again!',
        userName: userName ?? 'user name',
        userStatus: 'Active',
        rightIcon: Icons.notifications,
        showWelcomeMessage: true,
        topPadding: 50.0,
      ),
      body: Center(
        child: isLoading
            ? Text(
                'Analyzing...',
                style: TextStyle(
                    color: pinkColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: widget.imageFile != null
                        ? SizedBox(
                            width: 300,
                            height: 200,
                            child: Image.file(widget.imageFile),
                          )
                        : Text('No image selected'),
                  ),
                  if (analysisData != null)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Analysis Results:',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: pinkColor),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Name: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: blueColor)),
                              Text('${analysisData!['display_name']}',
                                  style: const TextStyle(color: pinkColor)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Quantity: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: blueColor)),
                              Text('${analysisData!['quantity']}',
                                  style: const TextStyle(color: pinkColor)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Proteins: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: blueColor)),
                              Text('${analysisData!['proteins']} g',
                                  style: const TextStyle(color: pinkColor)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Fat: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: blueColor)),
                              Text('${analysisData!['fat']} g',
                                  style: const TextStyle(color: pinkColor)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Carbs: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: blueColor)),
                              Text('${analysisData!['carbs']} g',
                                  style: const TextStyle(color: pinkColor)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Cholesterol: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: blueColor)),
                              Text('${analysisData!['cholesterol']} mg',
                                  style: const TextStyle(color: pinkColor)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Calories: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: blueColor)),
                              Text('${analysisData!['calories']} kcal',
                                  style: const TextStyle(color: pinkColor)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Fibers: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: blueColor)),
                              Text('${analysisData!['fibers']} g',
                                  style: const TextStyle(color: pinkColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _saveMealData();
                        },
                        child: Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _resetFields();
                          Navigator.pop(context);
                        },
                        child: Text('Retake'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
