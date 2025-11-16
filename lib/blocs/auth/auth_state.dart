import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

/// Authentication States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial/Unknown state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Email verification required state
class AuthEmailVerificationRequired extends AuthState {
  final String email;
  final int userId;

  const AuthEmailVerificationRequired({
    required this.email,
    required this.userId,
  });

  @override
  List<Object?> get props => [email, userId];
}

/// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Logout state
class AuthLogoutSuccess extends AuthState {
  const AuthLogoutSuccess();
}

/// Password reset email sent state
class AuthPasswordResetEmailSent extends AuthState {
  final String email;

  const AuthPasswordResetEmailSent(this.email);

  @override
  List<Object?> get props => [email];
}

/// Password reset success state
class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}

/// Registration success state
class AuthRegistrationSuccess extends AuthState {
  final String email;
  final String? password; // Optional password for auto-login after verification

  const AuthRegistrationSuccess(this.email, {this.password});

  @override
  List<Object?> get props => [email, password];
}
