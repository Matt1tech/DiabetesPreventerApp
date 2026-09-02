// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      marital_status: json['marital_status'] as String,
      height: (json['height'] as num).toDouble(),
      birthdate: json['birthdate'] as String,
      family_history: json['family_history'] as bool,
      profile_picture: json['profile_picture'] as String?,
      created_at: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'gender': instance.gender,
      'marital_status': instance.marital_status,
      'height': instance.height,
      'birthdate': instance.birthdate,
      'family_history': instance.family_history,
      'profile_picture': instance.profile_picture,
      'created_at': instance.created_at.toIso8601String(),
    };
