import 'package:flutter/material.dart';

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
