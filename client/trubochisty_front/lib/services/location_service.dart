import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/location_result.dart';

class LocationService {
  static const Duration _locationTimeout = Duration(seconds: 10);

  /// Checks if the current platform supports location services
  bool get _isPlatformSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Gets the current GPS coordinates
  Future<LocationResult<String>> getCurrentCoordinates() async {
    // Check platform support first
    if (!_isPlatformSupported) {
      return LocationResult.failure(
        'GPS недоступен на данной платформе. Используйте мобильное устройство.'
      );
    }

    try {
      // Check and request permissions
      final permissionResult = await _checkLocationPermission();
      if (permissionResult.isFailure) {
        return LocationResult.failure(permissionResult.error!);
      }

      // Check if location services are enabled
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        return LocationResult.failure('Службы геолокации отключены. Включите GPS в настройках.');
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: _locationTimeout,
      );

      // Format coordinates
      final coordinates = '${position.latitude.toStringAsFixed(6)}° N, ${position.longitude.toStringAsFixed(6)}° E';
      
      return LocationResult.success(coordinates);
    } on LocationServiceDisabledException {
      return LocationResult.failure('Службы геолокации отключены');
    } on PermissionDeniedException {
      return LocationResult.failure('Нет разрешения на доступ к местоположению');
    } on TimeoutException {
      return LocationResult.failure('Время ожидания GPS истекло');
    } catch (e) {
      return LocationResult.failure('Ошибка получения координат: ${e.toString()}');
    }
  }

  /// Gets the current address based on GPS coordinates
  Future<LocationResult<String>> getCurrentAddress() async {
    // Check platform support first
    if (!_isPlatformSupported) {
      return LocationResult.failure(
        'Определение адреса недоступно на данной платформе. Используйте мобильное устройство.'
      );
    }

    try {
      // First get coordinates
      final coordinatesResult = await _getCurrentPosition();
      if (coordinatesResult.isFailure) {
        return LocationResult.failure(coordinatesResult.error!);
      }

      final position = coordinatesResult.data!;

      // Reverse geocoding to get address
      final placemarks = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return LocationResult.failure('Не удалось определить адрес по координатам');
      }

      // Format address from placemark
      final placemark = placemarks.first;
      final address = _formatAddress(placemark);
      
      return LocationResult.success(address);
    } on LocationServiceDisabledException {
      return LocationResult.failure('Службы геолокации отключены');
    } on PermissionDeniedException {
      return LocationResult.failure('Нет разрешения на доступ к местоположению');
    } on TimeoutException {
      return LocationResult.failure('Время ожидания GPS истекло');
    } catch (e) {
      return LocationResult.failure('Ошибка определения адреса: ${e.toString()}');
    }
  }

  /// Private method to get current position
  Future<LocationResult<Position>> _getCurrentPosition() async {
    if (!_isPlatformSupported) {
      return LocationResult.failure('GPS недоступен на данной платформе');
    }

    try {
      // Check and request permissions
      final permissionResult = await _checkLocationPermission();
      if (permissionResult.isFailure) {
        return LocationResult.failure(permissionResult.error!);
      }

      // Check if location services are enabled
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        return LocationResult.failure('Службы геолокации отключены');
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: _locationTimeout,
      );

      return LocationResult.success(position);
    } catch (e) {
      return LocationResult.failure(e.toString());
    }
  }

  /// Private method to check and request location permissions
  Future<LocationResult<void>> _checkLocationPermission() async {
    if (!_isPlatformSupported) {
      return LocationResult.failure('Разрешения недоступны на данной платформе');
    }

    try {
      var permission = await Permission.location.status;

      if (permission.isDenied) {
        permission = await Permission.location.request();
      }

      if (permission.isPermanentlyDenied) {
        return LocationResult.failure(
          'Доступ к местоположению навсегда заблокирован. Разрешите в настройках приложения.'
        );
      }

      if (permission.isDenied) {
        return LocationResult.failure('Доступ к местоположению отклонен');
      }

      return LocationResult.success(null);
    } catch (e) {
      return LocationResult.failure('Ошибка проверки разрешений: ${e.toString()}');
    }
  }

  /// Private method to format address from placemark
  String _formatAddress(Placemark placemark) {
    final components = <String>[];

    // Add street info
    if (placemark.street?.isNotEmpty == true) {
      components.add(placemark.street!);
    } else {
      // Fallback to thoroughfare if street is not available
      if (placemark.thoroughfare?.isNotEmpty == true) {
        components.add(placemark.thoroughfare!);
      }
    }

    // Add house number if available
    if (placemark.subThoroughfare?.isNotEmpty == true) {
      if (components.isNotEmpty) {
        components[components.length - 1] += ', ${placemark.subThoroughfare}';
      } else {
        components.add(placemark.subThoroughfare!);
      }
    }

    // Add locality (city/town)
    if (placemark.locality?.isNotEmpty == true) {
      components.add(placemark.locality!);
    }

    // If no specific address components, use administrative area
    if (components.isEmpty && placemark.administrativeArea?.isNotEmpty == true) {
      components.add(placemark.administrativeArea!);
    }

    // If still empty, use country
    if (components.isEmpty && placemark.country?.isNotEmpty == true) {
      components.add(placemark.country!);
    }

    return components.isNotEmpty ? components.join(', ') : 'Адрес не определен';
  }

  /// Checks if location services are available
  Future<bool> isLocationServiceAvailable() async {
    if (!_isPlatformSupported) return false;
    
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }

  /// Opens location settings
  Future<void> openLocationSettings() async {
    if (!_isPlatformSupported) return;
    
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      // Ignore errors on unsupported platforms
    }
  }

  /// Opens app settings for permissions
  Future<void> openAppSettings() async {
    if (!_isPlatformSupported) return;
    
    try {
      await Permission.location.request();
    } catch (e) {
      // Ignore errors on unsupported platforms
    }
  }
} 