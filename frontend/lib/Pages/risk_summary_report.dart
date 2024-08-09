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

class RiskSummaryReportPage extends StatefulWidget {
  final String startDate;
  final String endDate;

  RiskSummaryReportPage({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  _RiskSummaryReportState createState() => _RiskSummaryReportState();
}

class _RiskSummaryReportState extends State<RiskSummaryReportPage> {
  int _selectedIndex = 1;
  String? userName;
  String? userProfilePicture;
  String? user_id;
  final storage = FlutterSecureStorage();
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  Map<String, dynamic> _riskSummary = {};
  List<Map<String, dynamic>> _allProbabilities = [];
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
    fetchRiskSummaryReport(); // Fetch report data after user info is loaded
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
      fetchRiskSummaryReport();
    }
  }

  Future<void> fetchRiskSummaryReport() async {
    if (user_id != null) {
      print('fetchRiskSummaryReport called with user_id: $user_id');
      try {
        final reportData = await ReportService.fetchRiskSummaryReport(
            user_id!, widget.startDate, widget.endDate);
        print('Fetched risk summary: $reportData');
        setState(() {
          _riskSummary = reportData['summary'];
          _allProbabilities =
              List<Map<String, dynamic>>.from(reportData['all_probabilities']);
          _isLoading = false;
        });
      } catch (e) {
        print('Error fetching risk summary report: $e');
        setState(() {
          _errorMessage = 'Failed to fetch risk summary report';
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
                    'Risk Summary Report',
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
              pw.Text('Risk Summary'),
              pw.Divider(),
              pw.Text(
                'Overall Risk Classification: ${_riskSummary['risk_classification'] ?? 'Unknown'}',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('Risk Probabilities:'),
              ..._riskSummary['risk_probabilities'].entries.map((entry) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(entry.key),
                    pw.Text(entry.value.toString()),
                  ],
                );
              }).toList(),
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

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider =
        getImageProvider(_profilePicture, userProfilePicture);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: UserHeader(
          imageProvider: imageProvider,
          pageName: 'Risk Summary Report',
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
                                'Risk Summary Report -  ',
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
                        // All Probabilities Table
                        _buildRiskProbabilitiesTable(),
                        SizedBox(height: 16),
                        // Summary and Note
                        _buildSummarySection(),
                        SizedBox(height: 20),
                        // Chart
                        _buildRiskProbabilitiesChart(),
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
            _buildTableHeaderCell('Healthy'),
            _buildTableHeaderCell('Prediabetes'),
            _buildTableHeaderCell('Diabetes'),
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
          fontSize: 14.0,
          color: pinkColor,
        ),
      ),
    );
  }

  Widget _buildRiskProbabilitiesTable() {
    List<Map<String, dynamic>> recordsToShow =
        _showMore ? _allProbabilities : _allProbabilities.take(5).toList();
    return Column(
      children: [
        Column(
          children: recordsToShow.map((record) {
            return _buildTableRow(
              record['date'] ?? 'N/A',
              record['probabilities']['Healthy'].toString(),
              record['probabilities']['Prediabetes'].toString(),
              record['probabilities']['Diabetes'].toString(),
              blueColor,
            );
          }).toList(),
        ),
        if (_allProbabilities.length > 5)
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

  Widget _buildTableRow(String date, String healthy, String prediabetes,
      String diabetes, Color statusColor) {
    return Row(
      children: [
        _buildTableCell(date),
        _buildTableCell(healthy, color: statusColor),
        _buildTableCell(prediabetes, color: statusColor),
        _buildTableCell(diabetes, color: statusColor),
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
            fontSize: 15.0,
            color: color == Colors.transparent
                ? const Color.fromARGB(255, 124, 18, 18)
                : color,
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    if (_riskSummary.isEmpty) {
      return Center(child: Text('No risk summary available.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: pinkColor,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Overall Risk Classification: ${_riskSummary['risk_classification']}',
          style: TextStyle(
            fontSize: 16.0,
            color: blueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Risk Probabilities:',
          style: TextStyle(
            fontSize: 16.0,
            color: blueColor,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              _riskSummary['risk_probabilities'].entries.map<Widget>((entry) {
            return Text(
              '${entry.key}: ${entry.value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16.0,
                color: const Color.fromARGB(255, 145, 26, 17),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRiskProbabilitiesChart() {
    // Check if _riskSummary and risk_probabilities exist and are not null
    if (_riskSummary == null || _riskSummary['risk_probabilities'] == null) {
      return Center(
        child: Text(
          'No risk probabilities available.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: pinkColor,
          ),
        ),
      );
    }

    // Safely access the risk probabilities
    final riskProbabilities = _riskSummary['risk_probabilities'];

    // Safely assign the values or default to 0.0
    final healthyValue = riskProbabilities['Healthy'] ?? 0.0;
    final prediabetesValue = riskProbabilities['Prediabetes'] ?? 0.0;
    final diabetesValue = riskProbabilities['Diabetes'] ?? 0.0;

    // Safely assign the risk classification or default to 'Unknown'
    final riskClassification = _riskSummary['risk_classification'] ?? 'Unknown';

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 10.0), // Adjust padding if needed
      child: Column(
        children: [
          Text(
            'Risk Probabilities',
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
                          color: Colors.green,
                          value: healthyValue,
                          title: '',
                          radius: 30,
                        ),
                        PieChartSectionData(
                          color: Colors.orange,
                          value: prediabetesValue,
                          title: '',
                          radius: 30,
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: diabetesValue,
                          title: '',
                          radius: 30,
                        ),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                    ),
                  ),
                  Text(
                    riskClassification,
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
