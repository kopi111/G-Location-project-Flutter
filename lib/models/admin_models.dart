import 'response_models.dart';

/// Admin User Response
class AdminUserResponse extends UserResponse {
  final bool isActive;
  final DateTime? lastLoginAt;

  const AdminUserResponse({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    String? phone,
    required String role,
    required bool verifyEmail,
    required DateTime createdAt,
    required this.isActive,
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

  factory AdminUserResponse.fromJson(Map<String, dynamic> json) {
    return AdminUserResponse(
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
      isActive: json['isActive'] as bool? ?? true,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'isActive': isActive,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }
}

/// Admin Create User Request
class AdminCreateUserRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String role;

  const AdminCreateUserRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
    };
  }
}

/// Admin Update User Request
class AdminUpdateUserRequest {
  final String firstName;
  final String lastName;
  final String phone;
  final String role;
  final bool isActive;

  const AdminUpdateUserRequest({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'role': role,
      'isActive': isActive,
    };
  }
}

/// Dashboard Stats Response
class DashboardStatsResponse {
  final int totalUsers;
  final int activeUsersToday;
  final int pendingChecklists;
  final int openSafetyIssues;
  final int pendingSupplyRequests;
  final List<LocationActivity> locationActivities;

  const DashboardStatsResponse({
    required this.totalUsers,
    required this.activeUsersToday,
    required this.pendingChecklists,
    required this.openSafetyIssues,
    required this.pendingSupplyRequests,
    required this.locationActivities,
  });

  factory DashboardStatsResponse.fromJson(Map<String, dynamic> json) {
    return DashboardStatsResponse(
      totalUsers: json['totalUsers'] as int? ?? 0,
      activeUsersToday: json['activeUsersToday'] as int? ?? 0,
      pendingChecklists: json['pendingChecklists'] as int? ?? 0,
      openSafetyIssues: json['openSafetyIssues'] as int? ?? 0,
      pendingSupplyRequests: json['pendingSupplyRequests'] as int? ?? 0,
      locationActivities: (json['locationActivities'] as List?)
              ?.map((e) => LocationActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'activeUsersToday': activeUsersToday,
      'pendingChecklists': pendingChecklists,
      'openSafetyIssues': openSafetyIssues,
      'pendingSupplyRequests': pendingSupplyRequests,
      'locationActivities':
          locationActivities.map((e) => e.toJson()).toList(),
    };
  }
}

/// Location Activity
class LocationActivity {
  final String locationName;
  final int activeStaff;
  final int completedChecklists;
  final int pendingIssues;

  const LocationActivity({
    required this.locationName,
    required this.activeStaff,
    required this.completedChecklists,
    required this.pendingIssues,
  });

  factory LocationActivity.fromJson(Map<String, dynamic> json) {
    return LocationActivity(
      locationName: json['locationName'] as String,
      activeStaff: json['activeStaff'] as int? ?? 0,
      completedChecklists: json['completedChecklists'] as int? ?? 0,
      pendingIssues: json['pendingIssues'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'activeStaff': activeStaff,
      'completedChecklists': completedChecklists,
      'pendingIssues': pendingIssues,
    };
  }
}

/// Attendance Report Response
class AttendanceReportResponse {
  final List<AttendanceRecordResponse> records;
  final double totalHours;
  final int totalRecords;

  const AttendanceReportResponse({
    required this.records,
    required this.totalHours,
    required this.totalRecords,
  });

  factory AttendanceReportResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceReportResponse(
      records: (json['records'] as List?)
              ?.map((e) =>
                  AttendanceRecordResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalHours: (json['totalHours'] as num?)?.toDouble() ?? 0.0,
      totalRecords: json['totalRecords'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'records': records.map((e) => e.toJson()).toList(),
      'totalHours': totalHours,
      'totalRecords': totalRecords,
    };
  }
}

/// Attendance Record Response
class AttendanceRecordResponse {
  final int id;
  final String locationName;
  final DateTime clockIn;
  final DateTime? clockOut;
  final double? hoursWorked;

  const AttendanceRecordResponse({
    required this.id,
    required this.locationName,
    required this.clockIn,
    this.clockOut,
    this.hoursWorked,
  });

  factory AttendanceRecordResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordResponse(
      id: json['id'] as int,
      locationName: json['locationName'] as String,
      clockIn: DateTime.parse(json['clockIn'] as String),
      clockOut: json['clockOut'] != null
          ? DateTime.parse(json['clockOut'] as String)
          : null,
      hoursWorked:
          json['hoursWorked'] != null ? (json['hoursWorked'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationName': locationName,
      'clockIn': clockIn.toIso8601String(),
      'clockOut': clockOut?.toIso8601String(),
      'hoursWorked': hoursWorked,
    };
  }
}
