import 'dart:io';
import 'package:flutter/foundation.dart';

/// Utility class for platform-specific information and capabilities
class PlatformInfo {
  /// Checks if the current platform supports GPS/location services
  static bool get supportsLocation {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Checks if the current platform supports camera/photo operations
  static bool get supportsCamera {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Gets the current platform name
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Checks if the current platform is mobile
  static bool get isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Checks if the current platform is desktop
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  /// Gets a user-friendly message about platform limitations
  static String get locationLimitationMessage {
    if (supportsLocation) return '';
    return 'GPS и определение местоположения доступны только на мобильных устройствах (Android/iOS)';
  }

  /// Gets a user-friendly message about camera limitations
  static String get cameraLimitationMessage {
    if (supportsCamera) return '';
    return 'Камера и галерея доступны только на мобильных устройствах (Android/iOS)';
  }
} 