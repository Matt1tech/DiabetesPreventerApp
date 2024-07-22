import 'package:json_annotation/json_annotation.dart';

part 'meal_recommendation.g.dart';

@JsonSerializable()
class MealRecommendation {
  Map<String, dynamic> recommendations;

  MealRecommendation({required this.recommendations});

  factory MealRecommendation.fromJson(Map<String, dynamic> json) =>
      _$MealRecommendationFromJson(json);
  Map<String, dynamic> toJson() => _$MealRecommendationToJson(this);
}
