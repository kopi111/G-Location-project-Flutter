import '../../models/supply_request_model.dart';
import '../../models/response_models.dart';
import 'api_client.dart';

/// Supply Request API Service
class SupplyRequestApiService {
  final ApiClient _apiClient;

  SupplyRequestApiService(this._apiClient);

  /// Submit supply request
  Future<SupplyRequestResponse> submitRequest(
      SupplyRequestSubmit request) async {
    final response = await _apiClient.post(
      '/api/supply-request/submit',
      data: request.toJson(),
    );

    return SupplyRequestResponse.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// Get my supply requests
  Future<List<SupplyRequest>> getMyRequests() async {
    final response = await _apiClient.get('/api/supply-request/my-requests');

    if (response.data['success'] == true) {
      final requests = response.data['data'] as List;
      return requests
          .map((request) =>
              SupplyRequest.fromJson(request as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load supply requests',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get request by ID
  Future<SupplyRequest> getRequestById(int requestId) async {
    final response = await _apiClient.get('/api/supply-request/$requestId');

    if (response.data['success'] == true) {
      return SupplyRequest.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load supply request',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Update supply request status (for managers)
  Future<BaseResponse> updateStatus(int requestId, String status) async {
    final response = await _apiClient.put(
      '/api/supply-request/$requestId/status',
      data: {'status': status},
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Get all supply requests (for managers)
  Future<List<SupplyRequest>> getAllRequests({
    String? status,
    int? locationId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;
    if (locationId != null) queryParams['locationId'] = locationId;

    final response = await _apiClient.get(
      '/api/supply-request/all',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data['success'] == true) {
      final requests = response.data['data'] as List;
      return requests
          .map((request) =>
              SupplyRequest.fromJson(request as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load supply requests',
        statusCode: response.statusCode ?? 400,
      );
    }
  }
}
