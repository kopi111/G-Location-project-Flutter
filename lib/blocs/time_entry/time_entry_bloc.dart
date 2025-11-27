import 'package:flutter_bloc/flutter_bloc.dart';
import 'time_entry_event.dart';
import 'time_entry_state.dart';
import '../../services/api/time_entry_service.dart';

class TimeEntryBloc extends Bloc<TimeEntryEvent, TimeEntryState> {
  final TimeEntryService _timeEntryService;

  TimeEntryBloc({required TimeEntryService timeEntryService})
      : _timeEntryService = timeEntryService,
        super(const TimeEntryInitial()) {
    on<LoadActiveClockIn>(_onLoadActiveClockIn);
    on<ClockInRequested>(_onClockInRequested);
    on<ClockOutRequested>(_onClockOutRequested);
    on<StartBreakRequested>(_onStartBreakRequested);
    on<EndBreakRequested>(_onEndBreakRequested);
    on<LoadTimeEntries>(_onLoadTimeEntries);
    on<LoadHoursSummary>(_onLoadHoursSummary);
  }

  Future<void> _onLoadActiveClockIn(
    LoadActiveClockIn event,
    Emitter<TimeEntryState> emit,
  ) async {
    emit(const TimeEntryLoading());

    try {
      final activeClockIn = await _timeEntryService.getActiveClockIn(userId: event.userId);

      if (activeClockIn != null) {
        emit(ActiveClockInLoaded(
          activeClockIn: activeClockIn,
          isClockedIn: true,
        ));
      } else {
        emit(const ActiveClockInLoaded(
          activeClockIn: null,
          isClockedIn: false,
        ));
      }
    } catch (e) {
      // No active clock-in is not an error
      emit(const ActiveClockInLoaded(
        activeClockIn: null,
        isClockedIn: false,
      ));
    }
  }

  Future<void> _onClockInRequested(
    ClockInRequested event,
    Emitter<TimeEntryState> emit,
  ) async {
    emit(const TimeEntryLoading());

    try {
      final result = await _timeEntryService.clockIn(
        userId: event.userId,
        locationId: event.locationId,
        latitude: event.latitude,
        longitude: event.longitude,
        forceOverride: event.forceOverride,
      );

      // Check if confirmation is required (already clocked out today)
      if (result['requiresConfirmation'] == true) {
        emit(ClockInConfirmationRequired(
          message: result['message'] ?? 'You have already clocked out today. Do you want to start a new shift?',
          userId: event.userId,
          locationId: event.locationId,
          latitude: event.latitude,
          longitude: event.longitude,
        ));
        return;
      }

      emit(ClockInSuccess(
        timeEntry: result,
        hasGPSIssue: false,
        message: result['message'] ?? 'Clocked in successfully',
      ));

      // Load the active clock-in to update state
      add(LoadActiveClockIn(userId: event.userId));
    } catch (e) {
      emit(TimeEntryError('Clock in failed: ${e.toString()}'));
    }
  }

  Future<void> _onClockOutRequested(
    ClockOutRequested event,
    Emitter<TimeEntryState> emit,
  ) async {
    emit(const TimeEntryLoading());

    try {
      final result = await _timeEntryService.clockOut(
        userId: event.userId,
        latitude: event.latitude,
        longitude: event.longitude,
      );

      emit(ClockOutSuccess(
        timeEntry: result,
        totalHours: (result['totalHours'] as num?)?.toDouble() ?? 0.0,
        message: result['message'] ?? 'Clocked out successfully',
      ));

      // Update active clock-in state
      add(LoadActiveClockIn(userId: event.userId));
    } catch (e) {
      emit(TimeEntryError('Clock out failed: ${e.toString()}'));
    }
  }

  Future<void> _onStartBreakRequested(
    StartBreakRequested event,
    Emitter<TimeEntryState> emit,
  ) async {
    emit(const TimeEntryLoading());

    try {
      final success = await _timeEntryService.startBreak(event.timeEntryId);

      if (success) {
        emit(const BreakStartSuccess('Break started'));

        // Reload active clock-in
        add(LoadActiveClockIn(userId: event.userId));
      } else {
        emit(const TimeEntryError('Failed to start break'));
      }
    } catch (e) {
      emit(TimeEntryError('Failed to start break: ${e.toString()}'));
    }
  }

  Future<void> _onEndBreakRequested(
    EndBreakRequested event,
    Emitter<TimeEntryState> emit,
  ) async {
    emit(const TimeEntryLoading());

    try {
      final success = await _timeEntryService.endBreak(event.timeEntryId);

      if (success) {
        emit(const BreakEndSuccess('Break ended'));

        // Reload active clock-in
        add(LoadActiveClockIn(userId: event.userId));
      } else {
        emit(const TimeEntryError('Failed to end break'));
      }
    } catch (e) {
      emit(TimeEntryError('Failed to end break: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTimeEntries(
    LoadTimeEntries event,
    Emitter<TimeEntryState> emit,
  ) async {
    emit(const TimeEntryLoading());

    try {
      final timeEntries = await _timeEntryService.getTimeEntries(
        userId: event.userId,
        startDate: event.startDate,
        endDate: event.endDate,
        locationId: event.locationId,
      );

      final List<Map<String, dynamic>> entries =
          timeEntries.map((e) => e.toJson()).toList();

      emit(TimeEntriesLoaded(
        timeEntries: entries,
        totalCount: entries.length,
      ));
    } catch (e) {
      emit(TimeEntryError('Failed to load time entries: ${e.toString()}'));
    }
  }

  Future<void> _onLoadHoursSummary(
    LoadHoursSummary event,
    Emitter<TimeEntryState> emit,
  ) async {
    emit(const TimeEntryLoading());

    try {
      final summary = await _timeEntryService.getEmployeeHoursSummary(
        userId: event.userId,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(HoursSummaryLoaded(summary));
    } catch (e) {
      emit(TimeEntryError('Failed to load hours summary: ${e.toString()}'));
    }
  }
}
