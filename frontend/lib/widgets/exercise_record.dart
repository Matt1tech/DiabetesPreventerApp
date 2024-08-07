import 'package:flutter/material.dart';
import 'package:frontend/utils/utilities.dart';
import '../services/physical_activities_records_service.dart';

class ExerciseRecord extends StatefulWidget {
  final String userId;
  final PhysicalActivityRecordsService service;

  ExerciseRecord({Key? key, required this.userId, required this.service})
      : super(key: key);

  @override
  _ExerciseRecordState createState() => _ExerciseRecordState();
}

class _ExerciseRecordState extends State<ExerciseRecord> {
  String selectedExercise = '';
  double duration = 30;
  TextEditingController durationController = TextEditingController();

  final List<String> exercises = [
    "Gym",
    "Daily Work",
    "Cardio",
    "Yoga",
    "Running",
    "Dance"
  ];

  void submitExercise() {
    if (selectedExercise.isNotEmpty && duration >= 5 && duration <= 120) {
      widget.service
          .submitExerciseRecord(widget.userId, selectedExercise, duration)
          .then((success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Exercise logged successfully")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Failed to log exercise")));
        }
      });
    } else {
      print('No exercise selected or invalid duration');
    }
  }

  @override
  void initState() {
    super.initState();
    durationController.text = duration.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 360,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(25.0),
        child: ExpansionTile(
          title: Text(
            'Exercise Record',
            style: TextStyle(
              fontSize: 22,
              color: pinkColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SizedBox(height: 30),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: exercises.map((exercise) {
                bool isSelected = selectedExercise == exercise;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedExercise = exercise;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? pinkColor.withOpacity(0.3)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: isSelected ? pinkColor : Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    child: Text(
                      exercise,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? pinkColor : Colors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Duration',
                  style: TextStyle(
                    fontSize: 14,
                    color: pinkColor,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'mins',
                      isDense: true, // Reduce height
                      contentPadding: EdgeInsets.all(10), // Reduce padding
                    ),
                    onChanged: (value) {
                      setState(() {
                        duration = double.tryParse(value) ?? 0.5;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'mins',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: submitExercise,
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
