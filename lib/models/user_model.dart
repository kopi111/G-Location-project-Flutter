import 'package:equatable/equatable.dart';

/// User roles in the application
enum UserRole {
  lifeguard('Lifeguard'),
  poolAttendant('PoolAttendant'),
  serviceTechnician('ServiceTechnician'),
  manager('Manager'),
  supervisor('Supervisor'),
  safetyAudit('SafetyAudit'),
  superAdmin('SuperAdmin');

  final String value;
  const UserRole(this.value);

  String get displayName => value;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (r) => r.value.toLowerCase() == role.toLowerCase(),
      orElse: () => UserRole.lifeguard,
    );
  }
}

/// User model representing authenticated user
class User extends Equatable {
  final int userId;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final UserRole role;
  final String token;
  final String refreshToken;
  final DateTime tokenExpiry;
  final bool emailVerified;
  final bool isActive;
  final DateTime? lastLoginAt;

  const User({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.role,
    required this.token,
    required this.refreshToken,
    required this.tokenExpiry,
    required this.emailVerified,
    this.isActive = true,
    this.lastLoginAt,
  });

  int get id => userId;

  String get fullName => '$firstName $lastName';

  bool get isManager =>
      role == UserRole.manager ||
      role == UserRole.supervisor ||
      role == UserRole.superAdmin;

  bool get isServiceTech => role == UserRole.serviceTechnician;
  bool get isLifeguard => role == UserRole.lifeguard || role == UserRole.poolAttendant;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      role: UserRole.fromString(json['roleName'] as String),
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenExpiry: DateTime.parse(json['tokenExpiry'] as String),
      emailVerified: json['emailVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'roleName': role.value,
      'token': token,
      'refreshToken': refreshToken,
      'tokenExpiry': tokenExpiry.toIso8601String(),
      'emailVerified': emailVerified,
      'isActive': isActive,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  User copyWith({
    int? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    UserRole? role,
    String? token,
    String? refreshToken,
    DateTime? tokenExpiry,
    bool? emailVerified,
    bool? isActive,
    DateTime? lastLoginAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiry: tokenExpiry ?? this.tokenExpiry,
      emailVerified: emailVerified ?? this.emailVerified,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        firstName,
        lastName,
        phone,
        role,
        token,
        refreshToken,
        tokenExpiry,
        emailVerified,
        isActive,
        lastLoginAt,
      ];
}
