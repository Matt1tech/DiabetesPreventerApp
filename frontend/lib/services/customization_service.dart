import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../urls.dart';

class UserCustomizationService {
  static Future<void> setMaxDailyCalories(int userId, int maxCalories) async {
    final url = Uri.parse('$baseUrl/update-customization/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'daily_calories_max': maxCalories,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Max daily calories set successfully');
      } else {
        print(
            'Failed to submit daily calories max: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting  daily calories max data: $e');
    }
  }

  static Future<void> setMaxDailyCholesterol(
      int userId, int maxCholesterol) async {
    final url = Uri.parse('$baseUrl/update-customization/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'max_cholesterol': maxCholesterol,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Max daily cholesterol set successfully');
      } else {
        print(
            'Failed to submit daily cholesterol max: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting  daily cholesterol max data: $e');
    }
  }

  static Future<void> setMaxDailyFat(int userId, int maxFat) async {
    final url = Uri.parse('$baseUrl/update-customization/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'max_fat': maxFat,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Max daily fat set successfully');
      } else {
        print(
            'Failed to submit daily fat max: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting  daily fat max data: $e');
    }
  }

  static Future<void> setMaxDailyFiber(int userId, int maxFiber) async {
    final url = Uri.parse('$baseUrl/update-customization/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'max_fiber': maxFiber,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Max daily fiber set successfully');
      } else {
        print(
            'Failed to submit daily fiber max: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting  daily fiber max data: $e');
    }
  }

  static Future<void> setMaxDailyProtein(int userId, int maxProtein) async {
    final url = Uri.parse('$baseUrl/update-customization/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'max_protein': maxProtein,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Max daily protein set successfully');
      } else {
        print(
            'Failed to submit daily protein max: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting  daily protein max data: $e');
    }
  }

  static Future<void> setMealPerDay(int userId, List<String> meals) async {
    final url = Uri.parse('$baseUrl/update-customization/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'meals_per_day': meals,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Meals per day set successfully');
      } else {
        print(
            'Failed to submit meals per day: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting meals per day data: $e');
    }
  }

  static Future<void> allergies(int userId, List<String> allergies) async {
    final url = Uri.parse('$baseUrl/update-customization/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'allergies': allergies,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Allergies set successfully');
      } else {
        print(
            'Failed to submit allergies: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting allergies data: $e');
    }
  }

  static Future<void> dietsFollowed(int userId, List<String> diets) async {
    final url = Uri.parse('$baseUrl/update-customization/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'diets_followed': diets,
      'user': userId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Diets followed set successfully');
      } else {
        print(
            'Failed to submit diets followed: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error submitting diets followed data: $e');
    }
  }
}

class FetchUserCustomizationsService {
  Future<Customizations?> fetchUserCustomizations(int userId) async {
    print(
        'FetchUserCustomizationsService.fetchUserCustomizations called with userId: $userId');
    try {
      final url = Uri.parse('$baseUrl/get-user-customization/$userId');
      print('Requesting URL: $url');
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          final Map<String, dynamic> data = jsonList[0];
          print('Parsed JSON data: $data');
          try {
            return Customizations.fromJson(data);
          } catch (e) {
            print('Error creating Customizations object: $e');
            return null;
          }
        } else {
          print('Error: Empty response list');
          return null;
        }
      } else {
        print('Error fetching user customizations: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception in fetchUserCustomizations: $e');
      return null;
    }
  }
}
