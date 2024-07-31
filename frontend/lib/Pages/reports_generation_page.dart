import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import '../services/fetch_user_data_service.dart';
import '../widgets/widgets.dart';
import '../utils/navigation_util.dart';
import '../utils/utilities.dart'; // Assuming utilities.dart contains the buildDatePickerField function

class ReportsGenerationPage extends StatefulWidget {
  ReportsGenerationPage({Key? key}) : super(key: key);

  @override
  _ReportsGenerationPageState createState() => _ReportsGenerationPageState();
}

class _ReportsGenerationPageState extends State<ReportsGenerationPage> {
  int _selectedIndex = 4; // Ensure this is declared properly
  final AuthService _authService = AuthService();
  bool isLoading = false;
  XFile? _profilePicture;
  final ImagePicker _picker = ImagePicker();
  final storage = FlutterSecureStorage();
  // Variable to hold user data
  String? userName;
  String? userProfilePicture;
  final String userId = "12233"; // Example userId, replace with actual user id

  // Controllers for the date pickers
  final TextEditingController riskStartDateController = TextEditingController();
  final TextEditingController riskEndDateController = TextEditingController();
  final TextEditingController activityStartDateController =
      TextEditingController();
  final TextEditingController activityEndDateController =
      TextEditingController();
  final TextEditingController healthStartDateController =
      TextEditingController();
  final TextEditingController healthEndDateController = TextEditingController();

  bool _validateDates(String startDate, String endDate) {
    if (startDate.isEmpty || endDate.isEmpty) {
      return false; // Prevent generation if any date is not selected
    }
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);
    return end.isAfter(start);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    navigateToPage(context, index);
  }

  void _generateReport(String reportName, String startDate, String endDate) {
    if (!_validateDates(startDate, endDate)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Invalid Date Selection"),
          content: Text("The end date must be after the start date."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Send data to backend if dates are valid
    final Map<String, String> reportData = {
      'userId': userId,
      'reportName': reportName,
      'startDate': startDate,
      'endDate': endDate,
    };
    // TODO: Implement backend call here
    print('Report data: $reportData');
  }

  void _resetFields(TextEditingController startController,
      TextEditingController endController) {
    setState(() {
      startController.clear();
      endController.clear();
    });
  }

  void initState() {
    super.initState();
    _loadUserInfo();
  }

//handle the image of the profile picture
  Future<void> _loadUserInfo() async {
    final userInfo = await loadUserInfo();
    setState(() {
      userName = userInfo['userName'];
      userProfilePicture = userInfo['userProfilePicture'];
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
  Widget build(BuildContext context) {
    /* ImageProvider<Object> imageProvider =
        getImageProvider(_profilePicture, userProfilePicture);*/
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          /*   imageProvider: imageProvider,*/
          pageName: 'Reports Generation',
          welcomeMessage: 'Hello Again!',
          userName: userName,
          userStatus: 'Active',
          rightIcon: Icons.notifications,
          showWelcomeMessage: true,
          topPadding: 50.0,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Report Generation",
              style: TextStyle(
                  color: pinkColor, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            _buildReportTitle('Risk Summary Report'),
            _buildReportSection(
              title: 'Risk Summary Report',
              startDateController: riskStartDateController,
              endDateController: riskEndDateController,
              reportName: 'Risk Summary Report',
            ),
            SizedBox(height: 30.0),
            _buildReportTitle('Activity Reports'),
            _buildReportSection(
              title: 'Activity Reports',
              startDateController: activityStartDateController,
              endDateController: activityEndDateController,
              reportName: 'Activity Reports',
            ),
            SizedBox(height: 30.0),
            _buildReportTitle('Health Report'),
            _buildReportSection(
              title: 'Health Report',
              startDateController: healthStartDateController,
              endDateController: healthEndDateController,
              reportName: 'Health Report',
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildReportTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 5.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: blueColor,
        ),
      ),
    );
  }

  Widget _buildReportSection({
    required String title,
    required TextEditingController startDateController,
    required TextEditingController endDateController,
    required String reportName,
  }) {
    return Container(
      height: 180,
      width: 500,
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  buildDatePickerField(
                    context,
                    'Start',
                    Icons.calendar_today,
                    width: 160,
                    controller: startDateController,
                  ),
                  SizedBox(height: 15.0),
                  buildDatePickerField(
                    context,
                    'End',
                    Icons.calendar_today,
                    width: 160,
                    controller: endDateController,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 10.0),
                  IconButton(
                    icon: Icon(Icons.restart_alt, size: 46.0),
                    onPressed: () {
                      _resetFields(startDateController, endDateController);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: 46.0,
                      color: pinkColor,
                    ),
                    onPressed: () {
                      if (startDateController.text.isNotEmpty &&
                          endDateController.text.isNotEmpty) {
                        _generateReport(
                          reportName,
                          startDateController.text,
                          endDateController.text,
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Date Required"),
                            content:
                                Text("Please select both start and end dates."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
