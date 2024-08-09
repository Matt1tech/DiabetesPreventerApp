/*

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart'; // Ensure utils.dart provides necessary utilities, if not remove or adjust imports

class MonthlyRiskChart extends StatelessWidget {
  final List<double> monthlyRiskValues;

  const MonthlyRiskChart({Key? key, required this.monthlyRiskValues})
      : super(key: key);

  List<FlSpot> getMonthlySpots() {
    return List.generate(monthlyRiskValues.length,
        (index) => FlSpot(index.toDouble(), monthlyRiskValues[index]));
  }

  SideTitles monthOfYearBottomTitles() {
    DateTime now = DateTime.now();
    List<String> lastSixMonths = List.generate(6, (index) {
      DateTime month = DateTime(now.year, now.month - 5 + index, 1);
      return DateFormat('MMM').format(month);
    });

    return SideTitles(
      showTitles: true,
      reservedSize: 50,
      getTitlesWidget: (value, meta) {
        int index = value.toInt();
        if (index < lastSixMonths.length) {
          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 18.0,
            child: Text(lastSixMonths[index],
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          );
        } else {
          return SideTitleWidget(
              axisSide: meta.axisSide, space: 16.0, child: Text(''));
        }
      },
      interval: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0, left: 25),
            child: Text(
              'Monthly Risk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: pinkColor,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final textStyle = const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          );
                          return LineTooltipItem(
                              touchedSpot.y.toString(), textStyle);
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      color: blueColor,
                      spots: getMonthlySpots(), // Corrected method call
                      barWidth: 4,
                      isCurved: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: pinkColor,
                            strokeWidth: 2,
                            strokeColor: Colors.black,
                          );
                        },
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Transform.translate(
                        offset: const Offset(26, -16),
                        child: const Text(
                          'Risk Percentage (%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: blueColor,
                          ),
                        ),
                      ),
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text('Month of the Year'),
                      sideTitles: monthOfYearBottomTitles(),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

*/

/*

*/

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/utils/utilities.dart'; // Ensure this is properly set up for colors and other utilities
import 'package:intl/intl.dart';

class MonthlyRiskChart extends StatelessWidget {
  final List<double> monthlyRiskValues;

  const MonthlyRiskChart({Key? key, required this.monthlyRiskValues})
      : super(key: key);

  List<BarChartGroupData> getBarGroups() {
    return List.generate(monthlyRiskValues.length, (index) {
      return BarChartGroupData(
        x: index, // Ensure this matches the correct index order
        barRods: [
          BarChartRodData(
            toY: monthlyRiskValues[index] * 100, // Convert to percentage
            gradient: LinearGradient(
              colors: [blueColor, Colors.lightBlueAccent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 14,
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
        ],
      );
    });
  }

  SideTitles monthOfYearBottomTitles() {
    DateTime now = DateTime.now();
    List<String> lastSixMonths = List.generate(6, (index) {
      DateTime month = DateTime(now.year, now.month - 5 + index, 1);
      return DateFormat('MMM').format(month);
    });

    return SideTitles(
      showTitles: true,
      reservedSize: 35,
      getTitlesWidget: (value, meta) {
        int index = value.toInt();
        if (index < lastSixMonths.length) {
          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 8.0, // Reduced space
            child: Text(lastSixMonths[index],
                style: const TextStyle(
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          );
        } else {
          return SideTitleWidget(
              axisSide: meta.axisSide, space: 8.0, child: const Text(''));
        }
      },
      interval: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if the list is empty or contains only zeros
    bool hasNoData = monthlyRiskValues.isEmpty ||
        monthlyRiskValues.every((value) => value == 0);

    return Container(
      width: 380,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10.0, left: 25),
                child: Text(
                  'Monthly Risk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: pinkColor,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: BarChart(
                    BarChartData(
                      barGroups: getBarGroups(),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: Transform.translate(
                            offset: const Offset(26, 1),
                            child: const Text(
                              'Risk Percentage (%)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: blueColor,
                              ),
                            ),
                          ),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 8.0,
                                child: Text(
                                  '${value.toInt()}%', // Showing percentage
                                  style: const TextStyle(
                                    color: pinkColor,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget: const Text('Month of the Year',
                              style: TextStyle(color: pinkColor)),
                          sideTitles: monthOfYearBottomTitles(),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey,
                            strokeWidth: 0.8,
                          );
                        },
                        drawVerticalLine: true,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: const Color.fromARGB(255, 187, 187, 187),
                            strokeWidth: 0.5,
                          );
                        },
                      ),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY.toStringAsFixed(1)}%', // Format the text as a percentage
                              TextStyle(
                                color: Colors.white, // Set text color
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasNoData)
            Center(
              child: Text(
                'No available data..',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: pinkColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
