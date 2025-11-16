import 'package:equatable/equatable.dart';

/// Location model representing pool/job sites
class Location extends Equatable {
  final int locationId;
  final String locationName;
  final String? locationCode;
  final String locationType;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final double latitude;
  final double longitude;
  final int gpsRadius; // in meters
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;
  final int? poolCapacity;
  final double? poolDepthMin;
  final double? poolDepthMax;
  final bool hasMainPool;
  final bool hasWadingPool;
  final bool hasSpa;
  final bool hasDivingBoard;
  final bool hasSlide;
  final bool isActive;
  final bool isSeasonal;
  final int? seasonStartMonth;
  final int? seasonEndMonth;
  final String? notes;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Location({
    required this.locationId,
    required this.locationName,
    this.locationCode,
    required this.locationType,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.gpsRadius,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.poolCapacity,
    this.poolDepthMin,
    this.poolDepthMax,
    this.hasMainPool = false,
    this.hasWadingPool = false,
    this.hasSpa = false,
    this.hasDivingBoard = false,
    this.hasSlide = false,
    required this.isActive,
    this.isSeasonal = false,
    this.seasonStartMonth,
    this.seasonEndMonth,
    this.notes,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullAddress => '$address, $city, $state $zipCode, $country';

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['locationId'] as int,
      locationName: json['locationName'] as String,
      locationCode: json['locationCode'] as String?,
      locationType: json['locationType'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      gpsRadius: json['gpsRadius'] as int? ?? 100,
      contactName: json['contactName'] as String?,
      contactPhone: json['contactPhone'] as String?,
      contactEmail: json['contactEmail'] as String?,
      poolCapacity: json['poolCapacity'] as int?,
      poolDepthMin: json['poolDepthMin'] != null
          ? (json['poolDepthMin'] as num).toDouble()
          : null,
      poolDepthMax: json['poolDepthMax'] != null
          ? (json['poolDepthMax'] as num).toDouble()
          : null,
      hasMainPool: json['hasMainPool'] as bool? ?? false,
      hasWadingPool: json['hasWadingPool'] as bool? ?? false,
      hasSpa: json['hasSpa'] as bool? ?? false,
      hasDivingBoard: json['hasDivingBoard'] as bool? ?? false,
      hasSlide: json['hasSlide'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      isSeasonal: json['isSeasonal'] as bool? ?? false,
      seasonStartMonth: json['seasonStartMonth'] as int?,
      seasonEndMonth: json['seasonEndMonth'] as int?,
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationId': locationId,
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
      'poolCapacity': poolCapacity,
      'poolDepthMin': poolDepthMin,
      'poolDepthMax': poolDepthMax,
      'hasMainPool': hasMainPool,
      'hasWadingPool': hasWadingPool,
      'hasSpa': hasSpa,
      'hasDivingBoard': hasDivingBoard,
      'hasSlide': hasSlide,
      'isActive': isActive,
      'isSeasonal': isSeasonal,
      'seasonStartMonth': seasonStartMonth,
      'seasonEndMonth': seasonEndMonth,
      'notes': notes,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        locationId,
        locationName,
        locationCode,
        locationType,
        address,
        city,
        state,
        zipCode,
        country,
        latitude,
        longitude,
        gpsRadius,
        contactName,
        contactPhone,
        contactEmail,
        poolCapacity,
        poolDepthMin,
        poolDepthMax,
        hasMainPool,
        hasWadingPool,
        hasSpa,
        hasDivingBoard,
        hasSlide,
        isActive,
        isSeasonal,
        seasonStartMonth,
        seasonEndMonth,
        notes,
        imageUrl,
        createdAt,
        updatedAt,
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

  bool get isWithinRange => distanceInMeters <= location.gpsRadius;

  factory NearbyLocation.fromJson(Map<String, dynamic> json) {
    return NearbyLocation(
      location: Location(
        locationId: json['locationId'] as int,
        locationName: json['locationName'] as String,
        locationCode: json['locationCode'] as String?,
        locationType: 'Pool',
        address: json['address'] as String,
        city: '',
        state: '',
        zipCode: '',
        country: '',
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        gpsRadius: json['gpsRadius'] as int? ?? 100,
        isActive: json['isActive'] as bool? ?? true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      distanceInMeters: (json['distanceInMeters'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [location, distanceInMeters];
}
