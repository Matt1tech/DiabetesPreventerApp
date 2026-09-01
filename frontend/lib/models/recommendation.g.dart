// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    Recommendation(
      name: json['name'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      cholesterol: (json['cholesterol'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      lowFat: json['lowFat'] as bool,
      lowCarb: json['lowCarb'] as bool,
      highProtein: json['highProtein'] as bool,
      noSugar: json['noSugar'] as bool,
      wheatFree: json['wheatFree'] as bool,
      eggFree: json['eggFree'] as bool,
      soyFree: json['soyFree'] as bool,
      imageUrl: json['imageUrl'] as String,
      recipe: json['recipe'] as String,
      total_calories: (json['total_calories'] as num).toDouble(),
    );

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
      'type': instance.type,
      'protein': instance.protein,
      'fat': instance.fat,
      'fiber': instance.fiber,
      'cholesterol': instance.cholesterol,
      'carbs': instance.carbs,
      'lowFat': instance.lowFat,
      'lowCarb': instance.lowCarb,
      'highProtein': instance.highProtein,
      'noSugar': instance.noSugar,
      'wheatFree': instance.wheatFree,
      'eggFree': instance.eggFree,
      'soyFree': instance.soyFree,
      'imageUrl': instance.imageUrl,
      'recipe': instance.recipe,
      'total_calories': instance.total_calories,
    };
