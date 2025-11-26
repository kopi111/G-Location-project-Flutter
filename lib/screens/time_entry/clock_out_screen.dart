import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../blocs/time_entry/time_entry_bloc.dart';
import '../../blocs/time_entry/time_entry_event.dart';
import '../../blocs/time_entry/time_entry_state.dart';
import '../../services/gps/location_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/gps_status_indicator.dart';
import '../../widgets/info_card.dart';
import '../../widgets/break_management_card.dart';

class ClockOutScreen extends StatefulWidget {
  final Map<String, dynamic> activeClockIn;
  final int userId;

  const ClockOutScreen({
    super.key,
    required this.activeClockIn,
    required this.userId,
  });

  @override
  State<ClockOutScreen> createState() => _ClockOutScreenState();
}

class _ClockOutScreenState extends State<ClockOutScreen> {
  final LocationService _locationService = LocationService();

  Position? _currentPosition;
  bool _isLoadingLocation = false;
  String? _error;
  double? _gpsAccuracy;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _error = null;
    });

    try {
      final position = await _locationService.getCurrentPosition();

      setState(() {
        _currentPosition = position;
        _gpsAccuracy = position.accuracy;
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to get location: ${e.toString()}';
        _isLoadingLocation = false;
      });
    }
  }

  void _handleClockOut() {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for GPS location')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Clock Out'),
        content: const Text('Are you sure you want to clock out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<TimeEntryBloc>().add(ClockOutRequested(
                    userId: widget.userId,
                    latitude: _currentPosition!.latitude,
                    longitude: _currentPosition!.longitude,
                  ));
            },
            child: const Text('Clock Out'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(DateTime startTime) {
    final duration = DateTime.now().difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final clockInTime = DateTime.parse(widget.activeClockIn['clockInTime']);
    final locationName = widget.activeClockIn['locationName'] ?? 'Unknown Location';
    final hasGPSIssue = widget.activeClockIn['hasGPSIssue'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock Out'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: BlocConsumer<TimeEntryBloc, TimeEntryState>(
        listener: (context, state) {
          if (state is ClockOutSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Clock Out Success'),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    Text(
                      'Total Hours: ${state.totalHours.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
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
            return const LoadingIndicator(message: 'Clocking out...');
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

                // Active Clock-In Info
                InfoCard(
                  title: 'Current Shift',
                  icon: Icons.access_time,
                  children: [
                    _buildInfoRow('Location', locationName),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Clock In Time',
                      DateFormat('MMM dd, yyyy h:mm a').format(clockInTime),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Duration',
                      _formatDuration(clockInTime),
                    ),
                    if (hasGPSIssue) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange.shade700, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'This entry has GPS issues and requires review',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Break Management Card
                BreakManagementCard(activeClockIn: widget.activeClockIn, userId: widget.userId),
                const SizedBox(height: 24),

                // Clock Out Button
                CustomButton(
                  text: 'Clock Out',
                  onPressed: _currentPosition != null ? _handleClockOut : null,
                  icon: Icons.logout,
                  backgroundColor: Colors.red,
                  height: 56,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
