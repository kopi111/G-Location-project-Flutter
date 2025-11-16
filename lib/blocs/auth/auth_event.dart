import 'package:equatable/equatable.dart';

/// Authentication Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check if user is already logged in
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Login event
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Register event
class AuthRegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String roleName;

  const AuthRegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.roleName,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        password,
        confirmPassword,
        roleName,
      ];
}

/// Logout event
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Forgot password event
class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  const AuthForgotPasswordRequested(this.email);

  @override
  List<Object?> get props => [email];
}

/// Reset password event
class AuthResetPasswordRequested extends AuthEvent {
  final String email;
  final String token;
  final String newPassword;

  const AuthResetPasswordRequested({
    required this.email,
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, token, newPassword];
}

/// Refresh token event
class AuthRefreshTokenRequested extends AuthEvent {
  const AuthRefreshTokenRequested();
}
