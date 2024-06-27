import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black, width: 1),
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 3),
              FlSpot(1, 1),
              FlSpot(2, 4),
              FlSpot(3, 2),
              FlSpot(4, 5),
              FlSpot(5, 3),
            ],
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

class BarChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [BarChartRodData(toY: 8, color: Colors.purple)],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [BarChartRodData(toY: 10, color: Colors.purple)],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [BarChartRodData(toY: 14, color: Colors.purple)],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [BarChartRodData(toY: 15, color: Colors.purple)],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [BarChartRodData(toY: 13, color: Colors.purple)],
          ),
        ],
      ),
    );
  }
}

class PieChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.blue,
            value: 49,
            title: '49%',
            radius: 50,
            titleStyle: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
