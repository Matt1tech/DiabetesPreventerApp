import 'package:json_annotation/json_annotation.dart';

part 'monthly_risk.g.dart';

@JsonSerializable()
class MonthlyRisk {
  final String month;
  final double risk;

  MonthlyRisk({required this.month, required this.risk});

  factory MonthlyRisk.fromJson(Map<String, dynamic> json) =>
      _$MonthlyRiskFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyRiskToJson(this);
}
