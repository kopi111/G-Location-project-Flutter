import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/time_entry/time_entry_bloc.dart';
import '../blocs/time_entry/time_entry_event.dart';
import '../blocs/time_entry/time_entry_state.dart';
import 'custom_button.dart';

class BreakManagementCard extends StatelessWidget {
  final Map<String, dynamic> activeClockIn;
  final int userId;

  const BreakManagementCard({
    super.key,
    required this.activeClockIn,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final timeEntryId = activeClockIn['timeEntryId'];
    final breakStartTime = activeClockIn['breakStartTime'];
    final isOnBreak = breakStartTime != null;

    return BlocListener<TimeEntryBloc, TimeEntryState>(
      listener: (context, state) {
        if (state is BreakStartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is BreakEndSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is TimeEntryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.coffee,
                    color: isOnBreak ? Colors.orange : Colors.blue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Break Management',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (isOnBreak) ...[
                // Currently on break
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.pause_circle, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Currently on Break',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Started: ${DateFormat('h:mm a').format(DateTime.parse(breakStartTime))}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Duration: ${_calculateBreakDuration(DateTime.parse(breakStartTime))}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<TimeEntryBloc, TimeEntryState>(
                  builder: (context, state) {
                    final isLoading = state is TimeEntryLoading;
                    return CustomButton(
                      text: 'End Break',
                      onPressed: () => _handleEndBreak(context, timeEntryId),
                      isLoading: isLoading,
                      backgroundColor: Colors.green,
                      icon: Icons.play_circle,
                    );
                  },
                ),
              ] else ...[
                // Not on break
                Text(
                  'Take a break during your shift',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<TimeEntryBloc, TimeEntryState>(
                  builder: (context, state) {
                    final isLoading = state is TimeEntryLoading;
                    return CustomButton(
                      text: 'Start Break',
                      onPressed: () => _handleStartBreak(context, timeEntryId),
                      isLoading: isLoading,
                      isOutlined: true,
                      icon: Icons.coffee,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleStartBreak(BuildContext context, int timeEntryId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Start Break'),
        content: const Text('Are you sure you want to start your break?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<TimeEntryBloc>().add(StartBreakRequested(timeEntryId: timeEntryId, userId: userId));
            },
            child: const Text('Start Break'),
          ),
        ],
      ),
    );
  }

  void _handleEndBreak(BuildContext context, int timeEntryId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('End Break'),
        content: const Text('Are you sure you want to end your break?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<TimeEntryBloc>().add(EndBreakRequested(timeEntryId: timeEntryId, userId: userId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('End Break'),
          ),
        ],
      ),
    );
  }

  String _calculateBreakDuration(DateTime startTime) {
    final duration = DateTime.now().difference(startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
