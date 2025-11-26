import 'package:flutter/material.dart';

/// GPS status indicator widget
class GpsStatusIndicator extends StatelessWidget {
  final bool isGpsEnabled;
  final double? accuracy;
  final bool isLoading;

  const GpsStatusIndicator({
    super.key,
    required this.isGpsEnabled,
    this.accuracy,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (isLoading) {
      statusColor = Colors.orange;
      statusIcon = Icons.gps_not_fixed;
      statusText = 'Getting location...';
    } else if (!isGpsEnabled) {
      statusColor = Colors.red;
      statusIcon = Icons.gps_off;
      statusText = 'GPS disabled';
    } else if (accuracy != null && accuracy! <= 50) {
      statusColor = Colors.green;
      statusIcon = Icons.gps_fixed;
      statusText = 'GPS accurate (${accuracy!.toStringAsFixed(0)}m)';
    } else if (accuracy != null) {
      statusColor = Colors.orange;
      statusIcon = Icons.gps_not_fixed;
      statusText = 'Low GPS accuracy (${accuracy!.toStringAsFixed(0)}m)';
    } else {
      statusColor = Colors.grey;
      statusIcon = Icons.gps_not_fixed;
      statusText = 'GPS status unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
