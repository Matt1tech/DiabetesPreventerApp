import 'package:flutter/material.dart';
import 'package:frontend/utils/utilities.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/meal.dart';
import '../services/analyze_image.dart'; // Make sure to import your analyzeImage function
import '../services/fetch_user_data_service.dart';
import '../services/meal_records_service.dart';
import '../widgets/widgets.dart'; // Ensure this import path is correct
import '../utils/utils.dart';

//TODO need to add isloading
//TODO need to handle the button to save and cancel
//TODO need to fix the output
// If click save save should store the data in the user meal record
class NutrientationPage extends StatefulWidget {
  final File imageFile;
  final String apiKey;

  NutrientationPage({required this.imageFile, required this.apiKey});

  @override
  _NutrientationPageState createState() => _NutrientationPageState();
}

class _NutrientationPageState extends State<NutrientationPage> {
  Map<String, dynamic>? analysisData;
  bool isLoading = false; // Added loading state

  // Handle the image
  XFile? _profilePicture;
  final ImagePicker _picker = ImagePicker();
  String? userName;
  String? userProfilePicture;
  String? userId; // Added userId

  @override
  void initState() {
    super.initState();
    _analyzeImage();
    _loadUserInfo();
  }

  Future<void> _analyzeImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await analyzeImage(widget.imageFile, widget.apiKey);
      print(
          'Full Response data: $data'); // Debug print to see the full response structure

      // Ensure the data contains the expected fields
      if (data['items'] != null && data['items'].isNotEmpty) {
        final foodItem = data['items'][0]['food'][0];
        final foodInfo = foodItem['food_info'] ?? {};
        final nutrition = foodInfo['nutrition'] ?? {};

        print('Food Item: $foodItem'); // Debug print to see the food item
        print('Food Info: $foodInfo'); // Debug print to see the food info
        print('Nutrition: $nutrition'); // Debug print to see the nutrition data

        setState(() {
          analysisData = {
            'display_name': foodInfo['display_name'] ?? 'Unknown',
            'proteins': (nutrition['proteins_100g'] ?? '0').toString(),
            'fat': (nutrition['fat_100g'] ?? '0').toString(),
            'cholesterol': (nutrition['cholesterol_100g'] ?? '0').toString(),
            'calories': (nutrition['calories_100g'] ?? '0').toString(),
            'fibers': (nutrition['fibers_100g'] ?? '0').toString(),
          };
          isLoading = false;
        });
      } else {
        throw Exception('Invalid data structure: "items" not found or empty');
      }
    } catch (e) {
      // Handle error
      print('Error analyzing image: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Handle the image of the profile picture
  Future<void> _loadUserInfo() async {
    final userInfo = await loadUserInfo();
    setState(() {
      userName = userInfo['userName'];
      userProfilePicture = userInfo['userProfilePicture'];
      userId = userInfo['id']; // Added userId
    });
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
  void dispose() {
    super.dispose();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              CircularProgressIndicator(), // Added loading indicator
            Container(
              child: widget.imageFile != null
                  ? SizedBox(
                      width: 200, // Set the desired width
                      height: 200, // Set the desired height
                      child: Image.file(widget.imageFile),
                    )
                  : Text('No image selected'),
            ),
            if (analysisData != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text('Analysis Results:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: pinkColor)),
                    const SizedBox(height: 10),
                    Text('Name: ${analysisData!['display_name']}',
                        style: const TextStyle(color: blueColor)),
                    Text('Proteins: ${analysisData!['proteins_100g']} g',
                        style: const TextStyle(color: blueColor)),
                    Text('Fat: ${analysisData!['fat_100g']} g',
                        style: const TextStyle(color: blueColor)),
                    Text('Cholesterol: ${analysisData!['cholesterol_100g']} mg',
                        style: const TextStyle(color: blueColor)),
                    Text('Calories: ${analysisData!['calories_100g']} kcal',
                        style: const TextStyle(color: blueColor)),
                    Text('Fibers: ${analysisData!['fibers_100g']} g',
                        style: const TextStyle(color: blueColor)),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _saveToDatabase();
                          },
                          child: Text('Save'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Retake'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToDatabase() async {
    if (userId == null || userId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in again to save meal data.')),
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
        calories: double.tryParse(analysisData!['calories_100g']) ?? 0.0,
        protein: double.tryParse(analysisData!['proteins_100g']) ?? 0.0,
        fats: double.tryParse(analysisData!['fat_100g']) ?? 0.0,
        fiber: double.tryParse(analysisData!['fibers_100g']) ?? 0.0,
        cholesterol: double.tryParse(analysisData!['cholesterol_100g']) ?? 0.0,
        carbs: double.tryParse(analysisData!['carbs_100g']) ?? 0.0,
        user: int.parse(userId!),
      );

      await MealRecordsService.submitMealData(meal);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meal data saved successfully!')),
      );
      // Optionally reset fields or navigate away
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save meal data. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
