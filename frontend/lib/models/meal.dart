import 'package:json_annotation/json_annotation.dart';

part 'meal.g.dart';

@JsonSerializable()
class Meal {
  int number;
  String name;
  double quantity;
  double calories;
  double protein;
  double fats;
  double carbs;
  double fiber;
  Map<String, dynamic> nutrients;

  Meal({
    required this.number,
    required this.name,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.fats,
    required this.carbs,
    required this.fiber,
    required this.nutrients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);
}
