import '../../config/app_config.dart';
import '../../models/user_model.dart';
import 'api_client.dart';

/// User Service for profile and schedule management
class UserService {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  /// Get user profile by email
  Future<Map<String, dynamic>> getUserProfile(String email) async {
    final response = await _apiClient.get(
      '${AppConfig.userProfileEndpoint}/$email',
    );

    if (response.data['success'] == true) {
      return response.data['user'];
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to fetch user profile',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get user schedule
  Future<Map<String, dynamic>> getUserSchedule(
    int userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};

    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String();
    }

    if (endDate != null) {
      queryParams['endDate'] = endDate.toIso8601String();
    }

    final response = await _apiClient.get(
      '${AppConfig.userScheduleEndpoint}/$userId',
      queryParameters: queryParams,
    );

    if (response.data['success'] == true) {
      return {
        'hasSchedule': response.data['hasSchedule'] ?? false,
        'message': response.data['message'] ?? '',
        'schedules': response.data['schedules'] ?? [],
      };
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to fetch schedule',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Check user status (verification, approval, role)
  Future<Map<String, dynamic>> checkUserStatus(String email) async {
    final response = await _apiClient.get(
      '${AppConfig.userStatusEndpoint}/$email',
    );

    if (response.data['success'] == true) {
      return {
        'userId': response.data['userId'],
        'emailVerified': response.data['emailVerified'] ?? false,
        'isApproved': response.data['isApproved'] ?? false,
        'isActive': response.data['isActive'] ?? false,
        'hasRole': response.data['hasRole'] ?? false,
        'role': response.data['role'] ?? 'Not Assigned',
        'status': response.data['status'] ?? '',
      };
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to check user status',
        statusCode: response.statusCode ?? 400,
      );
    }
  }
}
