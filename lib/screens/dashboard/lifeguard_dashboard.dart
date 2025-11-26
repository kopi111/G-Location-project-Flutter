import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../../config/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/time_entry/time_entry_bloc.dart';
import '../../blocs/time_entry/time_entry_event.dart';
import '../../blocs/time_entry/time_entry_state.dart';
import '../../screens/time_entry/clock_in_screen.dart';
import '../../screens/time_entry/clock_out_screen.dart';
import '../../screens/time_entry/time_history_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../widgets/loading_indicator.dart';
import '../../services/api/user_service.dart';
import '../../services/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lifeguard Dashboard
class LifeguardDashboard extends StatefulWidget {
  final User user;

  const LifeguardDashboard({
    super.key,
    required this.user,
  });

  @override
  State<LifeguardDashboard> createState() => _LifeguardDashboardState();
}

class _LifeguardDashboardState extends State<LifeguardDashboard> {
  late UserService _userService;
  Map<String, dynamic>? _userStatus;
  Map<String, dynamic>? _scheduleData;
  bool _isLoadingStatus = true;
  bool _isLoadingSchedule = true;

  @override
  void initState() {
    super.initState();
    _initializeUserService();
    // Load active clock-in and hours summary on init
    context.read<TimeEntryBloc>().add(LoadActiveClockIn(userId: widget.user.userId));
    _loadHoursSummary();
  }

  Future<void> _initializeUserService() async {
    final prefs = await SharedPreferences.getInstance();
    final apiClient = ApiClient(prefs);
    _userService = UserService(apiClient);
    _loadUserStatus();
    // Schedule is now loaded after user status to get correct userId
  }

  void _loadHoursSummary() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    context.read<TimeEntryBloc>().add(LoadHoursSummary(
          userId: widget.user.id,
          startDate: startOfWeek,
          endDate: now,
        ));
  }

  Future<void> _loadUserStatus() async {
    try {
      final status = await _userService.checkUserStatus(widget.user.email);
      if (mounted) {
        setState(() {
          _userStatus = status;
          _isLoadingStatus = false;
        });
        // Load schedule with actual userId from server
        _loadSchedule(status['userId'] ?? widget.user.userId);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
        });
        // Fallback to cached userId
        _loadSchedule(widget.user.userId);
      }
    }
  }

  Future<void> _loadSchedule(int userId) async {
    try {
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 30)); // Show 1 month of schedule
      final schedule = await _userService.getUserSchedule(
        userId,
        startDate: now,
        endDate: endDate,
      );
      if (mounted) {
        setState(() {
          _scheduleData = schedule;
          _isLoadingSchedule = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSchedule = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TimeEntryBloc>().add(LoadActiveClockIn(userId: widget.user.userId));
              _loadHoursSummary();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<TimeEntryBloc>().add(LoadActiveClockIn(userId: widget.user.userId));
          _loadHoursSummary();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Card
              Card(
                color: AppTheme.primaryBlue,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.user.fullName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.work_outline,
                            color: Colors.white70,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          _isLoadingStatus
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                                  ),
                                )
                              : Text(
                                  _userStatus?['role'] ?? widget.user.role.displayName,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white70,
                                      ),
                                ),
                        ],
                      ),
                      if (_userStatus != null && _userStatus!['hasRole'] == false)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.info_outline, color: Colors.orange, size: 16),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Role not yet assigned by admin',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Clock In/Out Card
              _buildClockInCard(context),
              const SizedBox(height: 16),

              // Today's Schedule Card
              _buildScheduleCard(context),
              const SizedBox(height: 16),

              // Hours This Week Card
              _buildHoursCard(context),
              const SizedBox(height: 16),

              // Quick Actions Card
              _buildQuickActionsCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.dashboard,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TimeHistoryScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history, size: 20),
                    label: const Text('Time History'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person, size: 20),
                    label: const Text('Profile'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClockInCard(BuildContext context) {
    return BlocBuilder<TimeEntryBloc, TimeEntryState>(
      builder: (context, state) {
        if (state is TimeEntryLoading) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppTheme.primaryBlue,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Time Tracking',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const LoadingIndicator(),
                ],
              ),
            ),
          );
        }

        bool isClockedIn = false;
        Map<String, dynamic>? activeClockIn;

        if (state is ActiveClockInLoaded) {
          isClockedIn = state.isClockedIn;
          activeClockIn = state.activeClockIn;
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppTheme.primaryBlue,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Time Tracking',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isClockedIn && activeClockIn != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Clocked In',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Location: ${activeClockIn['locationName'] ?? 'Unknown'}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Since: ${DateFormat('h:mm a').format(DateTime.parse(activeClockIn['clockInTime']))}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: activeClockIn != null
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ClockOutScreen(
                                    activeClockIn: activeClockIn!,
                                    userId: widget.user.userId,
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Clock Out'),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ClockInScreen(userId: widget.user.userId),
                          ),
                        ).then((_) {
                          // Reload after returning
                          context.read<TimeEntryBloc>().add(LoadActiveClockIn(userId: widget.user.userId));
                        });
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Clock In'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Not clocked in',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.secondaryTeal,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Your Schedule (Next 30 Days)',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _isLoadingSchedule
                ? const Center(child: CircularProgressIndicator())
                : _scheduleData != null && _scheduleData!['hasSchedule'] == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var schedule in (_scheduleData!['schedules'] as List))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryTeal.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.access_time, size: 16, color: AppTheme.secondaryTeal),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${schedule['startTime']} - ${schedule['endTime']}',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    if (schedule['location'] != null)
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              schedule['location']['name'] ?? 'N/A',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: AppTheme.textSecondary,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondary),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat('MMM dd, yyyy').format(DateTime.parse(schedule['date'])),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: AppTheme.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.event_busy, color: Colors.grey),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _scheduleData?['message'] ?? 'No schedule at this time',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursCard(BuildContext context) {
    return BlocBuilder<TimeEntryBloc, TimeEntryState>(
      builder: (context, state) {
        String hoursText = '0.0 hours';

        if (state is HoursSummaryLoaded) {
          final totalHours = state.summary['totalHours'] ?? 0.0;
          hoursText = '${totalHours.toStringAsFixed(1)} hours';
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: AppTheme.accentCyan,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Hours This Week',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  hoursText,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
