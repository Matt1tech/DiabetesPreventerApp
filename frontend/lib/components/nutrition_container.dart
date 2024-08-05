import 'package:flutter/material.dart';
import 'package:frontend/utils/utilities.dart';

/// A widget that displays nutrition information in a container.
class NutritionContainer extends StatelessWidget {
  final String title;
  final String calories;
  final Color textColor;

  /// Creates a NutritionContainer widget.
  ///
  /// [title] is the name of the nutrient.
  /// [calories] is the calorie content of the nutrient.
  /// [textColor] is the color of the text displaying the title.
  const NutritionContainer({
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
          color: const Color.fromARGB(217, 255, 255, 255),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0, 2),
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
                calories,
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

class AnimatedNutritionContainer extends StatefulWidget {
  final String title;
  final int calories;
  final int maxCalories;
  final Color textColor;

  /// Creates an AnimatedNutritionContainer widget.
  ///
  /// [title] is the name of the nutrient.
  /// [calories] is the calorie content of the nutrient.
  /// [maxCalories] is the maximum calorie content for the nutrient.
  /// [textColor] is the color of the text displaying the title.
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
  /// Calculates the fill percentage for the animated container.
  double get fillPercentage =>
      widget.calories /
      widget.maxCalories.toDouble(); // Ensure the division result is double

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 80,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                height: 100.0 * fillPercentage,
                width: 90,
                decoration: BoxDecoration(
                  color: widget.textColor.withOpacity(0.5),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8.0),
                  ),
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
                      '${widget.calories} / ${widget.maxCalories} cal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(.5),
                        fontSize: 10.0,
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

class AnimatedHorizontalContainer extends StatefulWidget {
  final String title;
  final int calories;
  final int maxCalories;
  final Color fillColor;
  final Color textColor;

  /// Creates an AnimatedHorizontalContainer widget.
  ///
  /// [title] is the name of the nutrient.
  /// [calories] is the calorie content of the nutrient.
  /// [maxCalories] is the maximum calorie content for the nutrient.
  /// [fillColor] is the color of the fill animation.
  /// [textColor] is the color of the text displaying the title.
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
  /// Calculates the fill percentage for the animated container.
  double get fillPercentage =>
      widget.calories /
      widget.maxCalories.toDouble(); // Ensure the division result is double

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 35,
        width: 365,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: 365 * fillPercentage,
                height: 35,
                decoration: BoxDecoration(
                  color: widget.fillColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
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
                    '${widget.calories} /${widget.maxCalories} cal',
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

class NutritionDetails extends StatelessWidget {
  final int totalCalories;
  final int proteinCalories;
  final int fatsCalories;
  final int carbsCalories;
  final int fiberCalories;
  final int maxTotalCalories;
  final int maxProteinCalories;
  final int maxFatsCalories;
  final int maxCarbsCalories;
  final int maxFiberCalories;

  NutritionDetails({
    required this.totalCalories,
    required this.proteinCalories,
    required this.fatsCalories,
    required this.carbsCalories,
    required this.fiberCalories,
    this.maxTotalCalories = 3000,
    this.maxProteinCalories = 200,
    this.maxFatsCalories = 300,
    this.maxCarbsCalories = 400,
    this.maxFiberCalories = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Container(
          height: 210,
          width: double.infinity,
          color: Color.fromARGB(255, 240, 236, 236),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Nutrition Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                    fontSize: 22.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: AnimatedHorizontalContainer(
                  title: 'Total Calories',
                  calories: totalCalories,
                  maxCalories: maxTotalCalories,
                  fillColor: pinkColor,
                  textColor: pinkColor,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedNutritionContainer(
                    title: 'Protein',
                    calories: proteinCalories,
                    maxCalories: maxProteinCalories,
                    textColor: const Color.fromARGB(255, 164, 103, 12),
                  ),
                  AnimatedNutritionContainer(
                    title: 'Fats',
                    calories: fatsCalories,
                    maxCalories: maxFatsCalories,
                    textColor: pinkColor,
                  ),
                  AnimatedNutritionContainer(
                    title: 'Carbs',
                    calories: carbsCalories,
                    maxCalories: maxCarbsCalories,
                    textColor: const Color.fromARGB(255, 227, 204, 32),
                  ),
                  AnimatedNutritionContainer(
                    title: 'Fiber',
                    calories: fiberCalories,
                    maxCalories: maxFiberCalories,
                    textColor: const Color.fromARGB(255, 3, 58, 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
