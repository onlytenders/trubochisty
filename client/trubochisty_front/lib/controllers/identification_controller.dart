import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../models/location_result.dart';

/// Controller for handling identification section business logic
/// Separates business logic from UI components following clean architecture
class IdentificationController {
  final LocationService _locationService;
  
  // Loading states
  bool _isLoadingAddress = false;
  bool _isLoadingCoordinates = false;
  
  // Getters for loading states
  bool get isLoadingAddress => _isLoadingAddress;
  bool get isLoadingCoordinates => _isLoadingCoordinates;

  IdentificationController({
    LocationService? locationService,
  }) : _locationService = locationService ?? LocationService();

  /// Gets GPS coordinates and updates the controller
  Future<LocationResult<String>> getGPSCoordinates() async {
    _isLoadingCoordinates = true;
    
    try {
      final result = await _locationService.getCurrentCoordinates();
      return result;
    } finally {
      _isLoadingCoordinates = false;
    }
  }

  /// Gets GPS address and updates the controller  
  Future<LocationResult<String>> getGPSAddress() async {
    _isLoadingAddress = true;
    
    try {
      final result = await _locationService.getCurrentAddress();
      return result;
    } finally {
      _isLoadingAddress = false;
    }
  }

  /// Checks if location services are available
  Future<bool> isLocationServiceAvailable() async {
    return await _locationService.isLocationServiceAvailable();
  }

  /// Opens location settings
  Future<void> openLocationSettings() async {
    await _locationService.openLocationSettings();
  }

  /// Opens app settings for permissions
  Future<void> openAppSettings() async {
    await _locationService.openAppSettings();
  }
} 