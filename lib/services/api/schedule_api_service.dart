import '../../models/schedule_model.dart';
import '../../models/response_models.dart';
import 'api_client.dart';

/// Schedule API Service
class ScheduleApiService {
  final ApiClient _apiClient;

  ScheduleApiService(this._apiClient);

  /// Get my schedule
  Future<List<ScheduleResponse>> getMySchedule({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

    final response = await _apiClient.get(
      '/api/schedules/my-schedule',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data['success'] == true) {
      final schedules = response.data['data'] as List;
      return schedules
          .map((schedule) =>
              ScheduleResponse.fromJson(schedule as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load schedule',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get schedule for today
  Future<List<ScheduleResponse>> getTodaySchedule() async {
    final response = await _apiClient.get('/api/schedules/today');

    if (response.data['success'] == true) {
      final schedules = response.data['data'] as List;
      return schedules
          .map((schedule) =>
              ScheduleResponse.fromJson(schedule as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load today\'s schedule',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get schedule by location
  Future<List<UserSchedule>> getScheduleByLocation(int locationId) async {
    final response = await _apiClient.get('/api/schedules/location/$locationId');

    if (response.data['success'] == true) {
      final schedules = response.data['data'] as List;
      return schedules
          .map((schedule) =>
              UserSchedule.fromJson(schedule as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load location schedule',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Create schedule (for managers)
  Future<BaseResponse> createSchedule({
    required int userId,
    required int locationId,
    required DateTime scheduleDate,
    required String startTime,
    required String endTime,
  }) async {
    final response = await _apiClient.post(
      '/api/schedules',
      data: {
        'userId': userId,
        'locationId': locationId,
        'scheduleDate': scheduleDate.toIso8601String(),
        'startTime': startTime,
        'endTime': endTime,
      },
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Update schedule (for managers)
  Future<BaseResponse> updateSchedule({
    required int scheduleId,
    required DateTime scheduleDate,
    required String startTime,
    required String endTime,
  }) async {
    final response = await _apiClient.put(
      '/api/schedules/$scheduleId',
      data: {
        'scheduleDate': scheduleDate.toIso8601String(),
        'startTime': startTime,
        'endTime': endTime,
      },
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Delete schedule (for managers)
  Future<BaseResponse> deleteSchedule(int scheduleId) async {
    final response = await _apiClient.delete('/api/schedules/$scheduleId');

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
