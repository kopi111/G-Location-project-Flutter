import '../../models/admin_models.dart';
import '../../models/response_models.dart';
import 'api_client.dart';

/// Admin API Service
class AdminApiService {
  final ApiClient _apiClient;

  AdminApiService(this._apiClient);

  /// Get dashboard stats
  Future<DashboardStatsResponse> getDashboardStats() async {
    final response = await _apiClient.get('/api/admin/dashboard');

    if (response.data['success'] == true) {
      return DashboardStatsResponse.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load dashboard stats',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get all users
  Future<List<AdminUserResponse>> getAllUsers({String? role}) async {
    final response = await _apiClient.get(
      '/api/admin/users',
      queryParameters: role != null ? {'role': role} : null,
    );

    if (response.data['success'] == true) {
      final users = response.data['data'] as List;
      return users
          .map((user) =>
              AdminUserResponse.fromJson(user as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load users',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Create new user
  Future<AdminUserResponse> createUser(AdminCreateUserRequest request) async {
    final response = await _apiClient.post(
      '/api/admin/users',
      data: request.toJson(),
    );

    if (response.data['success'] == true) {
      return AdminUserResponse.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to create user',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Update user
  Future<AdminUserResponse> updateUser(
      int userId, AdminUpdateUserRequest request) async {
    final response = await _apiClient.put(
      '/api/admin/users/$userId',
      data: request.toJson(),
    );

    if (response.data['success'] == true) {
      return AdminUserResponse.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to update user',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get all attendance records
  Future<AttendanceReportResponse> getAllAttendance({
    DateTime? startDate,
    DateTime? endDate,
    int? userId,
    int? locationId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
    if (userId != null) queryParams['userId'] = userId;
    if (locationId != null) queryParams['locationId'] = locationId;

    final response = await _apiClient.get(
      '/api/admin/attendance',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data['success'] == true) {
      return AttendanceReportResponse.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load attendance records',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get all checklists
  Future<Map<String, dynamic>> getAllChecklists({
    DateTime? startDate,
    DateTime? endDate,
    int? userId,
    int? locationId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
    if (userId != null) queryParams['userId'] = userId;
    if (locationId != null) queryParams['locationId'] = locationId;

    final response = await _apiClient.get(
      '/api/admin/checklists',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data['success'] == true) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load checklists',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get all audits
  Future<Map<String, dynamic>> getAllAudits({
    DateTime? startDate,
    DateTime? endDate,
    int? userId,
    int? locationId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
    if (userId != null) queryParams['userId'] = userId;
    if (locationId != null) queryParams['locationId'] = locationId;

    final response = await _apiClient.get(
      '/api/admin/audits',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data['success'] == true) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load audits',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Send notification
  Future<BaseResponse> sendNotification(
      AdminNotificationRequest request) async {
    final response = await _apiClient.post(
      '/api/admin/notifications',
      data: request.toJson(),
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
