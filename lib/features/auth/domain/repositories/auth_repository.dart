import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/session.dart';

abstract class AuthRepository {
  /// Creates a new account with [phone] + auto-generated password.
  Future<Either<Failure, UserSession>> signUp(String phone);

  /// Signs in using [phone] + [password].
  Future<Either<Failure, UserSession>> signInWithPassword(
    String phone,
    String password,
  );

  /// Returns the current active session, if any.
  Future<Either<Failure, UserSession?>> getCurrentSession();

  /// Signs the user out and clears the Supabase session.
  Future<Either<Failure, void>> signOut();

  /// Saves the session's refresh token to secure storage and enables biometric.
  Future<Either<Failure, void>> enableBiometric(UserSession session);

  /// Saves a 6-digit PIN securely hashed in hardware storage.
  Future<Either<Failure, void>> savePin(String pin, UserSession session);

  /// Verifies a 6-digit PIN and restores the Supabase session if correct.
  Future<Either<Failure, UserSession>> verifyPin(String pin);

  /// Restores a session from secure storage.
  Future<Either<Failure, UserSession>> restoreSessionFromSecureStorage();

  /// Whether biometric is enabled for the current device/account.
  Future<bool> isBiometricEnabled();

  /// Whether PIN is configured on this device.
  Future<bool> isPinConfigured();
}