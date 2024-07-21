import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(228, 238, 235, 235),
    );
  }
}

//Color
const blueColor = Color.fromARGB(255, 30, 96, 195);
const pinkColor = Color.fromARGB(255, 141, 87, 255);

Widget footer() {
  return Container(
    margin: const EdgeInsets.only(bottom: 00.0),
    color: blueColor,
    height: 80, // Adjust height as needed
    width: double.infinity, // Full width
    child: Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '©2024, All Right Reserved. Diabetes Preventer',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

class CustomToggleButtons extends StatefulWidget {
  final List<String> options;
  final List<bool> isSelected;
  final Function(int) onPressed;

  const CustomToggleButtons({
    Key? key,
    required this.options,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomToggleButtonsState createState() => _CustomToggleButtonsState();
}

class _CustomToggleButtonsState extends State<CustomToggleButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // White background color
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
            color: Colors.white, width: 1), // Ensure white border around
      ),
      child: ToggleButtons(
        borderColor: Colors.white,
        fillColor: blueColor,
        borderWidth: 3,
        selectedBorderColor: blueColor,
        selectedColor: Colors.white,
        borderRadius: BorderRadius.circular(7),
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 95.0,
        ),
        isSelected: widget.isSelected,
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < widget.isSelected.length;
                buttonIndex++) {
              widget.isSelected[buttonIndex] = buttonIndex == index;
            }
          });
          widget.onPressed(index);
        },
        children: widget.options.map((option) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              option,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

Widget buildDatePickerField(
    BuildContext context, String labelText, IconData icon,
    {double? width, required TextEditingController controller}) {
  return SizedBox(
    width: width,
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        labelStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: 20.0,
          color: Color.fromARGB(255, 141, 87, 255),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelAlignment: FloatingLabelAlignment.start,
      ),
      readOnly: true, // Prevent the user from directly editing the date
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode()); // Hide keyboard
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          // Update the controller directly, no need to call setState here
          controller.text =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        }
      },
    ),
  );
}

/*
/// A reusable TextFormField with validation.
///
/// Parameters:
/// - `labelText`: The label for the TextFormField.
/// - `icon`: The icon to display in the TextFormField.
/// - `validatorMessage`: The message to display when validation fails.
/// - `validatorFormat`: The validation format (e.g., regex pattern) to apply.
/// - `suffixText`: The text to display as a suffix.
/// - `validator`: An optional custom validator function.
class ReusableTextFormField extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final String? validatorMessage; // Change to optional
  final RegExp? validatorFormat; // Change to optional
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? suffixText;
  final String? Function(String?)? validator;

  ReusableTextFormField({
    required this.labelText,
    this.icon,
    this.validatorMessage,
    this.validatorFormat,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixText: suffixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        labelStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.grey,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: 20.0,
          color: Theme.of(context).primaryColor,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        errorStyle: TextStyle(
          // Customize the error style here
          fontSize: 12.0, // Set the font size for the validator message
          color: const Color.fromARGB(
              255, 184, 32, 21), // Set the color for the validator message
        ),
      ),
      keyboardType: keyboardType,
      validator: validator ??
          (value) {
            if (validatorFormat != null && validatorMessage != null) {
              if (value == null || !validatorFormat!.hasMatch(value)) {
                return validatorMessage;
              }
            } else {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
            }
            return null;
          },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
*/
//Dialog Box

void showErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Continue'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<bool> showConfirmationDialog(
    BuildContext context, String title, String message) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Return false when Cancel is pressed
            },
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true when OK is pressed
            },
          ),
        ],
      );
    },
  ).then((value) => value ?? false); // Ensure it returns false if value is null
}

class HealthPulseCard extends StatefulWidget {
  @override
  _HealthPulseCardState createState() => _HealthPulseCardState();
}

class _HealthPulseCardState extends State<HealthPulseCard> {
  int _heartPulse = 75;

  void _incrementPulse() {
    setState(() {
      _heartPulse++;
    });
  }

  void _decrementPulse() {
    setState(() {
      _heartPulse--;
    });
  }

  void _sendValueToBackend() {
    // Prepare the value to send to the backend
    int heartPulseValue = _heartPulse;
    // Code to send the value to the backend would go here
    print("Sending heart pulse value to backend: $heartPulseValue");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Heart Pulse',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _decrementPulse,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final newValue = await showDialog<int>(
                        context: context,
                        builder: (context) =>
                            NumberInputDialog(initialValue: _heartPulse),
                      );
                      if (newValue != null) {
                        setState(() {
                          _heartPulse = newValue;
                        });
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '$_heartPulse',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _incrementPulse,
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendValueToBackend,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class NumberInputDialog extends StatefulWidget {
  final int initialValue;

  NumberInputDialog({required this.initialValue});

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
      title: Text('Enter Heart Pulse'),
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
