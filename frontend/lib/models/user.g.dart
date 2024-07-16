// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) => Preferences(
      preferences: json['preferences'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'preferences': instance.preferences,
    };

HealthRecords _$HealthRecordsFromJson(Map<String, dynamic> json) =>
    HealthRecords(
      blood_glucose: (json['blood_glucose'] as num).toDouble(),
      blood_pressure: json['blood_pressure'] as String,
      bmi: (json['bmi'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$HealthRecordsToJson(HealthRecords instance) =>
    <String, dynamic>{
      'blood_glucose': instance.blood_glucose,
      'blood_pressure': instance.blood_pressure,
      'bmi': instance.bmi,
      'weight': instance.weight,
    };

PhysicalActivity _$PhysicalActivityFromJson(Map<String, dynamic> json) =>
    PhysicalActivity(
      duration: json['duration'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$PhysicalActivityToJson(PhysicalActivity instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'type': instance.type,
    };

PhysicalRecords _$PhysicalRecordsFromJson(Map<String, dynamic> json) =>
    PhysicalRecords(
      physical_activity: PhysicalActivity.fromJson(
          json['physical_activity'] as Map<String, dynamic>),
      stress_level: (json['stress_level'] as num).toInt(),
    );

Map<String, dynamic> _$PhysicalRecordsToJson(PhysicalRecords instance) =>
    <String, dynamic>{
      'physical_activity': instance.physical_activity,
      'stress_level': instance.stress_level,
    };

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      number: (json['number'] as num).toInt(),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      nutrients: json['nutrients'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'quantity': instance.quantity,
      'nutrients': instance.nutrients,
    };

DailyRecord _$DailyRecordFromJson(Map<String, dynamic> json) => DailyRecord(
      date: DateTime.parse(json['date'] as String),
      health_record: DailyRecord._healthRecordFromJson(
          json['health_record'] as Map<String, dynamic>),
      physical_record: DailyRecord._physicalRecordFromJson(
          json['physical_record'] as Map<String, dynamic>),
      meals: (json['meals'] as List<dynamic>)
          .map((e) => Meal.fromJson(e as Map<String, dynamic>))
          .toList(),
      diabetes_risk: (json['diabetes_risk'] as num).toDouble(),
    );

Map<String, dynamic> _$DailyRecordToJson(DailyRecord instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'health_record': DailyRecord._healthRecordToJson(instance.health_record),
      'physical_record':
          DailyRecord._physicalRecordToJson(instance.physical_record),
      'meals': instance.meals,
      'diabetes_risk': instance.diabetes_risk,
    };

MonthlyRecord _$MonthlyRecordFromJson(Map<String, dynamic> json) =>
    MonthlyRecord(
      month: DateTime.parse(json['month'] as String),
      avg_blood_glucose: (json['avg_blood_glucose'] as num).toDouble(),
      avg_blood_pressure: json['avg_blood_pressure'] as String,
      avg_calories: (json['avg_calories'] as num).toDouble(),
      avg_bmi: (json['avg_bmi'] as num).toDouble(),
      weight_increase: (json['weight_increase'] as num).toDouble(),
      monthly_risk: (json['monthly_risk'] as num).toDouble(),
      overall_health_status: json['overall_health_status'] as String,
    );

Map<String, dynamic> _$MonthlyRecordToJson(MonthlyRecord instance) =>
    <String, dynamic>{
      'month': instance.month.toIso8601String(),
      'avg_blood_glucose': instance.avg_blood_glucose,
      'avg_blood_pressure': instance.avg_blood_pressure,
      'avg_calories': instance.avg_calories,
      'avg_bmi': instance.avg_bmi,
      'weight_increase': instance.weight_increase,
      'monthly_risk': instance.monthly_risk,
      'overall_health_status': instance.overall_health_status,
    };

MealRecommendation _$MealRecommendationFromJson(Map<String, dynamic> json) =>
    MealRecommendation(
      recommendations: json['recommendations'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$MealRecommendationToJson(MealRecommendation instance) =>
    <String, dynamic>{
      'recommendations': instance.recommendations,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      marital_status: json['marital_status'] as String,
      height: json['height'] as String,
      birthdate: json['birthdate'] as String,
      family_history: json['family_history'] as bool,
      profile_picture: json['profile_picture'] as String,
      preferences: json['preferences'] == null
          ? null
          : Preferences.fromJson(json['preferences'] as Map<String, dynamic>),
      health_records: (json['health_records'] as List<dynamic>?)
          ?.map((e) => HealthRecords.fromJson(e as Map<String, dynamic>))
          .toList(),
      physical_records: (json['physical_records'] as List<dynamic>?)
          ?.map((e) => PhysicalRecords.fromJson(e as Map<String, dynamic>))
          .toList(),
      meal_recommendation: json['meal_recommendation'] == null
          ? null
          : MealRecommendation.fromJson(
              json['meal_recommendation'] as Map<String, dynamic>),
      daily_records: (json['daily_records'] as List<dynamic>?)
          ?.map((e) => DailyRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      monthly_records: (json['monthly_records'] as List<dynamic>?)
          ?.map((e) => MonthlyRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      user_notification: json['user_notification'] as String?,
      created_at: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'gender': instance.gender,
      'marital_status': instance.marital_status,
      'height': instance.height,
      'birthdate': instance.birthdate,
      'family_history': instance.family_history,
      'profile_picture': instance.profile_picture,
      'preferences': instance.preferences,
      'health_records': instance.health_records,
      'physical_records': instance.physical_records,
      'meal_recommendation': instance.meal_recommendation,
      'daily_records': instance.daily_records,
      'monthly_records': instance.monthly_records,
      'user_notification': instance.user_notification,
      'created_at': instance.created_at.toIso8601String(),
    };
