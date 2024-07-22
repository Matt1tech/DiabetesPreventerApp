import 'package:json_annotation/json_annotation.dart';
import 'physical_activity.dart';

part 'physical_record.g.dart';

@JsonSerializable()
class PhysicalRecord {
  PhysicalActivity physical_activity;
  int stress_level;
  DateTime time;
  DateTime created_at;

  PhysicalRecord({
    required this.physical_activity,
    required this.stress_level,
    required this.time,
    required this.created_at,
  });

  factory PhysicalRecord.fromJson(Map<String, dynamic> json) =>
      _$PhysicalRecordFromJson(json);
  Map<String, dynamic> toJson() => _$PhysicalRecordToJson(this);
}
