import '../../models/offline_queue_model.dart';
import '../../models/response_models.dart';
import 'api_client.dart';

/// Offline Sync API Service
class OfflineSyncApiService {
  final ApiClient _apiClient;

  OfflineSyncApiService(this._apiClient);

  /// Queue offline action
  Future<BaseResponse> queueAction(OfflineActionRequest request) async {
    final response = await _apiClient.post(
      '/api/offline/queue',
      data: request.toJson(),
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Sync offline actions
  Future<SyncResultResponse> syncOfflineActions() async {
    final response = await _apiClient.post('/api/offline/sync');

    return SyncResultResponse.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// Get sync status
  Future<SyncStatusResponse> getSyncStatus() async {
    final response = await _apiClient.get('/api/offline/status');

    if (response.data['success'] == true) {
      return SyncStatusResponse.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load sync status',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get pending actions
  Future<List<OfflineQueue>> getPendingActions() async {
    final response = await _apiClient.get('/api/offline/pending');

    if (response.data['success'] == true) {
      final actions = response.data['data'] as List;
      return actions
          .map((action) =>
              OfflineQueue.fromJson(action as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load pending actions',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Clear synced actions
  Future<BaseResponse> clearSyncedActions() async {
    final response = await _apiClient.delete('/api/offline/clear-synced');

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Retry failed sync
  Future<SyncResultResponse> retryFailedSync() async {
    final response = await _apiClient.post('/api/offline/retry-failed');

    return SyncResultResponse.fromJson(
        response.data as Map<String, dynamic>);
  }
}
