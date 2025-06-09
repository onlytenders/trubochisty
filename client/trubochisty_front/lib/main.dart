import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/culvert_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/culvert_management_screen.dart';
import 'screens/auth_screen.dart';
import 'services/shortcuts_service.dart';
import 'widgets/settings/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CulvertProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'TruboСhisty',
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AuthWrapper(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        switch (authProvider.status) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            return const LoadingScreen();
          case AuthStatus.authenticated:
            return const MainAppWithShortcuts();
          case AuthStatus.unauthenticated:
            return const AuthScreen();
        }
      },
    );
  }
}

class MainAppWithShortcuts extends StatefulWidget {
  const MainAppWithShortcuts({super.key});

  @override
  State<MainAppWithShortcuts> createState() => _MainAppWithShortcutsState();
}

class _MainAppWithShortcutsState extends State<MainAppWithShortcuts> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ShortcutsService.isDesktop) {
      return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(ShortcutsService.modifierKeyboardKey, LogicalKeyboardKey.keyN): 
              CreateNewCulvertIntent(),
          LogicalKeySet(ShortcutsService.modifierKeyboardKey, LogicalKeyboardKey.keyF): 
              FocusSearchIntent(),
          LogicalKeySet(ShortcutsService.modifierKeyboardKey, LogicalKeyboardKey.keyT): 
              ToggleThemeIntent(),
          LogicalKeySet(ShortcutsService.modifierKeyboardKey, LogicalKeyboardKey.comma): 
              OpenSettingsIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): 
              CloseModalIntent(),
          LogicalKeySet(ShortcutsService.modifierKeyboardKey, LogicalKeyboardKey.keyQ): 
              LogoutIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            CreateNewCulvertIntent: CreateNewCulvertAction(),
            FocusSearchIntent: FocusSearchAction(),
            ToggleThemeIntent: ToggleThemeAction(),
            OpenSettingsIntent: OpenSettingsAction(),
            CloseModalIntent: CloseModalAction(),
            LogoutIntent: LogoutAction(),
          },
          child: Focus(
            focusNode: _focusNode,
            autofocus: true,
            child: const CulvertManagementScreen(),
          ),
        ),
      );
    } else {
      return const CulvertManagementScreen();
    }
  }
}

// Intent classes for keyboard shortcuts
class CreateNewCulvertIntent extends Intent {}
class FocusSearchIntent extends Intent {}
class ToggleThemeIntent extends Intent {}
class OpenSettingsIntent extends Intent {}
class CloseModalIntent extends Intent {}
class LogoutIntent extends Intent {}

// Action classes for keyboard shortcuts
class CreateNewCulvertAction extends Action<CreateNewCulvertIntent> {
  @override
  Object? invoke(CreateNewCulvertIntent intent) {
    final context = primaryFocus?.context;
    if (context != null) {
      context.read<CulvertProvider>().createNewCulvertWithSave();
    }
    return null;
  }
}

class FocusSearchAction extends Action<FocusSearchIntent> {
  @override
  Object? invoke(FocusSearchIntent intent) {
    // This will be handled by the CulvertManagementScreen
    return null;
  }
}

class ToggleThemeAction extends Action<ToggleThemeIntent> {
  @override
  Object? invoke(ToggleThemeIntent intent) {
    final context = primaryFocus?.context;
    if (context != null) {
      context.read<ThemeProvider>().toggleTheme();
    }
    return null;
  }
}

class OpenSettingsAction extends Action<OpenSettingsIntent> {
  @override
  Object? invoke(OpenSettingsIntent intent) {
    final context = primaryFocus?.context;
    if (context != null) {
      _showSettings(context);
    }
    return null;
  }
}

class CloseModalAction extends Action<CloseModalIntent> {
  @override
  Object? invoke(CloseModalIntent intent) {
    final context = primaryFocus?.context;
    if (context != null && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    return null;
  }
}

class LogoutAction extends Action<LogoutIntent> {
  @override
  Object? invoke(LogoutIntent intent) {
    final context = primaryFocus?.context;
    if (context != null) {
      context.read<AuthProvider>().signOut();
    }
    return null;
  }
}

void _showSettings(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  final isMobile = screenSize.width < 768;
  
  if (isMobile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(isFullScreen: true),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => const SettingsScreen(isFullScreen: false),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.1),
              colorScheme.secondaryContainer.withOpacity(0.1),
              colorScheme.tertiaryContainer.withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.water_rounded,
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'TruboСhisty',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
