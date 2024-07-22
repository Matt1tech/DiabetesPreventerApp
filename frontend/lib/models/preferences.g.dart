// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) => Preferences(
      meals_per_day: (json['meals_per_day'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allergies:
          (json['allergies'] as List<dynamic>).map((e) => e as String).toList(),
      diets_followed: (json['diets_followed'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      daily_calories_min: (json['daily_calories_min'] as num).toInt(),
      daily_calories_max: (json['daily_calories_max'] as num).toInt(),
    );

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'meals_per_day': instance.meals_per_day,
      'allergies': instance.allergies,
      'diets_followed': instance.diets_followed,
      'daily_calories_min': instance.daily_calories_min,
      'daily_calories_max': instance.daily_calories_max,
    };
