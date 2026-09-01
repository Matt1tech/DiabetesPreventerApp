// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physical_records.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhysicalRecord _$PhysicalRecordFromJson(Map<String, dynamic> json) =>
    PhysicalRecord(
      duration: (json['duration'] as num).toInt(),
      type: json['type'] as String,
      stress_level: (json['stress_level'] as num).toInt(),
      created_at: DateTime.parse(json['created_at'] as String),
      user: json['user'] as String,
    );

Map<String, dynamic> _$PhysicalRecordToJson(PhysicalRecord instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'type': instance.type,
      'stress_level': instance.stress_level,
      'created_at': instance.created_at.toIso8601String(),
      'user': instance.user,
    };
