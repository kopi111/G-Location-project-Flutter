import 'package:equatable/equatable.dart';

/// Location model representing pool/job sites
class Location extends Equatable {
  final int locationId;
  final String locationName;
  final String address;
  final double latitude;
  final double longitude;
  final int geofenceRadiusMeters;
  final int? managerId;
  final String? managerName;
  final bool isActive;
  final DateTime createdAt;

  const Location({
    required this.locationId,
    required this.locationName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.geofenceRadiusMeters,
    this.managerId,
    this.managerName,
    required this.isActive,
    required this.createdAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['id'] as int,
      locationName: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      geofenceRadiusMeters: json['geofenceRadiusMeters'] as int? ?? 100,
      managerId: json['managerId'] as int?,
      managerName: json['managerName'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': locationId,
      'name': locationName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'geofenceRadiusMeters': geofenceRadiusMeters,
      'managerId': managerId,
      'managerName': managerName,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        locationId,
        locationName,
        address,
        latitude,
        longitude,
        geofenceRadiusMeters,
        managerId,
        managerName,
        isActive,
        createdAt,
      ];
}

/// Nearby location with distance information
class NearbyLocation extends Equatable {
  final Location location;
  final double distanceInMeters;

  const NearbyLocation({
    required this.location,
    required this.distanceInMeters,
  });

  bool get isWithinRange => distanceInMeters <= location.geofenceRadiusMeters;

  factory NearbyLocation.fromJson(Map<String, dynamic> json) {
    return NearbyLocation(
      location: Location(
        locationId: json['id'] as int,
        locationName: json['name'] as String,
        address: json['address'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        geofenceRadiusMeters: json['geofenceRadiusMeters'] as int? ?? 100,
        isActive: json['isActive'] as bool? ?? true,
        createdAt: DateTime.now(),
      ),
      distanceInMeters: (json['distanceInMeters'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationId': location.locationId,
      'locationName': location.locationName,
      'address': location.address,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'geofenceRadiusMeters': location.geofenceRadiusMeters,
      'isActive': location.isActive,
      'distanceInMeters': distanceInMeters,
      'isWithinRange': isWithinRange,
    };
  }

  @override
  List<Object?> get props => [location, distanceInMeters];
}
