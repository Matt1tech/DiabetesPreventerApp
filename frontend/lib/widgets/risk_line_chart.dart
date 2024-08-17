import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RiskLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> allProbabilities;
  final double chartHeight;
  final double chartWidth;
  final Color blueColor;
  final Color pinkColor;

  const RiskLineChart({
    Key? key,
    required this.allProbabilities,
    required this.chartHeight,
    required this.chartWidth,
    required this.blueColor,
    required this.pinkColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey lineChartKey = GlobalKey();

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: Text(
                  'Risk Percentage',
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
                    height: chartHeight,
                    width: chartWidth,
                    child: RepaintBoundary(
                      key: lineChartKey,
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
                                    '${touchedSpot.y.toString()}%',
                                    textStyle,
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              color: blueColor,
                              spots:
                                  allProbabilities.asMap().entries.map((entry) {
                                return FlSpot(
                                  entry.key.toDouble(),
                                  (entry.value['probabilities']['Diabetes'] *
                                          100)
                                      .toDouble(),
                                );
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
                          ],
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 10,
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 2.0),
                                    child: Text(
                                      '${value.toInt()}%',
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
                                  if (index < allProbabilities.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        allProbabilities[index]['date'] ?? '',
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
                          maxY: 100,
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
