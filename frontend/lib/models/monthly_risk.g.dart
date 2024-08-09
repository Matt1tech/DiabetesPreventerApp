// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_risk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyRisk _$MonthlyRiskFromJson(Map<String, dynamic> json) => MonthlyRisk(
      month: json['month'] as String,
      risk: (json['risk'] as num).toDouble(),
    );

Map<String, dynamic> _$MonthlyRiskToJson(MonthlyRisk instance) =>
    <String, dynamic>{
      'month': instance.month,
      'risk': instance.risk,
    };
