import 'package:flutter/material.dart';

import '../utils/utilities.dart';

class CustomTag extends StatefulWidget {
  final String tagName;
  final Function(String) onTagClick;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color iconBackgroundColor;

  CustomTag({
    required this.tagName,
    required this.onTagClick,
    this.backgroundColor = pinkColor,
    this.textColor = Colors.white,
    this.iconColor = pinkColor,
    this.iconBackgroundColor = Colors.white,
  });

  @override
  _CustomTagState createState() => _CustomTagState();
}

class _CustomTagState extends State<CustomTag> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTagClick(widget.tagName),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => _onHoverEnter(),
              onExit: (_) => _onHoverExit(),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? Colors.grey[300]
                      : widget.iconBackgroundColor,
                  shape: BoxShape.circle,
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add,
                  color: widget.iconColor,
                  size: 20.0,
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              widget.tagName,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onHoverEnter() {
    setState(() {
      _isHovered = true;
    });
  }

  void _onHoverExit() {
    setState(() {
      _isHovered = false;
    });
  }
}
