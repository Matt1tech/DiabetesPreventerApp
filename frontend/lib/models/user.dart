import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class Preferences {
  Map<String, dynamic> preferences;

  Preferences({required this.preferences});

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesToJson(this);
}

@JsonSerializable()
class HealthRecords {
  double blood_glucose;
  String blood_pressure;
  double bmi;
  double weight;
  double diabetes_risk;
  DateTime created_at;

  HealthRecords({
    required this.blood_glucose,
    required this.blood_pressure,
    required this.bmi,
    required this.weight,
    required this.diabetes_risk,
    required this.created_at,
  });

  factory HealthRecords.fromJson(Map<String, dynamic> json) =>
      _$HealthRecordsFromJson(json);
  Map<String, dynamic> toJson() => _$HealthRecordsToJson(this);
}

@JsonSerializable()
class PhysicalActivity {
  String duration;
  String type;

  PhysicalActivity({required this.duration, required this.type});

  factory PhysicalActivity.fromJson(Map<String, dynamic> json) =>
      _$PhysicalActivityFromJson(json);
  Map<String, dynamic> toJson() => _$PhysicalActivityToJson(this);
}

@JsonSerializable()
class PhysicalRecords {
  PhysicalActivity physical_activity;
  int stress_level;
  DateTime time;
  DateTime created_at;

  PhysicalRecords({
    required this.physical_activity,
    required this.stress_level,
    required this.time,
    required this.created_at,
  });

  factory PhysicalRecords.fromJson(Map<String, dynamic> json) =>
      _$PhysicalRecordsFromJson(json);
  Map<String, dynamic> toJson() => _$PhysicalRecordsToJson(this);
}

@JsonSerializable()
class Meal {
  int number;
  String name;
  double quantity;
  Map<String, dynamic> nutrients;

  Meal({
    required this.number,
    required this.name,
    required this.quantity,
    required this.nutrients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);
}

@JsonSerializable()
class MealRecommendation {
  Map<String, dynamic> recommendations;

  MealRecommendation({required this.recommendations});

  factory MealRecommendation.fromJson(Map<String, dynamic> json) =>
      _$MealRecommendationFromJson(json);
  Map<String, dynamic> toJson() => _$MealRecommendationToJson(this);
}

@JsonSerializable()
class User {
  int id;
  String name;
  String email;
  String gender;
  String marital_status;
  double height;
  String birthdate;
  bool family_history;
  String profile_picture;
  Preferences? preferences;
  List<HealthRecords>? health_records;
  List<PhysicalRecords>? physical_records;
  DateTime created_at;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.marital_status,
    required this.height,
    required this.birthdate,
    required this.family_history,
    required this.profile_picture,
    this.preferences,
    this.health_records,
    this.physical_records,
    required this.created_at,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
