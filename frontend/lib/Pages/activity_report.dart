import 'dart:typed_data';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/utils/logout_utility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/fetch_user_data_service.dart';
import '../services/report_service.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/user_header.dart';
import '../widgets/customized_navigation_bar.dart';
import '../utils/utils.dart';

import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
  String? userName;
  String? userProfilePicture;
  String? user_id;
  final storage = FlutterSecureStorage();
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  List<Map<String, dynamic>> _activityRecords = [];
  bool _isLoading = true;
  String? _errorMessage;
  XFile? _profilePicture;
  bool _showMore = false;
  final GlobalKey chartKey = GlobalKey(); // Define the GlobalKey here

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadUserData(); // Load user information
    fetchActivityReport(); // Fetch report data after user info is loaded
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
        print("User Info Loaded: user_id = $user_id"); // Debug statement
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
        print("User Data Loaded: user_id = $user_id"); // Debug statement
      });
      fetchActivityReport();
    }
  }

  Future<void> fetchActivityReport() async {
    if (user_id != null) {
      print('fetchActivityReport called with user_id: $user_id');
      try {
        final activityRecords = await ReportService.fetchActivityReport(
            user_id!, widget.startDate, widget.endDate);
        print('Fetched activity records: $activityRecords');
        setState(() {
          _activityRecords = activityRecords;
          _isLoading = false;
          print("Updated _activityRecords: $_activityRecords");
        });
      } catch (e) {
        print('Error fetching activity report: $e');
        setState(() {
          _errorMessage = 'Failed to fetch activity report';
          _isLoading = false;
        });
      }
    } else {
      print('Error: user_id is null');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _printReport() async {
    final pdf = pw.Document();

    // Load the image from assets
    final image = pw.MemoryImage(
      (await rootBundle.load('assets/images/diabetesLogo.png'))
          .buffer
          .asUint8List(),
    );

    // Capture the chart as an image
    final chartImage =
        await _captureChartAsImage(); // Make sure this is done after rendering

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Activity Report',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.SizedBox(height: 60),
                      pw.Image(
                        image,
                        width: 70,
                        height: 70,
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Diabetes Preventer',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text('Generation Date: $formattedDate'),
              pw.SizedBox(height: 10),
              pw.Text('Name: ${userName ?? "Unknown"}'),
              pw.SizedBox(height: 10),
              pw.Text('Activity Summary'),
              pw.Divider(),
              ..._activityRecords.map((record) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(record['date'] ?? 'N/A'),
                    pw.Text(record['activity_type'] ?? '-'),
                    pw.Text(record['time_spent']?.toString() ?? '0.0 hr'),
                  ],
                );
              }).toList(),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total Workout Time: ${_calculateTotalWorkoutTime().toStringAsFixed(1)} hrs',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              // Include the chart image if it's available
              if (chartImage != null)
                pw.Image(
                  pw.MemoryImage(chartImage),
                  height: 200, // Adjust the size as needed
                ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<Uint8List?> _captureChartAsImage() async {
    try {
      await Future.delayed(Duration(milliseconds: 300)); // Small delay
      final RenderRepaintBoundary boundary =
          chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      if (boundary == null) {
        print('RenderRepaintBoundary is null');
        return null;
      }

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing chart as image: $e');
      return null;
    }
  }

  double _calculateTotalWorkoutTime() {
    return _activityRecords.fold(
      0.0,
      (sum, record) =>
          sum +
          (double.tryParse(record['time_spent'].toString().split(' ')[0]) ??
              0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider =
        getImageProvider(_profilePicture, userProfilePicture);
    double totalWorkoutTime = _activityRecords.fold(
        0.0,
        (sum, record) =>
            sum +
            (double.tryParse(record['time_spent'].toString().split(' ')[0]) ??
                0.0));

    return Scaffold(
      backgroundColor: Colors.white,
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
            LogoutManager(context: context, authService: AuthService()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Text(_errorMessage!)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Activity Report -  ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.print),
                                onPressed:
                                    _printReport, // Call the print function
                              ),
                            ]), // Report Title and Date

                        SizedBox(height: 40),
                        Row(
                          children: [
                            Text(
                              'Generation Date:',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: pinkColor,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(width: 110),
                            Text(
                              '$formattedDate',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
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
                        SizedBox(height: 20),
                        // Chart
                        _buildTotalWorkoutChart(totalWorkoutTime),
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
        Row(
          children: [
            _buildUserDetailRow('Name:', userName ?? 'user name'),
          ],
        )
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
        SizedBox(width: 200),
        Text(
          value,
          style: TextStyle(
              fontSize: 18.0,
              color: Color.fromARGB(255, 4, 99, 12),
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDateRangeAndTableHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('From: ${widget.startDate}',
                style: TextStyle(
                    fontSize: 16.0,
                    color: const Color.fromARGB(255, 221, 71, 11))),
            Text(
              'To: ${widget.endDate}',
              style: TextStyle(
                  fontSize: 16.0,
                  color: const Color.fromARGB(255, 221, 71, 11)),
            ),
          ],
        ),
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
    List<Map<String, dynamic>> recordsToShow =
        _showMore ? _activityRecords : _activityRecords.take(5).toList();
    return Column(
      children: [
        Column(
          children: recordsToShow.map((record) {
            return _buildTableRow(
              record['date'] ?? 'N/A',
              record['activity_type'] ?? '-',
              record['time_spent']?.toString() ?? '0.0 hr',
              blueColor,
            );
          }).toList(),
        ),
        if (_activityRecords.length > 5)
          TextButton(
            onPressed: () {
              setState(() {
                _showMore = !_showMore;
              });
            },
            child: Text(_showMore ? 'Show Less' : 'Show More'),
          ),
      ],
    );
  }

  Widget _buildTableRow(
      String date, String activity, String timeSpent, Color statusColor) {
    String numericPart = timeSpent.split(' ')[0]; // Extract numeric part
    return Row(
      children: [
        _buildTableCell(date),
        _buildTableCell(activity, color: statusColor),
        _buildTableCell(numericPart), // Use the numeric part
      ],
    );
  }

  Widget _buildTableCell(String content, {Color color = Colors.transparent}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 255, 255, 255)),
          color: color.withOpacity(0.2),
        ),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: color == Colors.transparent
                ? const Color.fromARGB(255, 124, 18, 18)
                : color,
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    if (_activityRecords.isEmpty) {
      return Center(
          child:
              Text('No activity records found for the selected date range.'));
    }

    final summary = _activityRecords.fold<Map<String, dynamic>>(
        {'most_activity': '', 'most_activity_time': 0, 'note': 'Workout More'},
        (acc, record) {
      // Extract only the numeric part of the time_spent and parse it safely
      String numericPart = record['time_spent'].toString().split(' ')[0];
      acc['most_activity_time'] += double.tryParse(numericPart) ?? 0.0;
      acc['most_activity'] = record['activity_type'];
      return acc;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            SizedBox(width: 30),
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
                  summary['most_activity'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: blueColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Note: ${summary['note']}',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalWorkoutChart(double totalWorkoutTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 10.0), // Adjust padding if needed
      child: Column(
        children: [
          Text(
            'Total Workout Time',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: pinkColor,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 200,
            child: RepaintBoundary(
              key: chartKey, // Assign the GlobalKey here
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: blueColor,
                          value: totalWorkoutTime,
                          title: '',
                          radius: 30,
                        ),
                        PieChartSectionData(
                          color: pinkColor,
                          value: 24 - totalWorkoutTime > 0
                              ? 24 - totalWorkoutTime
                              : 0,
                          title: '',
                          radius: 10,
                        ),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                    ),
                  ),
                  Text(
                    '${totalWorkoutTime.toStringAsFixed(1)} hrs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: pinkColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
