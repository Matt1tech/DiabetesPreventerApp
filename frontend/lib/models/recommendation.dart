import 'package:json_annotation/json_annotation.dart';

part 'recommendation.g.dart';

@JsonSerializable()
class Recommendation {
  final String name;
  final String category;
  final String type;
  final double protein;
  final double fat;
  final double fiber;
  final double cholesterol;
  final double carbs;
  final bool lowFat;
  final bool lowCarb;
  final bool highProtein;
  final bool noSugar;
  final bool wheatFree;
  final bool eggFree;
  final bool soyFree;
  final String imageUrl;
  final String recipe;
  final double total_calories;

  Recommendation({
    required this.name,
    required this.category,
    required this.type,
    required this.protein,
    required this.fat,
    required this.fiber,
    required this.cholesterol,
    required this.carbs,
    required this.lowFat,
    required this.lowCarb,
    required this.highProtein,
    required this.noSugar,
    required this.wheatFree,
    required this.eggFree,
    required this.soyFree,
    required this.imageUrl,
    required this.recipe,
    required this.total_calories,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) =>
      _$RecommendationFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendationToJson(this);
}
