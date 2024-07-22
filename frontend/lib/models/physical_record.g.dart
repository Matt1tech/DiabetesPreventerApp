// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhysicalRecord _$PhysicalRecordFromJson(Map<String, dynamic> json) =>
    PhysicalRecord(
      physical_activity: PhysicalActivity.fromJson(
          json['physical_activity'] as Map<String, dynamic>),
      stress_level: (json['stress_level'] as num).toInt(),
      time: DateTime.parse(json['time'] as String),
      created_at: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PhysicalRecordToJson(PhysicalRecord instance) =>
    <String, dynamic>{
      'physical_activity': instance.physical_activity,
      'stress_level': instance.stress_level,
      'time': instance.time.toIso8601String(),
      'created_at': instance.created_at.toIso8601String(),
    };
