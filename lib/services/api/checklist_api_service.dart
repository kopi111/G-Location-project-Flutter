import '../../models/checklist_model.dart';
import '../../models/response_models.dart';
import 'api_client.dart';

/// Service Checklist API Service
class ChecklistApiService {
  final ApiClient _apiClient;

  ChecklistApiService(this._apiClient);

  /// Submit service checklist
  Future<BaseResponse> submitChecklist({
    required int locationId,
    required Map<String, dynamic> checklistData,
    required List<Map<String, dynamic>> chemicalReadings,
    String? notes,
  }) async {
    final response = await _apiClient.post(
      '/api/checklist/submit',
      data: {
        'locationId': locationId,
        'checklistData': checklistData,
        'chemicalReadings': chemicalReadings,
        'notes': notes,
      },
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Submit chemical reading
  Future<BaseResponse> submitChemicalReading({
    required int serviceChecklistId,
    required String bodyOfWater,
    double? chlorine,
    double? bromine,
    double? phLevel,
    int? calciumHardness,
    int? alkalinity,
    int? cyanuricAcid,
    int? saltLevel,
    int? phosphates,
  }) async {
    final response = await _apiClient.post(
      '/api/checklist/chemical-reading',
      data: {
        'serviceChecklistId': serviceChecklistId,
        'bodyOfWater': bodyOfWater,
        'chlorine': chlorine,
        'bromine': bromine,
        'phLevel': phLevel,
        'calciumHardness': calciumHardness,
        'alkalinity': alkalinity,
        'cyanuricAcid': cyanuricAcid,
        'saltLevel': saltLevel,
        'phosphates': phosphates,
      },
    );

    return BaseResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Upload checklist photos
  Future<BaseResponse> uploadPhotos({
    required int checklistId,
    required List<String> photoPaths,
    required List<String> photoTypes,
  }) async {
    try {
      // Multipart upload implementation would go here
      // For now, returning a placeholder
      throw UnimplementedError('Photo upload not yet implemented');
    } catch (e) {
      throw ApiException(
        'Failed to upload photos: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Get checklists for user
  Future<List<ServiceChecklist>> getMyChecklists({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

    final response = await _apiClient.get(
      '/api/checklist/my-checklists',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data['success'] == true) {
      final checklists = response.data['data'] as List;
      return checklists
          .map((checklist) =>
              ServiceChecklist.fromJson(checklist as Map<String, dynamic>))
          .toList();
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load checklists',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get checklist by ID
  Future<ServiceChecklist> getChecklistById(int checklistId) async {
    final response = await _apiClient.get('/api/checklist/$checklistId');

    if (response.data['success'] == true) {
      return ServiceChecklist.fromJson(
          response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load checklist',
        statusCode: response.statusCode ?? 400,
      );
    }
  }
}
