import 'package:equatable/equatable.dart';

/// Time Entry model for clock in/out tracking
class TimeEntry extends Equatable {
  final int id;
  final int userId;
  final String? employeeName;
  final String? email;
  final String? roleName;
  final int locationId;
  final String? locationName;
  final String? locationCode;
  final String? locationAddress;
  final DateTime clockInTime;
  final double clockInLatitude;
  final double clockInLongitude;
  final double? clockInDistanceFromLocation;
  final String? clockInNotes;
  final DateTime? clockOutTime;
  final double? clockOutLatitude;
  final double? clockOutLongitude;
  final double? clockOutDistanceFromLocation;
  final String? clockOutNotes;
  final double? totalHours;
  final int? totalMinutes;
  final String status;
  final DateTime? breakStartTime;
  final DateTime? breakEndTime;
  final int totalBreakMinutes;
  final bool isValidated;
  final int? validatedBy;
  final String? validatedByName;
  final DateTime? validatedAt;
  final String? validationNotes;
  final bool isApproved;
  final int? approvedBy;
  final String? approvedByName;
  final DateTime? approvedAt;
  final bool hasGPSIssue;
  final bool hasTimeIssue;
  final bool requiresReview;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TimeEntry({
    required this.id,
    required this.userId,
    this.employeeName,
    this.email,
    this.roleName,
    required this.locationId,
    this.locationName,
    this.locationCode,
    this.locationAddress,
    required this.clockInTime,
    required this.clockInLatitude,
    required this.clockInLongitude,
    this.clockInDistanceFromLocation,
    this.clockInNotes,
    this.clockOutTime,
    this.clockOutLatitude,
    this.clockOutLongitude,
    this.clockOutDistanceFromLocation,
    this.clockOutNotes,
    this.totalHours,
    this.totalMinutes,
    required this.status,
    this.breakStartTime,
    this.breakEndTime,
    this.totalBreakMinutes = 0,
    this.isValidated = false,
    this.validatedBy,
    this.validatedByName,
    this.validatedAt,
    this.validationNotes,
    this.isApproved = false,
    this.approvedBy,
    this.approvedByName,
    this.approvedAt,
    this.hasGPSIssue = false,
    this.hasTimeIssue = false,
    this.requiresReview = false,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => clockOutTime == null;
  bool get isClockedOut => clockOutTime != null;
  bool get isOnBreak => breakStartTime != null && breakEndTime == null;

  Duration get currentDuration {
    if (isClockedOut && clockOutTime != null) {
      return clockOutTime!.difference(clockInTime);
    }
    return DateTime.now().difference(clockInTime);
  }

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'] as int,
      userId: json['userId'] as int,
      employeeName: json['employeeName'] as String?,
      email: json['email'] as String?,
      roleName: json['roleName'] as String?,
      locationId: json['locationId'] as int,
      locationName: json['locationName'] as String?,
      locationCode: json['locationCode'] as String?,
      locationAddress: json['locationAddress'] as String?,
      clockInTime: DateTime.parse(json['clockInTime'] as String),
      clockInLatitude: (json['clockInLatitude'] as num).toDouble(),
      clockInLongitude: (json['clockInLongitude'] as num).toDouble(),
      clockInDistanceFromLocation:
          json['clockInDistanceFromLocation'] != null
              ? (json['clockInDistanceFromLocation'] as num).toDouble()
              : null,
      clockInNotes: json['clockInNotes'] as String?,
      clockOutTime: json['clockOutTime'] != null
          ? DateTime.parse(json['clockOutTime'] as String)
          : null,
      clockOutLatitude: json['clockOutLatitude'] != null
          ? (json['clockOutLatitude'] as num).toDouble()
          : null,
      clockOutLongitude: json['clockOutLongitude'] != null
          ? (json['clockOutLongitude'] as num).toDouble()
          : null,
      clockOutDistanceFromLocation:
          json['clockOutDistanceFromLocation'] != null
              ? (json['clockOutDistanceFromLocation'] as num).toDouble()
              : null,
      clockOutNotes: json['clockOutNotes'] as String?,
      totalHours: json['totalHours'] != null
          ? (json['totalHours'] as num).toDouble()
          : null,
      totalMinutes: json['totalMinutes'] as int?,
      status: json['status'] as String? ?? 'ClockedIn',
      breakStartTime: json['breakStartTime'] != null
          ? DateTime.parse(json['breakStartTime'] as String)
          : null,
      breakEndTime: json['breakEndTime'] != null
          ? DateTime.parse(json['breakEndTime'] as String)
          : null,
      totalBreakMinutes: json['totalBreakMinutes'] as int? ?? 0,
      isValidated: json['isValidated'] as bool? ?? false,
      validatedBy: json['validatedBy'] as int?,
      validatedByName: json['validatedByName'] as String?,
      validatedAt: json['validatedAt'] != null
          ? DateTime.parse(json['validatedAt'] as String)
          : null,
      validationNotes: json['validationNotes'] as String?,
      isApproved: json['isApproved'] as bool? ?? false,
      approvedBy: json['approvedBy'] as int?,
      approvedByName: json['approvedByName'] as String?,
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'] as String)
          : null,
      hasGPSIssue: json['hasGPSIssue'] as bool? ?? false,
      hasTimeIssue: json['hasTimeIssue'] as bool? ?? false,
      requiresReview: json['requiresReview'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'employeeName': employeeName,
      'email': email,
      'roleName': roleName,
      'locationId': locationId,
      'locationName': locationName,
      'locationCode': locationCode,
      'locationAddress': locationAddress,
      'clockInTime': clockInTime.toIso8601String(),
      'clockInLatitude': clockInLatitude,
      'clockInLongitude': clockInLongitude,
      'clockInDistanceFromLocation': clockInDistanceFromLocation,
      'clockInNotes': clockInNotes,
      'clockOutTime': clockOutTime?.toIso8601String(),
      'clockOutLatitude': clockOutLatitude,
      'clockOutLongitude': clockOutLongitude,
      'clockOutDistanceFromLocation': clockOutDistanceFromLocation,
      'clockOutNotes': clockOutNotes,
      'totalHours': totalHours,
      'totalMinutes': totalMinutes,
      'status': status,
      'breakStartTime': breakStartTime?.toIso8601String(),
      'breakEndTime': breakEndTime?.toIso8601String(),
      'totalBreakMinutes': totalBreakMinutes,
      'isValidated': isValidated,
      'validatedBy': validatedBy,
      'validatedByName': validatedByName,
      'validatedAt': validatedAt?.toIso8601String(),
      'validationNotes': validationNotes,
      'isApproved': isApproved,
      'approvedBy': approvedBy,
      'approvedByName': approvedByName,
      'approvedAt': approvedAt?.toIso8601String(),
      'hasGPSIssue': hasGPSIssue,
      'hasTimeIssue': hasTimeIssue,
      'requiresReview': requiresReview,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        employeeName,
        email,
        roleName,
        locationId,
        locationName,
        locationCode,
        locationAddress,
        clockInTime,
        clockInLatitude,
        clockInLongitude,
        clockInDistanceFromLocation,
        clockInNotes,
        clockOutTime,
        clockOutLatitude,
        clockOutLongitude,
        clockOutDistanceFromLocation,
        clockOutNotes,
        totalHours,
        totalMinutes,
        status,
        breakStartTime,
        breakEndTime,
        totalBreakMinutes,
        isValidated,
        validatedBy,
        validatedByName,
        validatedAt,
        validationNotes,
        isApproved,
        approvedBy,
        approvedByName,
        approvedAt,
        hasGPSIssue,
        hasTimeIssue,
        requiresReview,
        createdAt,
        updatedAt,
      ];
}
