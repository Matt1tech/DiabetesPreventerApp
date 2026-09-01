import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../urls.dart';

class ApiClient {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<Map<String, String>> _headers(
      [Map<String, String>? headers]) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null || token.isEmpty) {
      throw StateError('Authentication is required.');
    }
    return {
      ...?headers,
      'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(Uri url,
      {Map<String, String>? headers}) async {
    var response = await http.get(url, headers: await _headers(headers));
    if (response.statusCode == 401 && await _refreshAccessToken()) {
      response = await http.get(url, headers: await _headers(headers));
    }
    return response;
  }

  static Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    var response =
        await http.post(url, headers: await _headers(headers), body: body);
    if (response.statusCode == 401 && await _refreshAccessToken()) {
      response =
          await http.post(url, headers: await _headers(headers), body: body);
    }
    return response;
  }

  static Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    var response =
        await http.put(url, headers: await _headers(headers), body: body);
    if (response.statusCode == 401 && await _refreshAccessToken()) {
      response =
          await http.put(url, headers: await _headers(headers), body: body);
    }
    return response;
  }

  static Future<http.MultipartRequest> multipart(String method, Uri url) async {
    final request = http.MultipartRequest(method, url);
    request.headers.addAll(await _headers());
    return request;
  }

  static Future<bool> _refreshAccessToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken == null || refreshToken.isEmpty) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );
    if (response.statusCode != 200) return false;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final accessToken = data['access'] as String?;
    if (accessToken == null || accessToken.isEmpty) return false;
    await _storage.write(key: 'access_token', value: accessToken);
    return true;
  }
}
