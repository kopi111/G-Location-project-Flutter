import '../../models/safety_audit_model.dart';
import '../../models/response_models.dart';
import 'api_client.dart';

/// Safety Audit API Service
class SafetyAuditApiService {
  final ApiClient _apiClient;

  SafetyAuditApiService(this._apiClient);

  /// Submit safety audit
  Future<BaseResponse> submitAudit({
    required int locationId,
    required String auditType,
    required Map<String, dynamic> auditData,
    String? safetyConcerns,
    String? safetySuppliesNeeded,
  }) async {
    final response = await _apiClient.post(
      '/api/safety-audit/submit',
      data: {
        'locationId': locationId,
        'auditType': auditType,
        'auditData': auditData,
        'safetyConcerns': safetyConcerns,
        'safetySuppliesNeeded': safetySuppliesNeeded,
      },
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Get my audits
  Future<List<SafetyAudit>> getMyAudits({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

    final response = await _apiClient.get(
      '/api/safety-audit/my-audits',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data['success'] == true) {
      final audits = response.data['data'] as List;
      return audits
          .map((audit) =>
              SafetyAudit.fromJson(audit as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load audits',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get audit by ID
  Future<SafetyAudit> getAuditById(int auditId) async {
    final response = await _apiClient.get('/api/safety-audit/$auditId');

    if (response.data['success'] == true) {
      return SafetyAudit.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load audit',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get audit types
  Future<List<String>> getAuditTypes() async {
    final response = await _apiClient.get('/api/safety-audit/types');

    if (response.data['success'] == true) {
      final types = response.data['data'] as List;
      return types.cast<String>();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load audit types',
        statusCode: response.statusCode ?? 400,
      );
    }
  }
}
