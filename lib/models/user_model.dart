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
  final UserRole role;
  final String token;
  final String refreshToken;
  final DateTime tokenExpiry;
  final bool emailVerified;

  const User({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.token,
    required this.refreshToken,
    required this.tokenExpiry,
    required this.emailVerified,
  });

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
      role: UserRole.fromString(json['roleName'] as String),
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenExpiry: DateTime.parse(json['tokenExpiry'] as String),
      emailVerified: json['emailVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'roleName': role.value,
      'token': token,
      'refreshToken': refreshToken,
      'tokenExpiry': tokenExpiry.toIso8601String(),
      'emailVerified': emailVerified,
    };
  }

  User copyWith({
    int? userId,
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    String? token,
    String? refreshToken,
    DateTime? tokenExpiry,
    bool? emailVerified,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiry: tokenExpiry ?? this.tokenExpiry,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        firstName,
        lastName,
        role,
        token,
        refreshToken,
        tokenExpiry,
        emailVerified,
      ];
}
