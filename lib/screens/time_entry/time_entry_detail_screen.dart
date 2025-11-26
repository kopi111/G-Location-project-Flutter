import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/info_card.dart';

class TimeEntryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> timeEntry;

  const TimeEntryDetailScreen({
    super.key,
    required this.timeEntry,
  });

  @override
  Widget build(BuildContext context) {
    final clockInTime = DateTime.parse(timeEntry['clockInTime']);
    final clockOutTime = timeEntry['clockOutTime'] != null
        ? DateTime.parse(timeEntry['clockOutTime'])
        : null;
    final locationName = timeEntry['locationName'] ?? 'Unknown Location';
    final totalHours = timeEntry['totalHours'] ?? 0.0;
    final breakMinutes = timeEntry['breakMinutes'] ?? 0;
    final hasGPSIssue = timeEntry['hasGPSIssue'] ?? false;
    final requiresReview = timeEntry['requiresReview'] ?? false;
    final isValidated = timeEntry['isValidated'] ?? false;
    final validationNotes = timeEntry['validationNotes'];

    // GPS Coordinates
    final clockInLat = timeEntry['clockInLatitude'];
    final clockInLon = timeEntry['clockInLongitude'];
    final clockOutLat = timeEntry['clockOutLatitude'];
    final clockOutLon = timeEntry['clockOutLongitude'];

    // IP Addresses
    final clockInIp = timeEntry['clockInIpAddress'];
    final clockOutIp = timeEntry['clockOutIpAddress'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Entry Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Location Card
            InfoCard(
              title: locationName,
              icon: Icons.location_on,
              iconColor: Theme.of(context).primaryColor,
              children: [
                _buildInfoRow('Entry ID', '#${timeEntry['timeEntryId']}'),
                if (clockOutTime == null)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Currently Active',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Time Information Card
            InfoCard(
              title: 'Time Information',
              icon: Icons.schedule,
              iconColor: Colors.blue,
              children: [
                _buildInfoRow(
                  'Clock In',
                  DateFormat('MMM dd, yyyy h:mm a').format(clockInTime),
                ),
                const Divider(),
                _buildInfoRow(
                  'Clock Out',
                  clockOutTime != null
                      ? DateFormat('MMM dd, yyyy h:mm a').format(clockOutTime)
                      : 'In Progress',
                  valueColor: clockOutTime != null ? null : Colors.orange,
                ),
                const Divider(),
                _buildInfoRow(
                  'Total Hours',
                  clockOutTime != null
                      ? '${totalHours.toStringAsFixed(2)} hours'
                      : _calculateDuration(clockInTime),
                  valueColor: Theme.of(context).primaryColor,
                ),
                if (breakMinutes > 0) ...[
                  const Divider(),
                  _buildInfoRow(
                    'Break Time',
                    '${breakMinutes} minutes',
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // GPS Information Card
            if (clockInLat != null && clockInLon != null)
              InfoCard(
                title: 'GPS Information',
                icon: Icons.gps_fixed,
                iconColor: hasGPSIssue ? Colors.orange : Colors.green,
                children: [
                  if (hasGPSIssue)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This entry has GPS issues and may require review',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    'Clock In Location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    'Latitude',
                    clockInLat.toStringAsFixed(6),
                  ),
                  _buildInfoRow(
                    'Longitude',
                    clockInLon.toStringAsFixed(6),
                  ),
                  if (clockOutLat != null && clockOutLon != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Clock Out Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      'Latitude',
                      clockOutLat.toStringAsFixed(6),
                    ),
                    _buildInfoRow(
                      'Longitude',
                      clockOutLon.toStringAsFixed(6),
                    ),
                  ],
                ],
              ),
            const SizedBox(height: 16),

            // Validation Status Card
            if (requiresReview || isValidated)
              InfoCard(
                title: 'Validation Status',
                icon: isValidated ? Icons.check_circle : Icons.flag,
                iconColor: isValidated ? Colors.green : Colors.red,
                children: [
                  _buildInfoRow(
                    'Status',
                    isValidated ? 'Approved' : 'Requires Review',
                    valueColor: isValidated ? Colors.green : Colors.red,
                  ),
                  if (validationNotes != null) ...[
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Notes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      validationNotes,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ],
              ),

            // Technical Details (Collapsible)
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text(
                'Technical Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.info_outline),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (clockInIp != null)
                        _buildInfoRow('Clock In IP', clockInIp),
                      if (clockOutIp != null) ...[
                        const Divider(),
                        _buildInfoRow('Clock Out IP', clockOutIp),
                      ],
                      const Divider(),
                      _buildInfoRow('User ID', '${timeEntry['userId']}'),
                      const Divider(),
                      _buildInfoRow('Location ID', '${timeEntry['locationId']}'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: valueColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateDuration(DateTime startTime) {
    final duration = DateTime.now().difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m (In Progress)';
  }
}
