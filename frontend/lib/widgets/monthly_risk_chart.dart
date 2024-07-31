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
      reservedSize: 40,
      getTitlesWidget: (value, meta) {
        int index = value.toInt();
        if (index < lastSixMonths.length) {
          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 16.0,
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
      width: 380,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
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
              padding: const EdgeInsets.all(23.0),
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
                      barWidth: 3,
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
                          'Risk Percentage (RP)',
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
