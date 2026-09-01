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
  String? userName;
  String? userProfilePicture;
  String? user_id;
  final storage = FlutterSecureStorage();
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  Map<String, dynamic> _healthSummary = {};
  List<Map<String, dynamic>> _allRecords = [];
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
    fetchHealthSummaryReport(); // Fetch report data after user info is loaded
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
      fetchHealthSummaryReport();
    }
  }

  Future<void> fetchHealthSummaryReport() async {
    if (user_id != null) {
      print('fetchHealthSummaryReport called with user_id: $user_id');
      try {
        final reportData = await ReportService.fetchHealthSummaryReport(
            user_id!, widget.startDate, widget.endDate);
        setState(() {
          _healthSummary = reportData['summary'];
          _allRecords =
              List<Map<String, dynamic>>.from(reportData['all_records']);
          _isLoading = false;
        });
      } catch (e) {
        print('Error fetching health summary report: $e');
        setState(() {
          _errorMessage = 'Failed to fetch health summary report';
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

  Future<Uint8List?> _captureChartAsImage() async {
    try {
      await Future.delayed(
          Duration(milliseconds: 300)); // Ensure rendering is complete
      final RenderRepaintBoundary boundary =
          chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      if (boundary == null) {
        print('RenderRepaintBoundary is null');
        return null;
      }

      // Increase the pixel ratio for better quality
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing chart as image: $e');
      return null;
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
    final chartImage = await _captureChartAsImage();

    const double recordsPerPage = 20; // Define how many records fit per page
    int totalRecords = _allRecords.length;
    int pagesNeeded = (totalRecords / recordsPerPage).ceil();

    for (int page = 0; page < pagesNeeded; page++) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (page == 0) // Only include the header on the first page
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Health Record Summary Report',
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
                if (page == 0) pw.SizedBox(height: 10),
                if (page == 0) pw.Text('Generation Date: $formattedDate'),
                if (page == 0) pw.SizedBox(height: 10),
                if (page == 0) pw.Text('Name: ${userName ?? "Unknown"}'),
                if (page == 0) pw.SizedBox(height: 10),
                if (page == 0) pw.Text('Health Record Summary'),
                if (page == 0) pw.Divider(),
                if (page == 0)
                  pw.Text(
                    'Overall Risk Classification: ${_healthSummary['risk_classification'] ?? 'Unknown'}',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                if (page == 0) pw.SizedBox(height: 15),
                if (page == 0)
                  pw.Text('Health Records Summary',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      )),
                if (page == 0)
                  pw.Text(
                    'Average Blood Glucose: ${_healthSummary['average_blood_glucose']}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                if (page == 0)
                  pw.Text(
                    'Average Blood Pressure: ${_healthSummary['average_blood_pressure']}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                if (page == 0)
                  pw.Text(
                    'Average Weight: ${_healthSummary['average_weight']}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                if (page == 0)
                  pw.Text(
                    'Average Daily Weight Increment: ${_healthSummary['average_daily_weight_increment']}',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                pw.SizedBox(height: 20),
                _buildRecordsTable(page, recordsPerPage),
              ],
            );
          },
        ),
      );
    }

// Add the chart on a new page after all records
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment:
                pw.CrossAxisAlignment.start, // Center the column content
            children: [
              pw.Text(
                'Health Summary Chart', // Title for the chart
                style: pw.TextStyle(
                  fontSize: 18, // Adjust the font size as needed
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20), // Add some space between title and chart
              pw.Center(
                child: chartImage != null
                    ? pw.Image(
                        pw.MemoryImage(chartImage),
                        fit: pw.BoxFit.contain,
                        width: 400, // Adjust the size as needed to fit the page
                      )
                    : pw.Text("Chart not available"),
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

  pw.Widget _buildRecordsTable(int page, double recordsPerPage) {
    int startIndex = (page * recordsPerPage).toInt();
    int endIndex = ((page + 1) * recordsPerPage).toInt();
    endIndex = endIndex > _allRecords.length ? _allRecords.length : endIndex;

    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        // Table header
        pw.TableRow(
          children: [
            pw.Text(
              'Date',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.center,
            ),
            pw.Text(
              'Blood Pressure',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.center,
            ),
            pw.Text(
              'Blood Glucose',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.center,
            ),
            pw.Text(
              'Weight',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
        // Table rows
        ..._allRecords.sublist(startIndex, endIndex).map((record) {
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.all(4),
                child: pw.Text(record['date'] ?? 'N/A',
                    textAlign: pw.TextAlign.center),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(4),
                child: pw.Text(
                  record['blood_pressure'].toString(),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(4),
                child: pw.Text(
                  record['blood_glucose'].toString(),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Padding(
                padding: pw.EdgeInsets.all(4),
                child: pw.Text(
                  record['weight'].toString(),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
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
          pageName: 'Health Summary Report',
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
                                'Health Summary Report -  ',
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
                        // All Records Table
                        _buildHealthRecordsTable(),
                        SizedBox(height: 30),
                        // Summary and Note
                        _buildSummarySection(),
                        SizedBox(height: 20),
                        Center(
                          child: _buildHealthSummaryChart(),
                        ),
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
            _buildTableHeaderCell('Blood Pressure'),
            _buildTableHeaderCell('Blood Glucose'),
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
          fontSize: 14.0,
          color: pinkColor,
        ),
      ),
    );
  }

  Widget _buildHealthRecordsTable() {
    List<Map<String, dynamic>> recordsToShow =
        _showMore ? _allRecords : _allRecords.take(5).toList();
    return Column(
      children: [
        Column(
          children: recordsToShow.map((record) {
            return _buildTableRow(
              record['date'] ?? 'N/A',
              record['blood_pressure']?.toString() ?? 'N/A',
              record['blood_glucose']?.toString() ?? 'N/A',
              record['weight']?.toString() ?? 'N/A',
              blueColor,
            );
          }).toList(),
        ),
        if (_allRecords.length > 5)
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

  Widget _buildTableRow(String date, String bloodPressure, String bloodGlucose,
      String weight, Color statusColor) {
    return Row(
      children: [
        _buildTableCell(date),
        _buildTableCell(bloodPressure, color: statusColor),
        _buildTableCell(bloodGlucose, color: statusColor),
        _buildTableCell(weight, color: statusColor),
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
                ? Color.fromARGB(255, 160, 22, 22)
                : color,
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    if (_healthSummary == null || _healthSummary.isEmpty) {
      return Center(
        child: Text(
          'No activity records found for the selected date range.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: pinkColor,
          ),
        ),
      );
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
        SizedBox(height: 15),
        Text(
          'Average Blood Glucose: ${(_healthSummary['average_blood_glucose'] ?? 0.0).toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16.0,
            color: blueColor,
          ),
        ),
        Text(
          'Average Blood Pressure: ${(_healthSummary['average_blood_pressure'] ?? 0.0).toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
          ),
        ),
        Text(
          'Average Weight: ${(_healthSummary['average_weight'] ?? 0.0).toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16.0,
            color: pinkColor,
          ),
        ),
        Text(
          'Average Daily Weight Increment(KG): ${(_healthSummary['average_daily_weight_increment'] ?? 0.0).toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthSummaryChart() {
    if (_allRecords.isEmpty) {
      return Center(
        child: Text(
          'No health records found for the selected date range.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: pinkColor,
          ),
        ),
      );
    }

    final double chartHeight = MediaQuery.of(context).size.height * 0.25;
    final double chartWidth = MediaQuery.of(context).size.width * 0.8;

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: Text(
                  'Measure',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: chartHeight, // Adjusted size
                    width: chartWidth, // Adjusted size
                    child: RepaintBoundary(
                      key: chartKey,
                      child: LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots
                                    .map((LineBarSpot touchedSpot) {
                                  final textStyle = const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8,
                                  );
                                  return LineTooltipItem(
                                    '${touchedSpot.y.toString()}',
                                    textStyle,
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          lineBarsData: [
                            // Line for Weight
                            LineChartBarData(
                              color: pinkColor, // Color for Weight line
                              spots: _allRecords.asMap().entries.map((entry) {
                                final weight =
                                    entry.value['weight']?.toDouble() ?? 0.0;
                                return FlSpot(entry.key.toDouble(), weight);
                              }).toList(),
                              barWidth: 2,
                              isCurved: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  return FlDotCirclePainter(
                                    radius: 3,
                                    color: pinkColor,
                                    strokeWidth: 1,
                                    strokeColor: Colors.black,
                                  );
                                },
                              ),
                            ),
                            // Line for Blood Glucose
                            LineChartBarData(
                              color: blueColor, // Color for Blood Glucose line
                              spots: _allRecords.asMap().entries.map((entry) {
                                final bloodGlucose =
                                    entry.value['blood_glucose']?.toDouble() ??
                                        0.0;
                                return FlSpot(
                                    entry.key.toDouble(), bloodGlucose);
                              }).toList(),
                              barWidth: 2,
                              isCurved: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  return FlDotCirclePainter(
                                    radius: 3,
                                    color: blueColor,
                                    strokeWidth: 1,
                                    strokeColor: Colors.black,
                                  );
                                },
                              ),
                            ),
                            // Line for Blood Pressure
                            LineChartBarData(
                              color:
                                  Colors.red, // Color for Blood Pressure line
                              spots: _allRecords.asMap().entries.map((entry) {
                                final bloodPressure =
                                    entry.value['blood_pressure']?.toDouble() ??
                                        0.0;
                                return FlSpot(
                                    entry.key.toDouble(), bloodPressure);
                              }).toList(),
                              barWidth: 2,
                              isCurved: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  return FlDotCirclePainter(
                                    radius: 3,
                                    color: Colors.red,
                                    strokeWidth: 1,
                                    strokeColor: Colors.black,
                                  );
                                },
                              ),
                            ),
                            // Line for Average Daily Weight Increment
                            LineChartBarData(
                              color: Colors
                                  .green, // Color for Average Daily Weight Increment line
                              spots: _allRecords.asMap().entries.map((entry) {
                                final dailyWeightIncrement = entry
                                        .value['average_daily_weight_increment']
                                        ?.toDouble() ??
                                    0.0;
                                return FlSpot(
                                    entry.key.toDouble(), dailyWeightIncrement);
                              }).toList(),
                              barWidth: 2,
                              isCurved: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  return FlDotCirclePainter(
                                    radius: 3,
                                    color: Colors.green,
                                    strokeWidth: 1,
                                    strokeColor: Colors.black,
                                  );
                                },
                              ),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 40, // Increment by 40
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 2.0),
                                    child: Text(
                                      '${value.toInt()}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 8,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) {
                                  final int index = value.toInt();
                                  if (index < _allRecords.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        _allRecords[index]['date'] ?? '',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey,
                                strokeWidth: 0.5,
                              );
                            },
                            drawVerticalLine: true,
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.grey,
                                strokeWidth: 0.5,
                              );
                            },
                          ),
                          minY: 0,
                          maxY: 240,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Record Date',
            style: TextStyle(
              fontSize: 10,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
