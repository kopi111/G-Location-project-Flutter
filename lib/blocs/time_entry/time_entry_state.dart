import 'package:equatable/equatable.dart';

abstract class TimeEntryState extends Equatable {
  const TimeEntryState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TimeEntryInitial extends TimeEntryState {
  const TimeEntryInitial();
}

/// Loading state
class TimeEntryLoading extends TimeEntryState {
  const TimeEntryLoading();
}

/// Active clock-in loaded
class ActiveClockInLoaded extends TimeEntryState {
  final Map<String, dynamic>? activeClockIn;
  final bool isClockedIn;

  const ActiveClockInLoaded({
    this.activeClockIn,
    required this.isClockedIn,
  });

  @override
  List<Object?> get props => [activeClockIn, isClockedIn];
}

/// Clock in successful
class ClockInSuccess extends TimeEntryState {
  final Map<String, dynamic> timeEntry;
  final bool hasGPSIssue;
  final String message;

  const ClockInSuccess({
    required this.timeEntry,
    required this.hasGPSIssue,
    required this.message,
  });

  @override
  List<Object?> get props => [timeEntry, hasGPSIssue, message];
}

/// Clock out successful
class ClockOutSuccess extends TimeEntryState {
  final Map<String, dynamic> timeEntry;
  final double totalHours;
  final String message;

  const ClockOutSuccess({
    required this.timeEntry,
    required this.totalHours,
    required this.message,
  });

  @override
  List<Object?> get props => [timeEntry, totalHours, message];
}

/// Break started
class BreakStartSuccess extends TimeEntryState {
  final String message;

  const BreakStartSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Break ended
class BreakEndSuccess extends TimeEntryState {
  final String message;

  const BreakEndSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Time entries loaded
class TimeEntriesLoaded extends TimeEntryState {
  final List<Map<String, dynamic>> timeEntries;
  final int totalCount;

  const TimeEntriesLoaded({
    required this.timeEntries,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [timeEntries, totalCount];
}

/// Hours summary loaded
class HoursSummaryLoaded extends TimeEntryState {
  final Map<String, dynamic> summary;

  const HoursSummaryLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

/// Error state
class TimeEntryError extends TimeEntryState {
  final String message;

  const TimeEntryError(this.message);

  @override
  List<Object?> get props => [message];
}
