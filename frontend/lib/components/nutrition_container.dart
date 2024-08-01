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

/// A widget that displays animated nutrition information in a vertical container.
class AnimatedNutritionContainer extends StatefulWidget {
  final String title;
  final double calories;
  final double maxCalories;
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
  double get fillPercentage => widget.calories / widget.maxCalories;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100.0,
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
                      '${widget.calories}cal/${widget.maxCalories}cal',
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

/// A widget that displays animated nutrition information in a horizontal container.
class AnimatedHorizontalContainer extends StatefulWidget {
  final String title;
  final double calories;
  final double maxCalories;
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
  double get fillPercentage => widget.calories / widget.maxCalories;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 30.0,
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
                height: 30.0,
                decoration: BoxDecoration(
                  color: widget.fillColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.0),
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
                    '${widget.calories}cal/${widget.maxCalories}cal',
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

/// A widget that displays detailed nutrition information.
class NutritionDetails extends StatelessWidget {
  final double totalCalories;
  final double proteinCalories;
  final double fatsCalories;
  final double carbsCalories;
  final double fiberCalories;
  final double maxTotalCalories;
  final double maxProteinCalories;
  final double maxFatsCalories;
  final double maxCarbsCalories;
  final double maxFiberCalories;

  /// Creates a NutritionDetails widget with default max calories.
  ///
  /// [totalCalories] is the total calorie intake.
  /// [proteinCalories] is the calorie content for protein.
  /// [fatsCalories] is the calorie content for fats.
  /// [carbsCalories] is the calorie content for carbohydrates.
  /// [fiberCalories] is the calorie content for fiber.
  NutritionDetails({
    required this.totalCalories,
    required this.proteinCalories,
    required this.fatsCalories,
    required this.carbsCalories,
    required this.fiberCalories,
  })  : maxTotalCalories = 3000,
        maxProteinCalories = 200,
        maxFatsCalories = 300,
        maxCarbsCalories = 400,
        maxFiberCalories = 100;

  /// Creates a NutritionDetails widget with max calories for each nutrient.
  ///
  /// [maxTotalCalories] is the maximum total calorie intake.
  /// [maxProteinCalories] is the maximum calorie content for protein.
  /// [maxFatsCalories] is the maximum calorie content for fats.
  /// [maxCarbsCalories] is the maximum calorie content for carbohydrates.
  /// [maxFiberCalories] is the maximum calorie content for fiber.
  NutritionDetails.withMaxCalories({
    required this.maxTotalCalories,
    required this.maxProteinCalories,
    required this.maxFatsCalories,
    required this.maxCarbsCalories,
    required this.maxFiberCalories,
  })  : totalCalories = 0,
        proteinCalories = 0,
        fatsCalories = 0,
        carbsCalories = 0,
        fiberCalories = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Container(
          height: 210,
          width: 420,
          color: const Color.fromARGB(217, 217, 217, 217),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Nutrition Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                    fontSize: 24.0,
                  ),
                ),
              ),
              const SizedBox(height: 15),
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
