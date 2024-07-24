import 'package:flutter/material.dart';
import 'package:frontend/utils/utils.dart';

class HealthMeasurementLogsCard extends StatefulWidget {
  final String title;
  final String name;
  final void Function(int) onPressed;

  HealthMeasurementLogsCard({
    required this.title,
    required this.name,
    required this.onPressed,
  });

  @override
  _HealthMeasurementLogsCardState createState() =>
      _HealthMeasurementLogsCardState();
}

class _HealthMeasurementLogsCardState extends State<HealthMeasurementLogsCard> {
  int _value = 75;

  void _incrementValue() {
    setState(() {
      _value++;
    });
  }

  void _decrementValue() {
    setState(() {
      _value--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // Set the desired width
      height: 160, // Set the desired height
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
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Adjust the padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: pinkColor),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, size: 20), // Smaller icon size
                  onPressed: _decrementValue,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final newValue = await showDialog<int>(
                        context: context,
                        builder: (context) => NumberInputDialog(
                          initialValue: _value,
                          title: widget.title,
                        ),
                      );
                      if (newValue != null) {
                        setState(() {
                          _value = newValue;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8), // Adjust the padding
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '$_value',
                          style: TextStyle(fontSize: 20), // Smaller text size
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 25), // Smaller icon size
                  onPressed: _incrementValue,
                ),
              ],
            ),
            SizedBox(height: 8), // Adjust the spacing
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor, // Background color
                ),
                onPressed: () => widget.onPressed(_value),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white, // Text color
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

class NumberInputDialog extends StatefulWidget {
  final int initialValue;
  final String title;

  NumberInputDialog({required this.initialValue, required this.title});

  @override
  _NumberInputDialogState createState() => _NumberInputDialogState();
}

class _NumberInputDialogState extends State<NumberInputDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Enter ${widget.title}',
        style: TextStyle(color: pinkColor),
      ),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Enter value',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            int newValue = int.parse(_controller.text);
            Navigator.of(context).pop(newValue);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
