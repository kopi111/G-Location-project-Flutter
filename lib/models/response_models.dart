/// Base Response model
class BaseResponse {
  final bool success;
  final String message;
  final String? error;

  const BaseResponse({
    required this.success,
    required this.message,
    this.error,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'error': error,
    };
  }
}

/// Auth Response model
class AuthResponse extends BaseResponse {
  final String? token;
  final UserResponse? user;

  const AuthResponse({
    required bool success,
    required String message,
    String? error,
    this.token,
    this.user,
  }) : super(success: success, message: message, error: error);

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      error: json['error'] as String?,
      token: json['token'] as String?,
      user: json['user'] != null
          ? UserResponse.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'token': token,
      'user': user?.toJson(),
    };
  }
}

/// User Response model
class UserResponse {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String role;
  final bool verifyEmail;
  final DateTime createdAt;

  const UserResponse({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.role,
    required this.verifyEmail,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      verifyEmail: json['verifyEmail'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'role': role,
      'verifyEmail': verifyEmail,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// User Profile Response
class UserProfileResponse extends UserResponse {
  final DateTime? lastLoginAt;

  const UserProfileResponse({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    String? phone,
    required String role,
    required bool verifyEmail,
    required DateTime createdAt,
    this.lastLoginAt,
  }) : super(
          id: id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          role: role,
          verifyEmail: verifyEmail,
          createdAt: createdAt,
        );

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      verifyEmail: json['verifyEmail'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }
}

/// Location Response
class LocationResponse {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int geofenceRadiusMeters;
  final String? managerName;
  final bool isActive;

  const LocationResponse({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.geofenceRadiusMeters,
    this.managerName,
    required this.isActive,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      geofenceRadiusMeters: json['geofenceRadiusMeters'] as int? ?? 100,
      managerName: json['managerName'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'geofenceRadiusMeters': geofenceRadiusMeters,
      'managerName': managerName,
      'isActive': isActive,
    };
  }
}

/// Hours Worked Response
class HoursWorkedResponse {
  final double totalHours;
  final List<DailyHours> dailyHours;

  const HoursWorkedResponse({
    required this.totalHours,
    required this.dailyHours,
  });

  factory HoursWorkedResponse.fromJson(Map<String, dynamic> json) {
    return HoursWorkedResponse(
      totalHours: (json['totalHours'] as num?)?.toDouble() ?? 0.0,
      dailyHours: (json['dailyHours'] as List?)
              ?.map((e) => DailyHours.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalHours': totalHours,
      'dailyHours': dailyHours.map((e) => e.toJson()).toList(),
    };
  }
}

/// Daily Hours
class DailyHours {
  final DateTime date;
  final double hours;

  const DailyHours({
    required this.date,
    required this.hours,
  });

  factory DailyHours.fromJson(Map<String, dynamic> json) {
    return DailyHours(
      date: DateTime.parse(json['date'] as String),
      hours: (json['hours'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'hours': hours,
    };
  }
}

/// Attendance Response
class AttendanceResponse extends BaseResponse {
  final int? attendanceId;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final String? locationName;

  const AttendanceResponse({
    required bool success,
    required String message,
    String? error,
    this.attendanceId,
    this.clockIn,
    this.clockOut,
    this.locationName,
  }) : super(success: success, message: message, error: error);

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      error: json['error'] as String?,
      attendanceId: json['attendanceId'] as int?,
      clockIn: json['clockIn'] != null
          ? DateTime.parse(json['clockIn'] as String)
          : null,
      clockOut: json['clockOut'] != null
          ? DateTime.parse(json['clockOut'] as String)
          : null,
      locationName: json['locationName'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'attendanceId': attendanceId,
      'clockIn': clockIn?.toIso8601String(),
      'clockOut': clockOut?.toIso8601String(),
      'locationName': locationName,
    };
  }
}

/// Today Attendance Response
class TodayAttendanceResponse {
  final bool isClockedIn;
  final DateTime? clockInTime;
  final String? currentLocation;
  final double hoursWorkedToday;

  const TodayAttendanceResponse({
    required this.isClockedIn,
    this.clockInTime,
    this.currentLocation,
    required this.hoursWorkedToday,
  });

  factory TodayAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return TodayAttendanceResponse(
      isClockedIn: json['isClockedIn'] as bool? ?? false,
      clockInTime: json['clockInTime'] != null
          ? DateTime.parse(json['clockInTime'] as String)
          : null,
      currentLocation: json['currentLocation'] as String?,
      hoursWorkedToday: (json['hoursWorkedToday'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isClockedIn': isClockedIn,
      'clockInTime': clockInTime?.toIso8601String(),
      'currentLocation': currentLocation,
      'hoursWorkedToday': hoursWorkedToday,
    };
  }
}
