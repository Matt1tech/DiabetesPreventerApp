import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../services/auth_service.dart';
import '../services/fetch_user_data_service.dart';
import '../utils/logout_utility.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ActivityRecordReport extends StatefulWidget {
  final String startDate;
  final String endDate;

  ActivityRecordReport({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  _ActivityRecordReportState createState() => _ActivityRecordReportState();
}

class _ActivityRecordReportState extends State<ActivityRecordReport> {
  int _selectedIndex = 1;
  XFile? _profilePicture;
  final ImagePicker _picker = ImagePicker();
  String? userName;
  String? userProfilePicture;
  String? user_id;
  final storage = FlutterSecureStorage();
  final AuthService _authService = AuthService();
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

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

  void _printReport() async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();

      doc.addPage(
        pw.Page(
          build: (context) {
            return pw.Center(
              child: pw.Text(
                'Your Report',
                style: pw.TextStyle(fontSize: 40),
              ),
            ); // Center
          },
        ),
      );

      return doc.save();
    });
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
          pageName: 'Activity Record',
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
                'Title: Activity Record',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: pinkColor,
                ),
              ),
              SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'Generation Date:',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: pinkColor,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  '$formattedDate',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )
              ]),

              SizedBox(height: 5),
              // User Details
              _buildUserDetails(),
              SizedBox(height: 16),
              // Date Range and Table Header
              _buildDateRangeAndTableHeader(),
              SizedBox(height: 8),
              // Activity Summary Table
              _buildActivitySummaryTable(),
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
        SizedBox(height: 8),
        Row(children: [
          _buildUserDetailRow('Name:', userName ?? 'user name'),
        ])
      ],
    );
  }

  Widget _buildUserDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: blueColor,
          ),
        ),
        SizedBox(width: 245),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeAndTableHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('From: ${widget.startDate}',
              style: TextStyle(
                  fontSize: 16.0,
                  color: const Color.fromARGB(255, 221, 71, 11))),
          Text(
            'To: ${widget.endDate}',
            style: TextStyle(
                fontSize: 16.0, color: const Color.fromARGB(255, 221, 71, 11)),
          ),
        ]),
        SizedBox(height: 50),
        Row(
          children: [
            _buildTableHeaderCell('Date'),
            _buildTableHeaderCell('Activity Type'),
            _buildTableHeaderCell('Time Spent'),
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
          color: pinkColor,
        ),
      ),
    );
  }

  Widget _buildActivitySummaryTable() {
    return Column(
      children: [
        _buildTableRow('01/01/2024', 'Dance', '1.00 hr', blueColor),
        _buildTableRow('', '', '', Colors.transparent),
        _buildTableRow('', '', '', Colors.transparent),
        _buildTableRow('', '', '', Colors.transparent),
        _buildTableRow('', '', '', Colors.transparent),
        _buildTableRow('', '', '', Colors.transparent),
      ],
    );
  }

  Widget _buildTableRow(
      String date, String activity, String timeSpent, Color statusColor) {
    return Row(
      children: [
        _buildTableCell(date),
        _buildTableCell(activity, color: statusColor),
        _buildTableCell(timeSpent),
      ],
    );
  }

  Widget _buildTableCell(String content,
      {Color color = const Color.fromARGB(0, 255, 255, 255)}) {
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
                  color: pinkColor,
                ),
              ),
            ),
            SizedBox(width: 16),
            Column(
              children: [
                Text(
                  'Most Activity',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: blueColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Dance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: blueColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 10.0,
              percent: 0.49,
              center: new Text("Active",
                  style: TextStyle(color: pinkColor, fontSize: 14)),
              progressColor: Colors.orange,
              backgroundColor: Colors.grey[300]!,
            ),
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
          onPressed: _printReport,
          child: Text('Print'),
        ),
      ],
    );
  }
}
