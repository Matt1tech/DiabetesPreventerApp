import 'package:json_annotation/json_annotation.dart';

part 'Customizations.g.dart';

@JsonSerializable()
class Customizations {
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

  Customizations({
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

  factory Customizations.fromJson(Map<String, dynamic> json) =>
      _$CustomizationsFromJson(json);
  Map<String, dynamic> toJson() => _$CustomizationsToJson(this);
}
