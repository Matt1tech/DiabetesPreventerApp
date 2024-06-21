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

Widget header({required String imagePath, required String welcomeMessage}) {
  return Column(
    children: [
      PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: Container(
          margin: const EdgeInsets.only(top: 50.0),
          child: AppBar(
            backgroundColor: blueColor,
            automaticallyImplyLeading: false, // Hides the default back arrow
            flexibleSpace: Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Diabetes Preventer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
            ),
          ),
        ),
      ),
      Container(
        color: pinkColor,
        height: 50,
        width: double.infinity, // Full width
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0), // Adjust left padding as needed
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              welcomeMessage,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

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
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: Colors.white, width: 2), // Ensure white border around
      ),
      child: ToggleButtons(
        borderColor: Colors.white,
        fillColor: blueColor,
        borderWidth: 3,
        selectedBorderColor: blueColor,
        selectedColor: Colors.white,
        borderRadius: BorderRadius.circular(8),
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 110.0,
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        }
      },
    ),
  );
}
