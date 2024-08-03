class Customizations {
  final int id;
  final List<String> mealsPerDay;
  final List<String> allergies;
  final List<String> dietsFollowed;
  final int dailyCaloriesMax;
  final int maxProtein;
  final int maxFiber;
  final int maxFat;
  final int maxCholesterol;
  final int maxCarbs; // New field for max carbs
  final DateTime createdAt;
  final int user;

  Customizations({
    required this.id,
    required this.mealsPerDay,
    required this.allergies,
    required this.dietsFollowed,
    required this.dailyCaloriesMax,
    required this.maxProtein,
    required this.maxFiber,
    required this.maxFat,
    required this.maxCholesterol,
    required this.maxCarbs, // Initialize the new field
    required this.createdAt,
    required this.user,
  });

  factory Customizations.fromJson(Map<String, dynamic> json) {
    return Customizations(
      id: json['id'] as int,
      mealsPerDay: List<String>.from(json['meals_per_day'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      dietsFollowed: List<String>.from(json['diets_followed'] ?? []),
      dailyCaloriesMax: json['daily_calories_max'] as int,
      maxProtein: json['max_protein'] as int,
      maxFiber: json['max_fiber'] as int,
      maxFat: json['max_fat'] as int,
      maxCholesterol: json['max_cholesterol'] as int,
      maxCarbs: json['max_carbs'] as int, // Parse the new field
      createdAt: DateTime.parse(json['created_at'] as String),
      user: json['user'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meals_per_day': mealsPerDay,
      'allergies': allergies,
      'diets_followed': dietsFollowed,
      'daily_calories_max': dailyCaloriesMax,
      'max_protein': maxProtein,
      'max_fiber': maxFiber,
      'max_fat': maxFat,
      'max_cholesterol': maxCholesterol,
      'max_carbs': maxCarbs,
      'created_at': createdAt.toIso8601String(),
      'user': user,
    };
  }
}
