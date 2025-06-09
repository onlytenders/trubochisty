import 'package:flutter/foundation.dart';
import '../models/user.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  // Mock users for demo
  final List<Map<String, String>> _mockUsers = [
    {
      'email': 'admin@trubochisty.ru',
      'password': 'admin123',
      'name': 'Александр Иванов',
      'role': 'admin',
    },
    {
      'email': 'engineer@trubochisty.ru',
      'password': 'engineer123',
      'name': 'Мария Петрова',
      'role': 'engineer',
    },
    {
      'email': 'viewer@trubochisty.ru',
      'password': 'viewer123',
      'name': 'Иван Сидоров',
      'role': 'viewer',
    },
  ];

  // Initialize auth state
  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    // Simulate checking stored auth
    await Future.delayed(const Duration(milliseconds: 500));

    // For demo purposes, start unauthenticated
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Check mock users
      final userMap = _mockUsers.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );

      if (userMap.isEmpty) {
        _errorMessage = 'Неверные учетные данные';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      // Create user object
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: userMap['email']!,
        name: userMap['name']!,
        role: userMap['role']!,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка входа: ${e.toString()}';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Check if user already exists
      final existingUser = _mockUsers.any((user) => user['email'] == email);
      if (existingUser) {
        _errorMessage = 'Пользователь с таким email уже существует';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }

      // Create new user
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        role: 'engineer', // Default role
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Add to mock users (in real app, this would be sent to backend)
      _mockUsers.add({
        'email': email,
        'password': password,
        'name': name,
        'role': 'engineer',
      });

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка регистрации: ${e.toString()}';
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _status = AuthStatus.loading;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _user = null;
    _errorMessage = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get demo credentials for testing
  List<Map<String, String>> get demoCredentials => _mockUsers;
} 