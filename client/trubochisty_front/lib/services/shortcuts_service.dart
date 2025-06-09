import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ShortcutsService {
  static bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  // Platform-specific modifier key names for display
  static String get modifierKey => isMacOS ? 'Cmd' : 'Ctrl';
  static String get modifierKey2 => isMacOS ? 'Alt' : 'Option';

  // Platform-specific LogicalKeyboardKey for actual shortcuts
  static LogicalKeyboardKey get modifierKeyboardKey => 
      isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control;

  // Desktop keyboard shortcuts (simple and intuitive!)
  static Map<String, String> get keyboardShortcuts => {
    '${modifierKey}+N': 'Создать новую трубу',
    '${modifierKey}+F': 'Фокус на поиске', 
    '${modifierKey}+T': 'Переключить тему',
    '${modifierKey}+,': 'Открыть настройки',
    'Escape': 'Закрыть модальное окно',
    '${modifierKey}+Q': 'Выйти из аккаунта',
  };

  // Mobile gestures
  static Map<String, String> get mobileGestures => {
    'Свайп вправо': 'Открыть боковое меню',
    'Свайп влево': 'Закрыть боковое меню', 
    'Свайп вниз': 'Обновить данные',
    'Двойное нажатие': 'Переключить тему',
  };

  static Map<String, String> getAvailableShortcuts() {
    if (isDesktop) {  // Only desktop, not web!
      return keyboardShortcuts;
    } else if (isMobile) {
      return mobileGestures;
    } else {
      return {}; // No shortcuts for web
    }
  }

  static String getShortcutType() {
    if (isDesktop) {  // Only desktop, not web!
      return 'Горячие клавиши';
    } else if (isMobile) {
      return 'Жесты';
    } else {
      return 'Навигация'; // Web just uses mouse/touch
    }
  }

  static bool get hasShortcuts => isDesktop || isMobile;
} 