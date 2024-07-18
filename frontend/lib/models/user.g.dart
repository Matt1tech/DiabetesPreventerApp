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
      diabetes_risk: (json['diabetes_risk'] as num).toDouble(),
      created_at: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$HealthRecordsToJson(HealthRecords instance) =>
    <String, dynamic>{
      'blood_glucose': instance.blood_glucose,
      'blood_pressure': instance.blood_pressure,
      'bmi': instance.bmi,
      'weight': instance.weight,
      'diabetes_risk': instance.diabetes_risk,
      'created_at': instance.created_at.toIso8601String(),
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
      time: DateTime.parse(json['time'] as String),
      created_at: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PhysicalRecordsToJson(PhysicalRecords instance) =>
    <String, dynamic>{
      'physical_activity': instance.physical_activity,
      'stress_level': instance.stress_level,
      'time': instance.time.toIso8601String(),
      'created_at': instance.created_at.toIso8601String(),
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

MealRecommendation _$MealRecommendationFromJson(Map<String, dynamic> json) =>
    MealRecommendation(
      recommendations: json['recommendations'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$MealRecommendationToJson(MealRecommendation instance) =>
    <String, dynamic>{
      'recommendations': instance.recommendations,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      marital_status: json['marital_status'] as String,
      height: (json['height'] as num).toDouble(),
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
      'created_at': instance.created_at.toIso8601String(),
    };
