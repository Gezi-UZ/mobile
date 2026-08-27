import 'package:equatable/equatable.dart';
import '../../domain/entities/session.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state — session check in progress.
class AuthInitial extends AuthState {}

/// Loading state (sign-out, biometric restore, etc.)
class AuthLoading extends AuthState {}

/// User has a valid Supabase session.
class AuthAuthenticated extends AuthState {
  final UserSession session;
  const AuthAuthenticated(this.session);

  @override
  List<Object?> get props => [session];
}

/// No active session — user must log in.
class AuthUnauthenticated extends AuthState {}

/// An error occurred during an auth operation.
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
