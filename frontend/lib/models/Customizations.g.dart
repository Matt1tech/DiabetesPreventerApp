// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Customizations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customizations _$CustomizationsFromJson(Map<String, dynamic> json) =>
    Customizations(
      mealsPerDay: (json['mealsPerDay'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allergies:
          (json['allergies'] as List<dynamic>).map((e) => e as String).toList(),
      dietsFollowed: (json['dietsFollowed'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      dailyCaloriesMax: (json['dailyCaloriesMax'] as num).toInt(),
      maxProtein: (json['maxProtein'] as num).toInt(),
      maxFiber: (json['maxFiber'] as num).toInt(),
      maxFat: (json['maxFat'] as num).toInt(),
      maxCholesterol: (json['maxCholesterol'] as num).toInt(),
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CustomizationsToJson(Customizations instance) =>
    <String, dynamic>{
      'mealsPerDay': instance.mealsPerDay,
      'allergies': instance.allergies,
      'dietsFollowed': instance.dietsFollowed,
      'dailyCaloriesMax': instance.dailyCaloriesMax,
      'maxProtein': instance.maxProtein,
      'maxFiber': instance.maxFiber,
      'maxFat': instance.maxFat,
      'maxCholesterol': instance.maxCholesterol,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
