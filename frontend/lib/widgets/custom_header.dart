import 'package:flutter/material.dart';
import '../utils/utilities.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? imagePath;
  final ImageProvider? imageProvider;
  final String welcomeMessage;
  final bool showWelcomeMessage;
  final double topPadding;

  CustomHeader({
    this.imagePath,
    this.imageProvider,
    required this.welcomeMessage,
    this.showWelcomeMessage = true,
    this.topPadding = 50.0,
  });

  @override
  Size get preferredSize => showWelcomeMessage
      ? const Size.fromHeight(170.0)
      : const Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {
    ImageProvider effectiveImage = imageProvider ??
        (imagePath != null ? AssetImage(imagePath!) : AssetImage(''));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(top: topPadding),
          child: AppBar(
            backgroundColor: blueColor,
            automaticallyImplyLeading: false,
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
                      child: Image(
                        image: effectiveImage,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
                      'Diabetes Preventer',
                      style: TextStyle(
                        fontSize: 21,
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
        if (showWelcomeMessage)
          Container(
            color: pinkColor,
            height: 50,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
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
}
