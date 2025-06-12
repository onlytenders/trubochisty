import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080/api/auth';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    final request = {
      'email': email,
      'password': password,
    };
    
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      final authResponse = json.decode(response.body);
      await _saveAuthData(authResponse);
      return authResponse;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // Register user
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final request = {
      'name': name,
      'email': email,
      'password': password,
    };
    
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      final authResponse = json.decode(response.body);
      await _saveAuthData(authResponse);
      return authResponse;
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Get stored user
  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(userKey);
    if (userData != null) {
      return json.decode(userData);
    }
    return null;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(userKey);
  }

  // Save auth data to storage
  Future<void> _saveAuthData(Map<String, dynamic> authResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, authResponse['token']);
    await prefs.setString(userKey, json.encode(authResponse['user']));
  }

  // Get headers with auth token
  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
} 