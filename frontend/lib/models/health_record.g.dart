// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthRecord _$HealthRecordFromJson(Map<String, dynamic> json) => HealthRecord(
      blood_glucose: (json['blood_glucose'] as num).toDouble(),
      blood_pressure: json['blood_pressure'] as String,
      bmi: (json['bmi'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      diabetes_risk: (json['diabetes_risk'] as num).toDouble(),
      created_at: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$HealthRecordToJson(HealthRecord instance) =>
    <String, dynamic>{
      'blood_glucose': instance.blood_glucose,
      'blood_pressure': instance.blood_pressure,
      'bmi': instance.bmi,
      'weight': instance.weight,
      'diabetes_risk': instance.diabetes_risk,
      'created_at': instance.created_at.toIso8601String(),
    };
