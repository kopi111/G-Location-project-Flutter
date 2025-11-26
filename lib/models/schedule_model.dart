import 'package:equatable/equatable.dart';

/// User Schedule model
class UserSchedule extends Equatable {
  final int id;
  final int userId;
  final int locationId;
  final DateTime scheduleDate;
  final String startTime; // TimeSpan as String (HH:mm:ss)
  final String endTime; // TimeSpan as String (HH:mm:ss)
  final DateTime createdAt;

  // Additional fields for display
  final String? locationName;
  final String? userName;

  const UserSchedule({
    required this.id,
    required this.userId,
    required this.locationId,
    required this.scheduleDate,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    this.locationName,
    this.userName,
  });

  factory UserSchedule.fromJson(Map<String, dynamic> json) {
    return UserSchedule(
      id: json['id'] as int,
      userId: json['userId'] as int,
      locationId: json['locationId'] as int,
      scheduleDate: DateTime.parse(json['scheduleDate'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      locationName: json['locationName'] as String?,
      userName: json['userName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'locationId': locationId,
      'scheduleDate': scheduleDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': createdAt.toIso8601String(),
      'locationName': locationName,
      'userName': userName,
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        locationId,
        scheduleDate,
        startTime,
        endTime,
        createdAt,
        locationName,
        userName,
      ];
}

/// Schedule response model
class ScheduleResponse {
  final int id;
  final String locationName;
  final DateTime scheduleDate;
  final String startTime;
  final String endTime;

  const ScheduleResponse({
    required this.id,
    required this.locationName,
    required this.scheduleDate,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleResponse(
      id: json['id'] as int,
      locationName: json['locationName'] as String,
      scheduleDate: DateTime.parse(json['scheduleDate'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationName': locationName,
      'scheduleDate': scheduleDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
