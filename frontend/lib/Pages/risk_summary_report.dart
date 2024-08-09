import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/fetch_user_data_service.dart';
import '../utils/logout_utility.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/utils.dart';

class RiskSummaryReport extends StatefulWidget {
  RiskSummaryReport({Key? key}) : super(key: key);

  @override
  _RiskSummaryReportState createState() => _RiskSummaryReportState();
}

class _RiskSummaryReportState extends State<RiskSummaryReport> {
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
      backgroundColor: Color.fromARGB(255, 217, 217, 217),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          imageProvider: imageProvider,
          pageName: 'Risk Summary',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Report Title and Date
              Text(
                'Title: Risk Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.purple,
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
              // Risk Summary Table
              _buildRiskSummaryTable(),
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
          'From: 01/01/2024         To: 01/02/2024',
          style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            _buildTableHeaderCell('Date'),
            _buildTableHeaderCell('Risk Status'),
            _buildTableHeaderCell('Risk Percentage'),
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
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _buildRiskSummaryTable() {
    return Column(
      children: [
        _buildTableRow('01/01/2024', 'High', '69%', Colors.red),
        _buildTableRow('', '', '', Colors.transparent),
        _buildTableRow('', '', '', Colors.transparent),
        _buildTableRow('', '', '', Colors.transparent),
        _buildTableRow('', '', '', Colors.transparent),
        _buildTableRow('', '', '', Colors.transparent),
      ],
    );
  }

  Widget _buildTableRow(
      String date, String status, String percentage, Color statusColor) {
    return Row(
      children: [
        _buildTableCell(date),
        _buildTableCell(status, color: statusColor),
        _buildTableCell(percentage),
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
          children: [
            Expanded(
              child: Text(
                'Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.purple,
                ),
              ),
            ),
            SizedBox(width: 16),
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 10.0,
              percent: 0.49,
              center: new Text("49%"),
              progressColor: Colors.purple,
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Note: Avoid high-risk factors',
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
}
