import 'package:flutter/material.dart';

class NutritionContainer extends StatelessWidget {
  final String title;
  final String calories;
  final Color textColor;

  NutritionContainer({
    required this.title,
    required this.calories,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 70.0,
        width: 90,
        decoration: BoxDecoration(
          color: Color.fromARGB(217, 255, 255, 255),
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 4.0, // Shadow blur radius
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                calories, // Variable for the number of calories
                style: TextStyle(
                  color: Colors.black.withOpacity(.4),
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Vertical ANIMATED CONTAINER
class AnimatedNutritionContainer extends StatefulWidget {
  final String title;
  final int calories;
  final int maxCalories;
  final Color textColor;

  AnimatedNutritionContainer({
    required this.title,
    required this.calories,
    required this.maxCalories,
    required this.textColor,
  });

  @override
  _AnimatedNutritionContainerState createState() =>
      _AnimatedNutritionContainerState();
}

class _AnimatedNutritionContainerState
    extends State<AnimatedNutritionContainer> {
  double get fillPercentage => widget.calories / widget.maxCalories;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100.0, // Adjust height as needed
        width: 80,
        decoration: BoxDecoration(
          color: Color.fromARGB(
              255, 255, 255, 255), // Make the background transparent
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 4.0, // Shadow blur radius
              offset: Offset(0, 2), // Shadow position
            ),
          ],
          border: Border.all(
            color: Colors.grey, // Border color
            width: 1.0, // Border width
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                height: 100.0 *
                    fillPercentage, // Dynamic height based on fillPercentage
                width: 90,
                decoration: BoxDecoration(
                  color: widget.textColor.withOpacity(0.5), // Fill color
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8.0),
                  ), // Rounded bottom corners
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${widget.calories}cal/${widget.maxCalories}cal', // Display the calories
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(.4),
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Horizontal ANIMATED CONTAINER
class AnimatedHorizontalContainer extends StatefulWidget {
  final String title;
  final int calories;
  final int maxCalories;
  final Color fillColor;
  final Color textColor;

  AnimatedHorizontalContainer({
    required this.title,
    required this.calories,
    required this.maxCalories,
    required this.fillColor,
    required this.textColor,
  });

  @override
  _AnimatedHorizontalContainerState createState() =>
      _AnimatedHorizontalContainerState();
}

class _AnimatedHorizontalContainerState
    extends State<AnimatedHorizontalContainer> {
  double get fillPercentage => widget.calories / widget.maxCalories;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 30.0,
        width: 365,
        decoration: BoxDecoration(
          color: Colors.white, // Make the background transparent
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 4.0, // Shadow blur radius
              offset: Offset(0, 2), // Shadow position
            ),
          ],
          border: Border.all(
            color: Colors.grey, // Border color
            width: 1.0, // Border width
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: 365 *
                    fillPercentage, // Dynamic width based on fillPercentage
                height: 30.0,
                decoration: BoxDecoration(
                  color: widget.fillColor.withOpacity(0.5), // Fill color
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    '${widget.calories}cal/${widget.maxCalories}cal', // Display the calories
                    style: TextStyle(
                      color: Colors.black.withOpacity(.4),
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
