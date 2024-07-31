import 'package:json_annotation/json_annotation.dart';

part 'physical_records.g.dart';

@JsonSerializable()
class PhysicalRecord {
  int duration;
  String type;
  int stress_level;
  DateTime created_at;
  String user; // Assuming user is referenced by an ID (String)

  PhysicalRecord({
    required this.duration,
    required this.type,
    required this.stress_level,
    required this.created_at,
    required this.user,
  });

  factory PhysicalRecord.fromJson(Map<String, dynamic> json) =>
      _$PhysicalRecordFromJson(json);
  Map<String, dynamic> toJson() => _$PhysicalRecordToJson(this);
}
