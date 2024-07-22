// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      number: (json['number'] as num).toInt(),
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      nutrients: json['nutrients'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'quantity': instance.quantity,
      'calories': instance.calories,
      'protein': instance.protein,
      'fats': instance.fats,
      'carbs': instance.carbs,
      'fiber': instance.fiber,
      'nutrients': instance.nutrients,
    };
