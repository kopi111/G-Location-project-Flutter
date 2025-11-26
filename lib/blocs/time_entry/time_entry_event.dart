import 'package:equatable/equatable.dart';

abstract class TimeEntryEvent extends Equatable {
  const TimeEntryEvent();

  @override
  List<Object?> get props => [];
}

/// Load active clock-in for current user
class LoadActiveClockIn extends TimeEntryEvent {
  final int userId;

  const LoadActiveClockIn({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Clock in at a location
class ClockInRequested extends TimeEntryEvent {
  final int userId;
  final int locationId;
  final double latitude;
  final double longitude;

  const ClockInRequested({
    required this.userId,
    required this.locationId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [userId, locationId, latitude, longitude];
}

/// Clock out from current shift
class ClockOutRequested extends TimeEntryEvent {
  final int userId;
  final double latitude;
  final double longitude;

  const ClockOutRequested({
    required this.userId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [userId, latitude, longitude];
}

/// Start break
class StartBreakRequested extends TimeEntryEvent {
  final int timeEntryId;
  final int userId;

  const StartBreakRequested({required this.timeEntryId, required this.userId});

  @override
  List<Object?> get props => [timeEntryId, userId];
}

/// End break
class EndBreakRequested extends TimeEntryEvent {
  final int timeEntryId;
  final int userId;

  const EndBreakRequested({required this.timeEntryId, required this.userId});

  @override
  List<Object?> get props => [timeEntryId, userId];
}

/// Load time entries with optional filters
class LoadTimeEntries extends TimeEntryEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? locationId;

  const LoadTimeEntries({
    this.startDate,
    this.endDate,
    this.locationId,
  });

  @override
  List<Object?> get props => [startDate, endDate, locationId];
}

/// Load hours summary for date range
class LoadHoursSummary extends TimeEntryEvent {
  final int userId;
  final DateTime startDate;
  final DateTime endDate;

  const LoadHoursSummary({
    required this.userId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [userId, startDate, endDate];
}
