import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  User? _user;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;
  
  bool get isAdmin => _user?.role.toLowerCase() == 'admin';

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      _isAuthenticated = await _authService.isLoggedIn();
      if (_isAuthenticated) {
        final userData = await _authService.getUser();
        if (userData != null) {
          _user = _convertMapToUser(userData);
        }
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      _isAuthenticated = true;
      _user = _convertMapToUser(response['user']);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(name, email, password);
      _isAuthenticated = true;
      _user = _convertMapToUser(response['user']);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _user = null;
    _error = null;
    notifyListeners();
  }

  // Added signOut method for backward compatibility
  Future<void> signOut() async {
    await logout();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Convert Map<String, dynamic> to User object
  User _convertMapToUser(Map<String, dynamic> userData) {
    return User(
      id: userData['id'] ?? '',
      email: userData['email'] ?? '',
      name: userData['name'] ?? '',
      avatarUrl: userData['avatarUrl'],
      role: userData['role']?.toString().toLowerCase() ?? 'engineer',
      createdAt: userData['createdAt'] != null 
          ? DateTime.tryParse(userData['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      lastLoginAt: userData['lastLoginAt'] != null 
          ? DateTime.tryParse(userData['lastLoginAt'])
          : null,
    );
  }
} 