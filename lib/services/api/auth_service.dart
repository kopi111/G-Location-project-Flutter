import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config.dart';
import '../../models/user_model.dart';
import 'api_client.dart';
import 'dart:convert';

/// Authentication Service
class AuthService {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;

  AuthService(this._apiClient, this._prefs);

  /// Login user
  Future<User> login(String email, String password) async {
    final response = await _apiClient.post(
      AppConfig.loginEndpoint,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.data['success'] == true) {
      final userData = response.data['data'];
      final user = User.fromJson(userData);

      // Save user data and tokens
      await _saveUserData(user);

      return user;
    } else {
      // Check if this is an email verification issue
      final message = response.data['message'] ?? '';
      if (message.toLowerCase().contains('verify your email')) {
        throw EmailNotVerifiedException(
          email: response.data['data']?['email'] ?? email,
          userId: response.data['data']?['userId'],
          message: message,
        );
      }

      throw ApiException(
        message.isNotEmpty ? message : 'Login failed',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Register new user
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String roleName,
  }) async {
    final response = await _apiClient.post(
      AppConfig.registerEndpoint,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password,
        'confirmPassword': confirmPassword,
        'roleName': roleName,
      },
    );

    if (response.data['success'] == true) {
      final userData = response.data['data'];
      // Note: User may need to verify email before login
      return User.fromJson(userData);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Registration failed',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Forgot password
  Future<bool> forgotPassword(String email) async {
    final response = await _apiClient.post(
      AppConfig.forgotPasswordEndpoint,
      data: {'email': email},
    );

    return response.data['success'] == true;
  }

  /// Reset password
  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    final response = await _apiClient.post(
      AppConfig.resetPasswordEndpoint,
      data: {
        'email': email,
        'token': token,
        'newPassword': newPassword,
        'confirmPassword': newPassword,
      },
    );

    return response.data['success'] == true;
  }

  /// Logout user
  Future<void> logout() async {
    final refreshToken = _prefs.getString(AppConfig.refreshTokenKey);
    if (refreshToken != null) {
      try {
        await _apiClient.post(
          AppConfig.logoutEndpoint,
          data: {'refreshToken': refreshToken},
        );
      } catch (e) {
        // Continue with logout even if API call fails
      }
    }

    // Clear local data
    await _clearUserData();
  }

  /// Get current user from local storage
  Future<User?> getCurrentUser() async {
    final userJson = _prefs.getString(AppConfig.userKey);
    if (userJson == null) return null;

    try {
      final userData = json.decode(userJson) as Map<String, dynamic>;
      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = _prefs.getString(AppConfig.tokenKey);
    final user = await getCurrentUser();
    return token != null && user != null;
  }

  /// Save user data to local storage
  Future<void> _saveUserData(User user) async {
    await _prefs.setString(AppConfig.tokenKey, user.token);
    await _prefs.setString(AppConfig.refreshTokenKey, user.refreshToken);
    await _prefs.setString(AppConfig.userKey, json.encode(user.toJson()));
  }

  /// Clear user data from local storage
  Future<void> _clearUserData() async {
    await _prefs.remove(AppConfig.tokenKey);
    await _prefs.remove(AppConfig.refreshTokenKey);
    await _prefs.remove(AppConfig.userKey);
  }

  /// Refresh token
  Future<bool> refreshToken() async {
    final refreshToken = _prefs.getString(AppConfig.refreshTokenKey);
    if (refreshToken == null) return false;

    try {
      final response = await _apiClient.post(
        AppConfig.refreshTokenEndpoint,
        data: {'refreshToken': refreshToken},
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        await _prefs.setString(AppConfig.tokenKey, data['token']);
        await _prefs.setString(AppConfig.refreshTokenKey, data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Send verification code to email
  Future<bool> sendVerificationCode(String email) async {
    final response = await _apiClient.post(
      AppConfig.sendVerificationCodeEndpoint,
      data: {'email': email},
    );

    if (response.data['success'] == true) {
      return true;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to send verification code',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Verify email with code
  Future<bool> verifyEmailCode(String email, String code) async {
    final response = await _apiClient.post(
      AppConfig.verifyCodeEndpoint,
      data: {
        'email': email,
        'code': code,
      },
    );

    if (response.data['success'] == true) {
      return true;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Invalid or expired verification code',
        statusCode: response.statusCode ?? 400,
      );
    }
  }
}
