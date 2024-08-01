// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      cholesterol: (json['cholesterol'] as num).toDouble(),
      user: (json['user'] as num).toInt(),
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'calories': instance.calories,
      'protein': instance.protein,
      'fats': instance.fats,
      'carbs': instance.carbs,
      'fiber': instance.fiber,
      'cholesterol': instance.cholesterol,
      'user': instance.user,
    };
