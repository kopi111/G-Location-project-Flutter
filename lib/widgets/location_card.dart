import 'package:flutter/material.dart';

/// Card widget for displaying location information
class LocationCard extends StatelessWidget {
  final String locationName;
  final String address;
  final double? distance;
  final bool isWithinRadius;
  final VoidCallback? onTap;
  final bool isSelected;

  const LocationCard({
    super.key,
    required this.locationName,
    required this.address,
    this.distance,
    this.isWithinRadius = false,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: isWithinRadius ? Colors.green : Colors.orange,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          address,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                ],
              ),
              if (distance != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      isWithinRadius ? Icons.check_circle : Icons.warning,
                      size: 16,
                      color: isWithinRadius ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${distance!.toStringAsFixed(0)}m away',
                      style: TextStyle(
                        fontSize: 12,
                        color: isWithinRadius ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!isWithinRadius) ...[
                      const SizedBox(width: 8),
                      Text(
                        '(Outside radius)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
