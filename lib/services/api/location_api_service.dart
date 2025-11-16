import '../../config/app_config.dart';
import '../../models/location_model.dart' as models;
import 'api_client.dart';

/// Location API Service - Integrates with GLocation API
class LocationApiService {
  final ApiClient _apiClient;

  LocationApiService(this._apiClient);

  /// Get all locations with optional filters
  Future<List<models.Location>> getLocations({
    String? searchTerm,
    String? locationType,
    bool? isActive,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      if (searchTerm != null) 'searchTerm': searchTerm,
      if (locationType != null) 'locationType': locationType,
      if (isActive != null) 'isActive': isActive,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };

    final response = await _apiClient.get(
      AppConfig.locationsEndpoint,
      queryParameters: queryParams,
    );

    if (response.data['success'] == true) {
      final data = response.data['data'];
      final locations = (data['locations'] as List)
          .map((json) => models.Location.fromJson(json as Map<String, dynamic>))
          .toList();
      return locations;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load locations',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get location by ID
  Future<models.Location> getLocationById(int id) async {
    final response = await _apiClient.get('${AppConfig.locationsEndpoint}/$id');

    if (response.data['success'] == true) {
      return models.Location.fromJson(response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Location not found',
        statusCode: response.statusCode ?? 404,
      );
    }
  }

  /// Find nearby locations based on GPS coordinates
  Future<List<models.NearbyLocation>> findNearbyLocations({
    required double latitude,
    required double longitude,
    double maxDistanceMeters = 1000,
  }) async {
    final response = await _apiClient.post(
      AppConfig.nearbyLocationsEndpoint,
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'maxDistanceMeters': maxDistanceMeters,
      },
    );

    if (response.data['success'] == true) {
      final locations = (response.data['data'] as List)
          .map((json) => models.NearbyLocation.fromJson(json as Map<String, dynamic>))
          .toList();
      return locations;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to find nearby locations',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Get locations by type
  Future<List<models.Location>> getLocationsByType(String locationType) async {
    final response = await _apiClient.get(
      '${AppConfig.locationsEndpoint}/type/$locationType',
    );

    if (response.data['success'] == true) {
      final locations = (response.data['data'] as List)
          .map((json) => models.Location.fromJson(json as Map<String, dynamic>))
          .toList();
      return locations;
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to load locations by type',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Create new location (Manager, Supervisor, SuperAdmin only)
  Future<models.Location> createLocation({
    required String locationName,
    required String locationType,
    required String address,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    required double latitude,
    required double longitude,
    int gpsRadius = 100,
    String? locationCode,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    Map<String, dynamic>? poolDetails,
  }) async {
    final response = await _apiClient.post(
      AppConfig.locationsEndpoint,
      data: {
        'locationName': locationName,
        'locationCode': locationCode,
        'locationType': locationType,
        'address': address,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'gpsRadius': gpsRadius,
        'contactName': contactName,
        'contactPhone': contactPhone,
        'contactEmail': contactEmail,
        ...?poolDetails,
      },
    );

    if (response.data['success'] == true) {
      return models.Location.fromJson(response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to create location',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Update location (Manager, Supervisor, SuperAdmin only)
  Future<models.Location> updateLocation({
    required int locationId,
    required Map<String, dynamic> updates,
  }) async {
    final response = await _apiClient.put(
      '${AppConfig.locationsEndpoint}/$locationId',
      data: {
        'locationId': locationId,
        ...updates,
      },
    );

    if (response.data['success'] == true) {
      return models.Location.fromJson(response.data['data'] as Map<String, dynamic>);
    } else {
      throw ApiException(
        response.data['message'] ?? 'Failed to update location',
        statusCode: response.statusCode ?? 400,
      );
    }
  }

  /// Activate location
  Future<bool> activateLocation(int locationId) async {
    final response = await _apiClient.patch(
      '${AppConfig.locationsEndpoint}/$locationId/activate',
    );

    return response.data['success'] == true;
  }

  /// Deactivate location
  Future<bool> deactivateLocation(int locationId) async {
    final response = await _apiClient.patch(
      '${AppConfig.locationsEndpoint}/$locationId/deactivate',
    );

    return response.data['success'] == true;
  }

  /// Get location statistics (Manager, Supervisor, SuperAdmin only)
  Future<Map<String, dynamic>> getLocationStatistics() async {
    final response = await _apiClient.get(
      '${AppConfig.locationsEndpoint}/statistics',
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
}
