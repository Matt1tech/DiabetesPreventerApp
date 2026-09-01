import 'package:json_annotation/json_annotation.dart';

part 'meal.g.dart';

@JsonSerializable()
class Meal {
  String name;
  double quantity;
  double calories;
  double protein;
  double fats;
  double carbs;
  double fiber;
  double cholesterol;
  int user; // User ID field

  Meal({
    required this.name,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.fats,
    required this.carbs,
    required this.fiber,
    required this.cholesterol,
    required this.user,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);
}
