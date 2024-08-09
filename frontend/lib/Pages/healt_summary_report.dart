import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Ensure this is imported
import '../services/auth_service.dart';
import '../services/fetch_user_data_service.dart';
import '../utils/logout_utility.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/utils.dart';

class HealthSummaryReport extends StatefulWidget {
  final String startDate;
  final String endDate;

  HealthSummaryReport({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  _HealthSummaryReportState createState() => _HealthSummaryReportState();
}

class _HealthSummaryReportState extends State<HealthSummaryReport> {
  int _selectedIndex = 1;
  XFile? _profilePicture;
  final ImagePicker _picker = ImagePicker();
  String? userName;
  String? userProfilePicture;
  String? user_id;
  final storage = FlutterSecureStorage();
  final AuthService _authService = AuthService();

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

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider =
        getImageProvider(_profilePicture, userProfilePicture);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          imageProvider: imageProvider,
          pageName: 'Health Record',
          welcomeMessage: 'Hello Again!',
          userName: userName ?? 'user name',
          userStatus: 'Active',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Report Title and Date
              Text(
                'Title: Health Record',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Generation Date: 01/01/2024',
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              // User Details
              _buildUserDetails(),
              SizedBox(height: 16),
              // Date Range and Table Header
              _buildDateRangeAndTableHeader(),
              SizedBox(height: 8),
              // Health Summary Table
              _buildHealthSummaryTable(),
              SizedBox(height: 16),
              // Summary and Note
              _buildSummarySection(),
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

  Widget _buildUserDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
        _buildUserDetailRow('Name:', 'Matt'),
        _buildUserDetailRow('Age:', '27'),
        _buildUserDetailRow('Gender:', 'Male'),
        _buildUserDetailRow('Email:', 'mattalbukaai@gmail.com'),
      ],
    );
  }

  Widget _buildUserDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeAndTableHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From: ${widget.startDate}         To: ${widget.endDate}',
          style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            _buildTableHeaderCell('Date'),
            _buildTableHeaderCell('Glucose Read'),
            _buildTableHeaderCell('Blood Pressure'),
            _buildTableHeaderCell('Weight'),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String label) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildHealthSummaryTable() {
    return Column(
      children: [
        _buildTableRow(
            '01/01/2024', '125 mg/dl', '124/77 mm', '65 Kg', Colors.red),
        _buildTableRow('', '', '', '', Colors.transparent),
        _buildTableRow('', '', '', '', Colors.transparent),
        _buildTableRow('', '', '', '', Colors.transparent),
        _buildTableRow('', '', '', '', Colors.transparent),
        _buildTableRow('', '', '', '', Colors.transparent),
      ],
    );
  }

  Widget _buildTableRow(String date, String glucose, String pressure,
      String weight, Color statusColor) {
    return Row(
      children: [
        _buildTableCell(date),
        _buildTableCell(glucose, color: statusColor),
        _buildTableCell(pressure, color: statusColor),
        _buildTableCell(weight, color: statusColor),
      ],
    );
  }

  Widget _buildTableCell(String content, {Color color = Colors.transparent}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: color.withOpacity(0.2),
        ),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: color == Colors.transparent ? Colors.black : color,
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSummaryIndicator('Glucose', Colors.red, 'High'),
            _buildSummaryIndicator('Pressure', Colors.orange, 'Average'),
            _buildSummaryIndicator('Weight', Colors.green, 'Low'),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Note: Workout More',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            // Print action
          },
          child: Text('Print'),
        ),
      ],
    );
  }

  Widget _buildSummaryIndicator(String label, Color color, String status) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 12.0,
          percent: 0.7,
          center: new Text(
            label,
            style: TextStyle(color: color),
          ),
          progressColor: color,
        ),
        SizedBox(height: 4),
        Text(
          status,
          style: TextStyle(
            fontSize: 16.0,
            color: color,
          ),
        ),
      ],
    );
  }
}
