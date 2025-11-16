import '../../config/app_config.dart';
import '../../models/time_entry_model.dart';
import 'api_client.dart';

/// Time Entry API Service - Clock in/out management
class TimeEntryService {
  final ApiClient _apiClient;

  TimeEntryService(this._apiClient);

  /// Clock in at a location with GPS validation
  Future<TimeEntry> clockIn({
    required int locationId,
    required double latitude,
    required double longitude,
    String? deviceInfo,
    String? notes,
  }) async {
    final response = await _apiClient.post(
      AppConfig.clockInEndpoint,
      data: {
        'locationId': locationId,
        'latitude': latitude,
        'longitude': longitude,
        'deviceInfo': deviceInfo,
        'notes': notes,
      },
    );

    if (response.data['success'] == true) {
      return TimeEntry.fromJson(response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Clock in failed',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Clock out from current active shift
  Future<TimeEntry> clockOut({
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    final response = await _apiClient.post(
      AppConfig.clockOutEndpoint,
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'notes': notes,
      },
    );

    if (response.data['success'] == true) {
      return TimeEntry.fromJson(response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Clock out failed',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get active clock-in for current user
  Future<TimeEntry?> getActiveClockIn() async {
    try {
      final response = await _apiClient.get(AppConfig.activeClockInEndpoint);

      if (response.data['success'] == true) {
        return TimeEntry.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      return null;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null; // No active clock-in
      }
      rethrow;
    }
  }

  /// Get time entry by ID
  Future<TimeEntry> getTimeEntryById(int id) async {
    final response = await _apiClient.get(
      '${AppConfig.timeEntriesEndpoint}/$id',
    );

    if (response.data['success'] == true) {
      return TimeEntry.fromJson(response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Time entry not found',
        statusCode: response.statusCode ?? 404,
      );
    }
  }

  /// Get time entries with filters and pagination
  Future<List<TimeEntry>> getTimeEntries({
    int? userId,
    int? locationId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    bool? requiresReview,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      if (userId != null) 'userId': userId,
      if (locationId != null) 'locationId': locationId,
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
      if (status != null) 'status': status,
      if (requiresReview != null) 'requiresReview': requiresReview,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    final response = await _apiClient.get(
      AppConfig.timeEntriesEndpoint,
      queryParameters: queryParams,
    );

    if (response.data['success'] == true) {
      final data = response.data['data'];
      final timeEntries = (data['timeEntries'] as List)
          .map((json) => TimeEntry.fromJson(json as Map<String, dynamic>))
          .toList();
      return timeEntries;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load time entries',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get employee hours summary for a date range
  Future<Map<String, dynamic>> getEmployeeHoursSummary({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _apiClient.get(
      '${AppConfig.timeEntriesEndpoint}/hours-summary/$userId',
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );

    if (response.data['success'] == true) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to get hours summary',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get all active clock-ins (Manager/Supervisor only)
  Future<List<TimeEntry>> getAllActiveClockIns() async {
    final response = await _apiClient.get(
      '${AppConfig.timeEntriesEndpoint}/active/all',
    );

    if (response.data['success'] == true) {
      final entries = (response.data['data'] as List)
          .map((json) => TimeEntry.fromJson(json as Map<String, dynamic>))
          .toList();
      return entries;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to get active clock-ins',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Start break during active shift
  Future<bool> startBreak(int timeEntryId) async {
    final response = await _apiClient.post(
      '${AppConfig.timeEntriesEndpoint}/$timeEntryId/start-break',
    );

    return response.data['success'] == true;
  }

  /// End break during active shift
  Future<bool> endBreak(int timeEntryId) async {
    final response = await _apiClient.post(
      '${AppConfig.timeEntriesEndpoint}/$timeEntryId/end-break',
    );

    return response.data['success'] == true;
  }

  /// Update time entry (Manager/Supervisor only)
  Future<TimeEntry> updateTimeEntry({
    required int timeEntryId,
    required Map<String, dynamic> updates,
  }) async {
    final response = await _apiClient.put(
      '${AppConfig.timeEntriesEndpoint}/$timeEntryId',
      data: {
        'timeEntryId': timeEntryId,
        ...updates,
      },
    );

    if (response.data['success'] == true) {
      return TimeEntry.fromJson(response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to update time entry',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Validate/Approve time entry (Manager/Supervisor only)
  Future<bool> validateTimeEntry({
    required int timeEntryId,
    required bool isApproved,
    String? validationNotes,
  }) async {
    final response = await _apiClient.post(
      '${AppConfig.timeEntriesEndpoint}/$timeEntryId/validate',
      data: {
        'timeEntryId': timeEntryId,
        'isApproved': isApproved,
        'validationNotes': validationNotes,
      },
    );

    return response.data['success'] == true;
  }

  /// Get entries requiring review (Manager/Supervisor only)
  Future<List<TimeEntry>> getEntriesRequiringReview({int? locationId}) async {
    final queryParams = <String, dynamic>{
      if (locationId != null) 'locationId': locationId,
    };

    final response = await _apiClient.get(
      '${AppConfig.timeEntriesEndpoint}/requiring-review',
      queryParameters: queryParams,
    );

    if (response.data['success'] == true) {
      final entries = (response.data['data'] as List)
          .map((json) => TimeEntry.fromJson(json as Map<String, dynamic>))
          .toList();
      return entries;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to get entries requiring review',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get time entry statistics (Manager/Supervisor only)
  Future<Map<String, dynamic>> getTimeEntryStatistics({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _apiClient.get(
      '${AppConfig.timeEntriesEndpoint}/statistics',
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );

    if (response.data['success'] == true) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to get statistics',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Delete time entry (SuperAdmin only)
  Future<bool> deleteTimeEntry(int timeEntryId) async {
    final response = await _apiClient.delete(
      '${AppConfig.timeEntriesEndpoint}/$timeEntryId',
    );

    return response.data['success'] == true;
  }
}
