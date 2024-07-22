import 'package:json_annotation/json_annotation.dart';

part 'preferences.g.dart';

@JsonSerializable()
class Preferences {
  List<String> meals_per_day;
  List<String> allergies;
  List<String> diets_followed;
  int daily_calories_min;
  int daily_calories_max;

  Preferences({
    required this.meals_per_day,
    required this.allergies,
    required this.diets_followed,
    required this.daily_calories_min,
    required this.daily_calories_max,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesToJson(this);
}
