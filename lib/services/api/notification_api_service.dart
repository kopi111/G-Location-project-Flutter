import '../../models/notification_model.dart';
import '../../models/response_models.dart';
import 'api_client.dart';

/// Notification API Service
class NotificationApiService {
  final ApiClient _apiClient;

  NotificationApiService(this._apiClient);

  /// Get my notifications
  Future<List<NotificationResponse>> getMyNotifications() async {
    final response = await _apiClient.get('/api/notifications/my-notifications');

    if (response.data['success'] == true) {
      final notifications = response.data['data'] as List;
      return notifications
          .map((notification) => NotificationResponse.fromJson(
              notification as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load notifications',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Mark notification as read
  Future<BaseResponse> markAsRead(int notificationId) async {
    final response = await _apiClient.put(
      '/api/notifications/$notificationId/read',
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Mark all notifications as read
  Future<BaseResponse> markAllAsRead() async {
    final response = await _apiClient.put(
      '/api/notifications/mark-all-read',
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get('/api/notifications/unread-count');

    if (response.data['success'] == true) {
      return response.data['data']['count'] as int? ?? 0;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load unread count',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Delete notification
  Future<BaseResponse> deleteNotification(int notificationId) async {
    final response = await _apiClient.delete(
      '/api/notifications/$notificationId',
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
