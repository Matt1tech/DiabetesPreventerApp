import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../utils/utilities.dart';

class OverallHealthStatusPieChart extends StatefulWidget {
  final double healthyPercentage;
  final double preDiabetesPercentage;
  final double diabetesPercentage;

  OverallHealthStatusPieChart({
    required this.healthyPercentage,
    required this.preDiabetesPercentage,
    required this.diabetesPercentage,
  });

  @override
  _OverallHealthStatusPieChartState createState() =>
      _OverallHealthStatusPieChartState();
}

class _OverallHealthStatusPieChartState
    extends State<OverallHealthStatusPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 30,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Color.fromARGB(
                      255, 207, 62, 52), // Adjust this color as needed
                  text: 'Diabetes',
                  isSquare: true,
                ),
                SizedBox(height: 4),
                Indicator(
                  color: pinkColor, // Adjust this color as needed
                  text: 'Pre-diabetes',
                  isSquare: true,
                ),
                SizedBox(height: 4),
                Indicator(
                  color: blueColor, // Adjust this color as needed
                  text: 'Healthy',
                  isSquare: true,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: blueColor,
        value: widget.healthyPercentage,
        title: '${widget.healthyPercentage}%',
        radius: touchedIndex == 0 ? 60.0 : 50.0,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 0 ? 18.0 : 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      ),
      PieChartSectionData(
        color: Color.fromARGB(255, 207, 62, 52),
        value: widget.diabetesPercentage,
        title: '${widget.diabetesPercentage}%',
        radius: touchedIndex == 1 ? 60.0 : 50.0,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 1 ? 18.0 : 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      ),
      PieChartSectionData(
        color: pinkColor,
        value: widget.preDiabetesPercentage,
        title: '${widget.preDiabetesPercentage}%',
        radius: touchedIndex == 2 ? 60.0 : 50.0,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 2 ? 18.0 : 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      ),
    ];
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 17,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
