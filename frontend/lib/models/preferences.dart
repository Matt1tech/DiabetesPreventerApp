import 'package:json_annotation/json_annotation.dart';

part 'preferences.g.dart';

@JsonSerializable()
class Preferences {
  List<String> mealsPerDay;
  List<String> allergies;
  List<String> dietsFollowed;
  int dailyCaloriesMax;
  int maxProtein;
  int maxFiber;
  int maxFat;
  int maxCholesterol;
  String userId; // Assuming the user ID is stored as a String
  DateTime createdAt;

  Preferences({
    required this.mealsPerDay,
    required this.allergies,
    required this.dietsFollowed,
    required this.dailyCaloriesMax,
    required this.maxProtein,
    required this.maxFiber,
    required this.maxFat,
    required this.maxCholesterol,
    required this.userId,
    required this.createdAt,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesToJson(this);
}
