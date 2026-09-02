import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String name;
  String email;
  String gender;
  String marital_status;
  double height;
  String birthdate;
  bool family_history;
  String? profile_picture;
  DateTime created_at;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.marital_status,
    required this.height,
    required this.birthdate,
    required this.family_history,
    required this.profile_picture,
    required this.created_at,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      marital_status: json['marital_status'],
      height: (json['height'] as num).toDouble(),
      birthdate: json['birthdate'],
      family_history: json['family_history'],
      profile_picture: json['profile_picture'] as String?,
      created_at: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'marital_status': marital_status,
      'height': height,
      'birthdate': birthdate,
      'family_history': family_history,
      'profile_picture': profile_picture,
      'created_at': created_at.toIso8601String(),
    };
  }
}
