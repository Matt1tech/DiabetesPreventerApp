import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/utils/utilities.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/fetch_user_data_service.dart';
import '../utils/logout_utility.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/navigation_util.dart';

class RecommendationsPage extends StatefulWidget {
  final int initialSectionIndex;

  RecommendationsPage({Key? key, required this.initialSectionIndex})
      : super(key: key);

  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<RecommendationsPage> {
  int _selectedIndex = 5;
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String? userProfilePicture;
  XFile? _profilePicture;
  String? userName;
  final storage = FlutterSecureStorage();
  String? user_id;
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _section1Key = GlobalKey();
  final GlobalKey _section2Key = GlobalKey();
  final GlobalKey _section3Key = GlobalKey();
  final GlobalKey _section4Key = GlobalKey();
  late Future<List<Map<String, dynamic>>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadUserData();
    _mealsFuture = Future.value(getMockMeals()); // Use mock data
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToInitialSection());
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

  Future<void> _pickProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profilePicture = image;
      });
    }
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  void _scrollToInitialSection() {
    switch (widget.initialSectionIndex) {
      case 1:
        _scrollToSection(_section1Key);
        break;
      case 2:
        _scrollToSection(_section2Key);
        break;
      case 3:
        _scrollToSection(_section3Key);
        break;
      case 4:
        _scrollToSection(_section4Key);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          pageName: 'Recommendations',
          welcomeMessage: 'Hello Again!',
          userName: 'Matt',
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
        controller: _scrollController,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _mealsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load meals'));
            } else {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _scrollToInitialSection());
              List<Map<String, dynamic>>? meals = snapshot.data;
              return Column(
                children: [
                  _buildSection(_section1Key, meals, 'Main Dish Section'),
                  _buildSection(_section2Key, meals, 'Desert Section'),
                  _buildSection(_section3Key, meals, 'Salad Section'),
                  _buildSection(_section4Key, meals, 'Snack Section'),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildSection(
      GlobalKey key, List<Map<String, dynamic>>? meals, String sectionTitle) {
    return Container(
      key: key,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0), // Add padding to move text to the right
            child: Text(
              sectionTitle,
              style: TextStyle(
                  color: blueColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          meals != null
              ? Column(
                  children: meals.map((meal) => _buildMealCard(meal)).toList(),
                )
              : Center(child: Text('No meals available')),
        ],
      ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ExpansionTile(
        leading: Container(
          margin: EdgeInsets.all(5.0), // Add margin to ensure spacing
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // Reduced image border
            child: Image.network(
              meal['imageUrl'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          meal['name'],
          style: TextStyle(
              fontSize: 18, color: blueColor, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['name'],
                  style:
                      TextStyle(color: blueColor, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  meal['recipe'],
                  style: TextStyle(color: pinkColor),
                ),
                SizedBox(height: 10),
                _buildNutrientInfo(Icons.local_fire_department, 'Calories',
                    meal['calories'].toString(), Colors.red),
                _buildNutrientInfo(
                    Icons.opacity, 'Fat', meal['fat'].toString(), Colors.blue),
                _buildNutrientInfo(Icons.fitness_center, 'Protein',
                    meal['protein'].toString(), Colors.green),
                _buildNutrientInfo(Icons.grass, 'Fiber',
                    meal['fiber'].toString(), Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(
      IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 8),
          Text(
            '$label: $value',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> getMockMeals() {
  return [
    {
      'name': 'Spaghetti Carbonara',
      'imageUrl': 'https://via.placeholder.com/150',
      'recipe':
          '1. Boil pasta\n2. Cook pancetta\n3. Mix eggs and cheese\n4. Combine all',
      'calories': 1200,
      'fat': 10,
      'protein': 30,
      'fiber': 5,
    },
    {
      'name': 'Chicken Salad',
      'imageUrl': 'https://via.placeholder.com/150',
      'recipe':
          '1. Cook chicken\n2. Prepare vegetables\n3. Mix ingredients\n4. Serve with dressing',
      'calories': 1200,
      'fat': 10,
      'protein': 30,
      'fiber': 5,
    },
    {
      'name': 'Beef Tacos',
      'imageUrl': 'https://via.placeholder.com/150',
      'recipe':
          '1. Cook beef\n2. Prepare toppings\n3. Assemble tacos\n4. Serve with salsa',
      'calories': 1200,
      'fat': 10,
      'protein': 30,
      'fiber': 5,
    },
    {
      'name': 'Beef Tacos',
      'imageUrl': 'https://via.placeholder.com/150',
      'recipe':
          '1. Cook beef\n2. Prepare toppings\n3. Assemble tacos\n4. Serve with salsa',
      'calories': 1200,
      'fat': 10,
      'protein': 30,
      'fiber': 5,
    },
    {
      'name': 'Beef Tacos',
      'imageUrl': 'https://via.placeholder.com/150',
      'recipe':
          '1. Cook beef\n2. Prepare toppings\n3. Assemble tacos\n4. Serve with salsa',
      'calories': 1200,
      'fat': 10,
      'protein': 30,
      'fiber': 5,
    },
  ];
}
