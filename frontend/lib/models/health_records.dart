import 'package:json_annotation/json_annotation.dart';

part 'health_records.g.dart';

@JsonSerializable()
class HealthRecord {
  double? blood_glucose;
  String? blood_pressure;
  double? bmi;
  double? weight;
  double? diabetes_risk;
  DateTime? created_at;

  HealthRecord({
    this.blood_glucose,
    this.blood_pressure,
    this.bmi,
    this.weight,
    this.diabetes_risk,
    this.created_at,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      blood_glucose: json['blood_glucose']?.toDouble(),
      blood_pressure: json['blood_pressure']?.toString(),
      bmi: json['bmi']?.toDouble(),
      weight: json['weight']?.toDouble(),
      diabetes_risk: json['diabetes_risk']?.toDouble(),
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blood_glucose': blood_glucose,
      'blood_pressure': blood_pressure,
      'bmi': bmi,
      'weight': weight,
      'diabetes_risk': diabetes_risk,
      'created_at': created_at?.toIso8601String(),
    };
  }
}
