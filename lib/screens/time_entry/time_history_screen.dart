import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/time_entry/time_entry_bloc.dart';
import '../../blocs/time_entry/time_entry_event.dart';
import '../../blocs/time_entry/time_entry_state.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import 'time_entry_detail_screen.dart';

class TimeHistoryScreen extends StatefulWidget {
  const TimeHistoryScreen({super.key});

  @override
  State<TimeHistoryScreen> createState() => _TimeHistoryScreenState();
}

class _TimeHistoryScreenState extends State<TimeHistoryScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  int? _selectedLocationId;

  @override
  void initState() {
    super.initState();
    _loadTimeEntries();
  }

  void _loadTimeEntries() {
    context.read<TimeEntryBloc>().add(LoadTimeEntries(
          startDate: _startDate,
          endDate: _endDate,
          locationId: _selectedLocationId,
        ));
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadTimeEntries();
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedLocationId = null;
    });
    _loadTimeEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTimeEntries,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters Section
          _buildFiltersSection(),

          // Time Entries List
          Expanded(
            child: BlocBuilder<TimeEntryBloc, TimeEntryState>(
              builder: (context, state) {
                if (state is TimeEntryLoading) {
                  return const LoadingIndicator(message: 'Loading time entries...');
                }

                if (state is TimeEntryError) {
                  return ErrorState(
                    message: state.message,
                    onRetry: _loadTimeEntries,
                  );
                }

                if (state is TimeEntriesLoaded) {
                  if (state.timeEntries.isEmpty) {
                    return EmptyState(
                      icon: Icons.access_time,
                      title: 'No time entries found',
                      message: _hasActiveFilters()
                          ? 'Try adjusting your filters'
                          : 'You haven\'t clocked in yet',
                      actionLabel: _hasActiveFilters() ? 'Clear Filters' : null,
                      onAction: _hasActiveFilters() ? _clearFilters : null,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _loadTimeEntries(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.timeEntries.length,
                      itemBuilder: (context, index) {
                        final entry = state.timeEntries[index];
                        return _buildTimeEntryCard(entry);
                      },
                    ),
                  );
                }

                return const Center(child: Text('Pull down to load time entries'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    final hasFilters = _hasActiveFilters();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_list, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Filters',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (hasFilters)
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear, size: 18),
                  label: const Text('Clear'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _selectDateRange,
                  icon: const Icon(Icons.date_range, size: 20),
                  label: Text(
                    _startDate != null && _endDate != null
                        ? '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d').format(_endDate!)}'
                        : 'Select Date Range',
                    style: const TextStyle(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          if (hasFilters) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (_startDate != null && _endDate != null)
                  Chip(
                    label: Text(
                      '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d').format(_endDate!)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        _startDate = null;
                        _endDate = null;
                      });
                      _loadTimeEntries();
                    },
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeEntryCard(Map<String, dynamic> entry) {
    final clockInTime = DateTime.parse(entry['clockInTime']);
    final clockOutTime = entry['clockOutTime'] != null
        ? DateTime.parse(entry['clockOutTime'])
        : null;
    final locationName = entry['locationName'] ?? 'Unknown Location';
    final totalHours = entry['totalHours'] ?? 0.0;
    final hasGPSIssue = entry['hasGPSIssue'] ?? false;
    final requiresReview = entry['requiresReview'] ?? false;
    final isValidated = entry['isValidated'] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TimeEntryDetailScreen(
                timeEntry: entry,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      locationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (clockOutTime == null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Active',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Time Information
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Clock In',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, h:mm a').format(clockInTime),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Clock Out',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          clockOutTime != null
                              ? DateFormat('MMM dd, h:mm a').format(clockOutTime)
                              : 'In Progress',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: clockOutTime != null ? null : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Total Hours
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Hours',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      clockOutTime != null
                          ? '${totalHours.toStringAsFixed(2)} hrs'
                          : _calculateDuration(clockInTime),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Badges
              if (hasGPSIssue || requiresReview || isValidated) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (hasGPSIssue)
                      _buildStatusBadge(
                        'GPS Issue',
                        Colors.orange,
                        Icons.warning,
                      ),
                    if (requiresReview)
                      _buildStatusBadge(
                        'Requires Review',
                        Colors.red,
                        Icons.flag,
                      ),
                    if (isValidated)
                      _buildStatusBadge(
                        'Approved',
                        Colors.green,
                        Icons.check_circle,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
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
    return '${hours}h ${minutes}m';
  }

  bool _hasActiveFilters() {
    return _startDate != null || _endDate != null || _selectedLocationId != null;
  }
}
