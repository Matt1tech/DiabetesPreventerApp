import 'package:flutter/material.dart';
import 'package:frontend/utils/utils.dart';

class HealthMeasurementLogsCard extends StatefulWidget {
  final String title;
  final String name;
  final void Function(int) onPressed;
  final Color cardColor;
  final List<BoxShadow> boxShadow;
  final double width;
  final double height;

  HealthMeasurementLogsCard({
    required this.title,
    required this.name,
    required this.onPressed,
    this.cardColor = Colors.white,
    this.boxShadow = const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    this.width = 180, // Default width
    this.height = 160, // Default height
  });

  @override
  _HealthMeasurementLogsCardState createState() =>
      _HealthMeasurementLogsCardState();
}

class _HealthMeasurementLogsCardState extends State<HealthMeasurementLogsCard> {
  int _value = 120;

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

  void _saveRecord() {
    widget.onPressed(_value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.title} successfully recorded'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.cardColor,
        boxShadow: widget.boxShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  icon: Icon(Icons.remove, size: 20),
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
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '$_value',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 25),
                  onPressed: _incrementValue,
                ),
              ],
            ),
            SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor,
                ),
                onPressed: _saveRecord, // Updated to use the new method
                child: Text(
                  'Save',
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
