import '../../models/training_model.dart';
import '../../models/response_models.dart';
import 'api_client.dart';

/// Training API Service
class TrainingApiService {
  final ApiClient _apiClient;

  TrainingApiService(this._apiClient);

  /// Get all training topics
  Future<List<TrainingTopicResponse>> getTrainingTopics() async {
    final response = await _apiClient.get('/api/training/topics');

    if (response.data['success'] == true) {
      final topics = response.data['data'] as List;
      return topics
          .map((topic) =>
              TrainingTopicResponse.fromJson(topic as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load training topics',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get my training progress
  Future<List<TrainingProgressResponse>> getMyProgress() async {
    final response = await _apiClient.get('/api/training/my-progress');

    if (response.data['success'] == true) {
      final progress = response.data['data'] as List;
      return progress
          .map((item) => TrainingProgressResponse.fromJson(
              item as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load training progress',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Complete training
  Future<BaseResponse> completeTraining(
      CompleteTrainingRequest request) async {
    final response = await _apiClient.post(
      '/api/training/complete',
      data: request.toJson(),
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Get training topic details
  Future<TrainingTopicResponse> getTopicDetails(int topicId) async {
    final response = await _apiClient.get('/api/training/topics/$topicId');

    if (response.data['success'] == true) {
      return TrainingTopicResponse.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load topic details',
        statusCode: response.statusCode ?? 400,
      );
    }
  }
}
