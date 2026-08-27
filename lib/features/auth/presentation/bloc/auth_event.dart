import 'package:equatable/equatable.dart';
import '../../domain/entities/session.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired at app startup to check for an existing session.
class AppStarted extends AuthEvent {
  const AppStarted();
}

/// Fired after successful biometric verification on the login screen.
class BiometricLoginRequested extends AuthEvent {
  const BiometricLoginRequested();
}

/// Fired when the user enters their 6-digit PIN on the PIN login screen.
class PinLoginRequested extends AuthEvent {
  final String pin;
  const PinLoginRequested(this.pin);

  @override
  List<Object?> get props => [pin];
}

/// Fired after successful sign-up / sign-in with a fresh session.
class SessionObtained extends AuthEvent {
  final UserSession session;
  const SessionObtained(this.session);

  @override
  List<Object?> get props => [session];
}

/// Fired when the user explicitly logs out.
class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}
