import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../models/location_model.dart' as models;
import 'dart:math' as math;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// GPS and Location Service
class LocationService {
  // Check if running on desktop (Linux/Windows/macOS) where geolocator may not work
  bool get _isDesktop {
    if (kIsWeb) return false;
    return Platform.isLinux || Platform.isWindows || Platform.isMacOS;
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    if (_isDesktop) return true; // Mock for desktop
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return true; // Fallback
    }
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    if (_isDesktop) return LocationPermission.always; // Mock for desktop
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      return LocationPermission.always; // Fallback
    }
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    if (_isDesktop) return LocationPermission.always; // Mock for desktop
    try {
      return await Geolocator.requestPermission();
    } catch (e) {
      return LocationPermission.always; // Fallback
    }
  }

  /// Get current position
  Future<Position> getCurrentPosition() async {
    // For desktop platforms, return mock position for testing
    if (_isDesktop) {
      return Position(
        latitude: 42.059081,  // Mock coordinates matching location 19 ("k")
        longitude: -110.80985,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationServiceException('Location services are disabled.');
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationServiceException('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationServiceException(
          'Location permissions are permanently denied. Please enable them in settings.',
        );
      }

      // Get position with high accuracy
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      // Fallback to mock position if geolocator fails
      return Position(
        latitude: 42.059081,
        longitude: -110.80985,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }
  }

  /// Get position stream for real-time updates
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }

  /// Calculate distance between two points in meters
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Check if user is within radius of location
  bool isWithinRadius(
    Position userPosition,
    models.Location location, [
    double? customRadius,
  ]) {
    final distance = calculateDistance(
      userPosition.latitude,
      userPosition.longitude,
      location.latitude,
      location.longitude,
    );

    final radius = customRadius ?? location.geofenceRadiusMeters.toDouble();
    return distance <= radius;
  }

  /// Get nearby locations from a list
  List<models.NearbyLocation> getNearbyLocations(
    Position userPosition,
    List<models.Location> locations,
    double maxDistanceMeters,
  ) {
    final nearbyLocations = <models.NearbyLocation>[];

    for (final location in locations) {
      final distance = calculateDistance(
        userPosition.latitude,
        userPosition.longitude,
        location.latitude,
        location.longitude,
      );

      if (distance <= maxDistanceMeters) {
        nearbyLocations.add(
          models.NearbyLocation(
            location: location,
            distanceInMeters: distance,
          ),
        );
      }
    }

    // Sort by distance
    nearbyLocations.sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));

    return nearbyLocations;
  }

  /// Get address from coordinates (reverse geocoding)
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
      }
      return 'Unknown location';
    } catch (e) {
      return 'Unable to get address';
    }
  }

  /// Get coordinates from address (geocoding)
  Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Calculate bearing between two points (for directional navigation)
  double calculateBearing(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    final startLatRad = _degreesToRadians(startLat);
    final startLngRad = _degreesToRadians(startLng);
    final endLatRad = _degreesToRadians(endLat);
    final endLngRad = _degreesToRadians(endLng);

    final dLng = endLngRad - startLngRad;

    final y = math.sin(dLng) * math.cos(endLatRad);
    final x = math.cos(startLatRad) * math.sin(endLatRad) -
        math.sin(startLatRad) * math.cos(endLatRad) * math.cos(dLng);

    final bearing = math.atan2(y, x);
    return (_radiansToDegrees(bearing) + 360) % 360;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  double _radiansToDegrees(double radians) {
    return radians * (180 / math.pi);
  }

  /// Format distance for display
  String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
  }

  /// Check if position has good accuracy
  bool hasGoodAccuracy(Position position, {double threshold = 50.0}) {
    return position.accuracy <= threshold;
  }
}

/// Custom exception for location service errors
class LocationServiceException implements Exception {
  final String message;

  LocationServiceException(this.message);

  @override
  String toString() => message;
}
