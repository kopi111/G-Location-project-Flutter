import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../blocs/time_entry/time_entry_bloc.dart';
import '../../blocs/time_entry/time_entry_event.dart';
import '../../blocs/time_entry/time_entry_state.dart';
import '../../services/gps/location_service.dart';
import '../../services/api/location_api_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/error_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/gps_status_indicator.dart';
import '../../widgets/location_card.dart';

class ClockInScreen extends StatefulWidget {
  final int userId;

  const ClockInScreen({super.key, required this.userId});

  @override
  State<ClockInScreen> createState() => _ClockInScreenState();
}

class _ClockInScreenState extends State<ClockInScreen> {
  final LocationService _locationService = LocationService();
  late final LocationApiService _locationApiService;

  Position? _currentPosition;
  List<dynamic> _nearbyLocations = [];
  int? _selectedLocationId;
  bool _isLoadingLocation = false;
  bool _isLoadingLocations = false;
  String? _error;
  double? _gpsAccuracy;

  @override
  void initState() {
    super.initState();
    _locationApiService = RepositoryProvider.of<LocationApiService>(context);
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _error = null;
    });

    try {
      // Check permissions
      LocationPermission permission = await _locationService.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await _locationService.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() {
            _error = 'Location permission denied. Please enable location services.';
            _isLoadingLocation = false;
          });
          return;
        }
      }

      // Get current position
      final position = await _locationService.getCurrentPosition();

      setState(() {
        _currentPosition = position;
        _gpsAccuracy = position.accuracy;
        _isLoadingLocation = false;
      });

      // Find nearby locations
      await _findNearbyLocations();
    } catch (e) {
      setState(() {
        _error = 'Failed to get location: ${e.toString()}';
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _findNearbyLocations() async {
    if (_currentPosition == null) return;

    setState(() {
      _isLoadingLocations = true;
      _error = null;
    });

    try {
      final nearbyLocationsList = await _locationApiService.findNearbyLocations(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        maxDistanceMeters: 500, // Search within 500m
      );

      setState(() {
        _nearbyLocations = nearbyLocationsList.map((loc) => loc.toJson()).toList();
        _isLoadingLocations = false;

        // Auto-select if only one location
        if (_nearbyLocations.length == 1) {
          _selectedLocationId = _nearbyLocations[0]['locationId'];
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to find nearby locations: ${e.toString()}';
        _isLoadingLocations = false;
      });
    }
  }

  void _handleClockIn() {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for GPS location')),
      );
      return;
    }

    if (_selectedLocationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location')),
      );
      return;
    }

    context.read<TimeEntryBloc>().add(ClockInRequested(
          userId: widget.userId,
          locationId: _selectedLocationId!,
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock In'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: BlocConsumer<TimeEntryBloc, TimeEntryState>(
        listener: (context, state) {
          if (state is ClockInSuccess) {
            // Show success message
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      state.hasGPSIssue ? Icons.warning : Icons.check_circle,
                      color: state.hasGPSIssue ? Colors.orange : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    const Text('Clock In Success'),
                  ],
                ),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to dashboard
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (state is TimeEntryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TimeEntryLoading) {
            return const LoadingIndicator(message: 'Clocking in...');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // GPS Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'GPS Status',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GpsStatusIndicator(
                              isGpsEnabled: _currentPosition != null,
                              accuracy: _gpsAccuracy,
                              isLoading: _isLoadingLocation,
                            ),
                          ],
                        ),
                        if (_currentPosition != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, '
                            'Lon: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Error Message
                if (_error != null)
                  Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Nearby Locations
                if (_isLoadingLocations)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: LoadingIndicator(message: 'Finding nearby locations...'),
                  )
                else if (_nearbyLocations.isEmpty && _currentPosition != null)
                  EmptyState(
                    icon: Icons.location_off,
                    title: 'No nearby locations found',
                    message: 'You must be within 500m of a location to clock in.',
                    actionLabel: 'Refresh',
                    onAction: _findNearbyLocations,
                  )
                else if (_nearbyLocations.isNotEmpty) ...[
                  const Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    _nearbyLocations.length,
                    (index) {
                      final location = _nearbyLocations[index];
                      final distance = location['distance']?.toDouble() ?? 0.0;
                      final geofenceRadius =
                          location['geofenceRadiusMeters']?.toDouble() ?? 100.0;
                      final isWithinRadius = distance <= geofenceRadius;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: LocationCard(
                          locationName: location['locationName'] ?? '',
                          address: location['address'] ?? '',
                          distance: distance,
                          isWithinRadius: isWithinRadius,
                          isSelected: _selectedLocationId == location['locationId'],
                          onTap: () {
                            setState(() {
                              _selectedLocationId = location['locationId'];
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Clock In',
                    onPressed: _selectedLocationId != null ? _handleClockIn : null,
                    icon: Icons.login,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
