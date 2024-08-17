import 'package:flutter/material.dart';

/// A reusable TextFormField with validation and optional password visibility toggle.
///
/// Parameters:
/// - `labelText`: The label for the TextFormField.
/// - `icon`: The icon to display in the TextFormField.
/// - `validatorMessage`: The message to display when validation fails.
/// - `validatorFormat`: The validation format (e.g., regex pattern) to apply.
/// - `suffixText`: The text to display as a suffix.
/// - `validator`: An optional custom validator function.
/// - `obscureText`: Controls if the text should be obscured (for passwords).
/// - `showPasswordToggle`: Optionally add a visibility toggle for passwords.
class ReusableTextFormField extends StatefulWidget {
  final String labelText;
  final IconData? icon;
  final String? validatorMessage;
  final RegExp? validatorFormat;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? suffixText;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool
      showPasswordToggle; // New parameter to control password visibility toggle

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
    this.readOnly = false,
    this.showPasswordToggle = false, // Default to false
  });

  @override
  _ReusableTextFormFieldState createState() => _ReusableTextFormFieldState();
}

class _ReusableTextFormFieldState extends State<ReusableTextFormField> {
  bool _passwordVisible = false; // Track password visibility state

  @override
  void initState() {
    super.initState();
    _passwordVisible = !widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText:
          widget.showPasswordToggle ? !_passwordVisible : widget.obscureText,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        suffixText: widget.suffixText,
        suffixIcon: widget.showPasswordToggle
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
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
          fontSize: 12.0,
          color: const Color.fromARGB(255, 184, 32, 21),
        ),
      ),
      keyboardType: widget.keyboardType,
      validator: widget.validator ??
          (value) {
            if (widget.validatorFormat != null &&
                widget.validatorMessage != null) {
              if (value == null || !widget.validatorFormat!.hasMatch(value)) {
                return widget.validatorMessage;
              }
            } else {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
            }
            return null;
          },
    );
  }
}
