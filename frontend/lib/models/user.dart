// lib/models/user.dart
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

  HealthRecords(
      {required this.blood_glucose,
      required this.blood_pressure,
      required this.bmi,
      required this.weight});

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

  PhysicalRecords(
      {required this.physical_activity, required this.stress_level});

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

  Meal(
      {required this.number,
      required this.name,
      required this.quantity,
      required this.nutrients});

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);
}

@JsonSerializable()
class DailyRecord {
  DateTime date;
  @JsonKey(fromJson: _healthRecordFromJson, toJson: _healthRecordToJson)
  HealthRecords health_record;
  @JsonKey(fromJson: _physicalRecordFromJson, toJson: _physicalRecordToJson)
  PhysicalRecords physical_record;
  List<Meal> meals;
  double diabetes_risk;

  DailyRecord(
      {required this.date,
      required this.health_record,
      required this.physical_record,
      required this.meals,
      required this.diabetes_risk});

  factory DailyRecord.fromJson(Map<String, dynamic> json) =>
      _$DailyRecordFromJson(json);
  Map<String, dynamic> toJson() => _$DailyRecordToJson(this);

  static HealthRecords _healthRecordFromJson(Map<String, dynamic> json) =>
      HealthRecords.fromJson(json);
  static Map<String, dynamic> _healthRecordToJson(HealthRecords instance) =>
      instance.toJson();

  static PhysicalRecords _physicalRecordFromJson(Map<String, dynamic> json) =>
      PhysicalRecords.fromJson(json);
  static Map<String, dynamic> _physicalRecordToJson(PhysicalRecords instance) =>
      instance.toJson();
}

@JsonSerializable()
class MonthlyRecord {
  DateTime month;
  double avg_blood_glucose;
  String avg_blood_pressure;
  double avg_calories;
  double avg_bmi;
  double weight_increase;
  double monthly_risk;
  String overall_health_status;

  MonthlyRecord(
      {required this.month,
      required this.avg_blood_glucose,
      required this.avg_blood_pressure,
      required this.avg_calories,
      required this.avg_bmi,
      required this.weight_increase,
      required this.monthly_risk,
      required this.overall_health_status});

  factory MonthlyRecord.fromJson(Map<String, dynamic> json) =>
      _$MonthlyRecordFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyRecordToJson(this);
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
  String id;
  String name;
  String email;
  String gender;
  String marital_status;
  String height;
  String birthdate;
  bool family_history;
  String profile_picture;
  Preferences? preferences;
  List<HealthRecords>? health_records;
  List<PhysicalRecords>? physical_records;
  MealRecommendation? meal_recommendation;
  List<DailyRecord>? daily_records;
  List<MonthlyRecord>? monthly_records;
  String? user_notification;
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
    this.meal_recommendation,
    this.daily_records,
    this.monthly_records,
    this.user_notification,
    required this.created_at,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
