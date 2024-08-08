import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/utils/utilities.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/fetch_user_data_service.dart';
import '../services/recommendation_service.dart';
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
    _mealsFuture =
        _fetchRecommendations(); // Fetch recommendations from the service
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToInitialSection());
  }

  Future<List<Map<String, dynamic>>> _fetchRecommendations() async {
    RecommendationService recommendationService = RecommendationService();
    return await recommendationService.fetchRecommendations();
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
          userName: userName,
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
              return Center(child: Text('Failed to load recommendations'));
            } else {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _scrollToInitialSection());
              List<Map<String, dynamic>>? meals = snapshot.data;
              return Column(
                children: [
                  _buildSection(_section1Key, meals, 'Main'),
                  _buildSection(_section2Key, meals, 'Dessert'),
                  _buildSection(_section3Key, meals, 'Salad'),
                  _buildSection(_section4Key, meals, 'Snack'),
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
      GlobalKey key, List<Map<String, dynamic>>? meals, String category) {
    final categoryMeals =
        meals?.where((meal) => meal['category'] == category).toList();
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
              '$category Section',
              style: TextStyle(
                  color: blueColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          categoryMeals != null && categoryMeals.isNotEmpty
              ? Column(
                  children: categoryMeals
                      .map((meal) => _buildMealCard(meal))
                      .toList(),
                )
              : Center(
                  child: Text('No suitable menue..',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: pinkColor))),
        ],
      ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Container(
      padding: const EdgeInsets.all(15.0),
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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: ExpansionTile(
        leading: GestureDetector(
          onTap: () {
            _showExpandedImage(context, meal['imageUrl']);
          },
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  meal['imageUrl'],
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          overflow: TextOverflow.ellipsis,
          meal['name'],
          style: TextStyle(
              fontSize: 16, color: blueColor, fontWeight: FontWeight.bold),
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
                SizedBox(height: 15),
                Text(
                  meal['recipe'].replaceAll('\\n', '\n'),
                  style: TextStyle(color: pinkColor),
                ),
                SizedBox(height: 15),
                _buildNutrientInfo(Icons.local_fire_department, 'Calories',
                    meal['total_calories'].toString(), Colors.red),
                SizedBox(height: 5),
                _buildNutrientInfo(Icons.fitness_center, 'Protein',
                    meal['protein'].toString(), Colors.orange),
                _buildNutrientInfo(
                    Icons.opacity, 'Fat', meal['fat'].toString(), pinkColor),
                _buildNutrientInfo(Icons.opacity, 'Carbs',
                    meal['carbs'].toString(), blueColor),
                _buildNutrientInfo(Icons.grass, 'Fiber',
                    meal['fiber'].toString(), Colors.green),
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

  void _showExpandedImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
