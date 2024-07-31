import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Method to build the date picker field with validation
Widget buildDatePickerFieldBirthDate(
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
        DateTime now = DateTime.now();
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(1900),
          lastDate: now,
        );
        if (pickedDate != null) {
          controller.text =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your birthdate';
        }
        final DateTime? selectedDate = DateTime.tryParse(value);
        if (selectedDate == null) {
          return 'Invalid date format';
        }
        final DateTime now = DateTime.now();
        final int age = now.year - selectedDate.year;
        if (selectedDate.isAfter(now)) {
          return 'Invalid date-Future date';
        }
        if (age < 7 ||
            (age == 7 && now.month < selectedDate.month) ||
            (age == 7 &&
                now.month == selectedDate.month &&
                now.day < selectedDate.day)) {
          return 'age at least 7/y';
        }
        return null;
      },
    ),
  );
}

// Method to build the date picker field with validation
Widget buildDatePickerFieldReport(BuildContext context, String labelText,
    IconData icon, TextEditingController controller,
    {DateTime? firstDate,
    DateTime? lastDate,
    required void Function(DateTime) onDateSelected,
    String? Function(String?)? validator}) {
  return SizedBox(
    width: double.infinity,
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
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2101),
        );
        if (pickedDate != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          onDateSelected(pickedDate);
        }
      },
      validator: validator,
    ),
  );
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
