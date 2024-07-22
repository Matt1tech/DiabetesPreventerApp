import 'package:json_annotation/json_annotation.dart';

part 'health_record.g.dart';

@JsonSerializable()
class HealthRecord {
  double blood_glucose;
  String blood_pressure;
  double bmi;
  double weight;
  double diabetes_risk;
  DateTime created_at;

  HealthRecord({
    required this.blood_glucose,
    required this.blood_pressure,
    required this.bmi,
    required this.weight,
    required this.diabetes_risk,
    required this.created_at,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) =>
      _$HealthRecordFromJson(json);
  Map<String, dynamic> toJson() => _$HealthRecordToJson(this);
}
