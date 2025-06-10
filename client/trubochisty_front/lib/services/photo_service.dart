import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/location_result.dart';

class PhotoService {
  /// Checks if the current platform supports camera/photo operations
  bool get _isPlatformSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Adds a photo from camera with proper permissions handling
  /// Returns LocationResult<String> with the photo path or error
  Future<LocationResult<String>> capturePhoto() async {
    // Check platform support first
    if (!_isPlatformSupported) {
      return LocationResult.failure(
        'Камера недоступна на данной платформе. Используйте мобильное устройство.'
      );
    }

    try {
      // Check camera permission
      final cameraPermission = await _checkCameraPermission();
      if (cameraPermission.isFailure) {
        return LocationResult.failure(cameraPermission.error!);
      }

      // TODO: Implement actual camera capture using image_picker
      // For now, return a mock photo path
      final photoPath = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      return LocationResult.success(photoPath);
    } catch (e) {
      return LocationResult.failure('Ошибка захвата фото: ${e.toString()}');
    }
  }

  /// Picks a photo from gallery with proper permissions handling
  /// Returns LocationResult<String> with the photo path or error
  Future<LocationResult<String>> pickPhotoFromGallery() async {
    // Check platform support first
    if (!_isPlatformSupported) {
      return LocationResult.failure(
        'Галерея недоступна на данной платформе. Используйте мобильное устройство.'
      );
    }

    try {
      // Check gallery permission
      final galleryPermission = await _checkGalleryPermission();
      if (galleryPermission.isFailure) {
        return LocationResult.failure(galleryPermission.error!);
      }

      // TODO: Implement actual gallery picker using image_picker
      // For now, return a mock photo path
      final photoPath = 'gallery_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      return LocationResult.success(photoPath);
    } catch (e) {
      return LocationResult.failure('Ошибка выбора фото: ${e.toString()}');
    }
  }

  /// Deletes a photo file
  /// Returns LocationResult<void> indicating success or failure
  Future<LocationResult<void>> deletePhoto(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
      
      return LocationResult.success(null);
    } catch (e) {
      return LocationResult.failure('Ошибка удаления фото: ${e.toString()}');
    }
  }

  /// Validates if a photo file exists and is accessible
  Future<bool> validatePhoto(String photoPath) async {
    try {
      final file = File(photoPath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Gets the size of a photo file in bytes
  Future<LocationResult<int>> getPhotoSize(String photoPath) async {
    try {
      final file = File(photoPath);
      if (!await file.exists()) {
        return LocationResult.failure('Файл не найден');
      }
      
      final size = await file.length();
      return LocationResult.success(size);
    } catch (e) {
      return LocationResult.failure('Ошибка получения размера файла: ${e.toString()}');
    }
  }

  /// Private method to check camera permission
  Future<LocationResult<void>> _checkCameraPermission() async {
    if (!_isPlatformSupported) {
      return LocationResult.failure('Разрешения камеры недоступны на данной платформе');
    }

    try {
      var permission = await Permission.camera.status;

      if (permission.isDenied) {
        permission = await Permission.camera.request();
      }

      if (permission.isPermanentlyDenied) {
        return LocationResult.failure(
          'Доступ к камере навсегда заблокирован. Разрешите в настройках приложения.'
        );
      }

      if (permission.isDenied) {
        return LocationResult.failure('Доступ к камере отклонен');
      }

      return LocationResult.success(null);
    } catch (e) {
      return LocationResult.failure('Ошибка проверки разрешений камеры: ${e.toString()}');
    }
  }

  /// Private method to check gallery/photos permission
  Future<LocationResult<void>> _checkGalleryPermission() async {
    if (!_isPlatformSupported) {
      return LocationResult.failure('Разрешения галереи недоступны на данной платформе');
    }

    try {
      var permission = await Permission.photos.status;

      if (permission.isDenied) {
        permission = await Permission.photos.request();
      }

      if (permission.isPermanentlyDenied) {
        return LocationResult.failure(
          'Доступ к галерее навсегда заблокирован. Разрешите в настройках приложения.'
        );
      }

      if (permission.isDenied) {
        return LocationResult.failure('Доступ к галерее отклонен');
      }

      return LocationResult.success(null);
    } catch (e) {
      return LocationResult.failure('Ошибка проверки разрешений галереи: ${e.toString()}');
    }
  }

  /// Opens app settings for camera/photos permissions
  Future<void> openAppSettings() async {
    if (!_isPlatformSupported) return;
    
    try {
      await openAppSettings();
    } catch (e) {
      // Ignore errors on unsupported platforms
    }
  }
} 