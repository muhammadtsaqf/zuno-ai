import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../config/app_config.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    loadUserFromPrefs();
  }

  String _getAuthEndpoint(String path) {
    String base = ApiService.vercelUrl.isNotEmpty
        ? ApiService.vercelUrl
        : AppConfig.defaultVercelBackendUrl;
    if (!base.endsWith('/')) {
      base = '$base/';
    }
    return '${base}api/$path';
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userRaw = prefs.getString('auth_user');
    if (userRaw != null) {
      try {
        final decoded = jsonDecode(userRaw);
        _user = UserModel(
          id: decoded['id'],
          username: decoded['username'] ?? '',
          name: decoded['name'],
          email: decoded['email'],
          token: decoded['token'],
        );
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading user from prefs: $e');
      }
    }
  }

  Future<bool> register({
    required String username,
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse(_getAuthEndpoint('register'));
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username.trim(),
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
        }),
      ).timeout(const Duration(seconds: 25));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _user = UserModel.fromJson(data['user'], data['token']);
        await _saveUserToPrefs();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['error'] ?? 'Registrasi gagal.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Gagal terhubung ke server auth. Periksa koneksi internet.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse(_getAuthEndpoint('login'));
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier.trim(),
          'password': password,
        }),
      ).timeout(const Duration(seconds: 25));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _user = UserModel.fromJson(data['user'], data['token']);
        await _saveUserToPrefs();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['error'] ?? 'Login gagal.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Gagal terhubung ke server auth. Periksa koneksi internet.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_user');
    notifyListeners();
  }

  Future<void> _saveUserToPrefs() async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_user', jsonEncode(_user!.toJson()));
  }
}
