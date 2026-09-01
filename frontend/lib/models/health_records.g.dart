// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_records.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthRecord _$HealthRecordFromJson(Map<String, dynamic> json) => HealthRecord(
      blood_glucose: (json['blood_glucose'] as num?)?.toDouble(),
      blood_pressure: (json['blood_pressure'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      diabetes_risk: (json['diabetes_risk'] as num?)?.toDouble(),
      diabetes_risk_probability_class_0:
          (json['diabetes_risk_probability_class_0'] as num?)?.toDouble(),
      diabetes_risk_probability_class_1:
          (json['diabetes_risk_probability_class_1'] as num?)?.toDouble(),
      diabetes_risk_probability_class_2:
          (json['diabetes_risk_probability_class_2'] as num?)?.toDouble(),
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$HealthRecordToJson(HealthRecord instance) =>
    <String, dynamic>{
      'blood_glucose': instance.blood_glucose,
      'blood_pressure': instance.blood_pressure,
      'bmi': instance.bmi,
      'weight': instance.weight,
      'diabetes_risk': instance.diabetes_risk,
      'diabetes_risk_probability_class_0':
          instance.diabetes_risk_probability_class_0,
      'diabetes_risk_probability_class_1':
          instance.diabetes_risk_probability_class_1,
      'diabetes_risk_probability_class_2':
          instance.diabetes_risk_probability_class_2,
      'created_at': instance.created_at?.toIso8601String(),
    };
