import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/culvert.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  final AuthService _authService = AuthService();

  // Headers with auth token
  Future<Map<String, String>> _getHeaders() async {
    return await _authService.getHeaders();
  }

  // Get all culverts
  Future<List<Culvert>> getAllCulverts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/culverts'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Culvert.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load culverts');
    }
  }

  // Get culvert by ID
  Future<Culvert> getCulvertById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/culverts/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Culvert.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load culvert');
    }
  }

  // Create new culvert
  Future<Culvert> createCulvert(Culvert culvert) async {
    // Convert to the format backend expects (CulvertRequest)
    final requestData = {
      'address': culvert.address,
      'coordinates': culvert.coordinates,
      'road': culvert.road,
      'serialNumber': culvert.serialNumber,
      'pipeType': culvert.pipeType,
      'material': culvert.material,
      'diameter': culvert.diameter.toString(),
      'length': culvert.length.toString(),
      'headType': culvert.headType,
      'foundationType': culvert.foundationType,
      'workType': culvert.workType,
      'constructionYear': culvert.constructionYear.toString(),
      'lastRepairDate': culvert.lastRepairDate?.toIso8601String(),
      'lastInspectionDate': culvert.lastInspectionDate?.toIso8601String(),
      'strengthRating': culvert.strengthRating,
      'safetyRating': culvert.safetyRating,
      'maintainabilityRating': culvert.maintainabilityRating,
      'generalConditionRating': culvert.generalConditionRating,
      'defects': culvert.defects,
      'photos': culvert.photos,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/culverts'),
      headers: await _getHeaders(),
      body: json.encode(requestData),
    );

    if (response.statusCode == 200) {
      return Culvert.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create culvert: ${response.body}');
    }
  }

  // Update culvert
  Future<Culvert> updateCulvert(String id, Culvert culvert) async {
    // Convert to the format backend expects (CulvertRequest)
    final requestData = {
      'address': culvert.address,
      'coordinates': culvert.coordinates,
      'road': culvert.road,
      'serialNumber': culvert.serialNumber,
      'pipeType': culvert.pipeType,
      'material': culvert.material,
      'diameter': culvert.diameter.toString(),
      'length': culvert.length.toString(),
      'headType': culvert.headType,
      'foundationType': culvert.foundationType,
      'workType': culvert.workType,
      'constructionYear': culvert.constructionYear.toString(),
      'lastRepairDate': culvert.lastRepairDate?.toIso8601String(),
      'lastInspectionDate': culvert.lastInspectionDate?.toIso8601String(),
      'strengthRating': culvert.strengthRating,
      'safetyRating': culvert.safetyRating,
      'maintainabilityRating': culvert.maintainabilityRating,
      'generalConditionRating': culvert.generalConditionRating,
      'defects': culvert.defects,
      'photos': culvert.photos,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/culverts/$id'),
      headers: await _getHeaders(),
      body: json.encode(requestData),
    );

    if (response.statusCode == 200) {
      return Culvert.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update culvert: ${response.body}');
    }
  }

  // Delete culvert
  Future<void> deleteCulvert(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/culverts/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete culvert');
    }
  }

  // Search culverts
  Future<List<Culvert>> searchCulverts(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/culverts/search?query=$query'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Culvert.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search culverts');
    }
  }
} 