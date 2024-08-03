import 'package:flutter/material.dart';

import '../utils/utilities.dart';

class CustomTag extends StatelessWidget {
  final String tagName;
  final Function(String) onTagClick;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color iconBackgroundColor;

  CustomTag({
    required this.tagName,
    required this.onTagClick,
    this.backgroundColor =
        const Color.fromARGB(197, 206, 206, 206), // Darker background color
    this.textColor = pinkColor,
    this.iconColor = pinkColor,
    this.iconBackgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTagClick(tagName),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                color: iconColor,
                size: 20.0,
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              tagName,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
