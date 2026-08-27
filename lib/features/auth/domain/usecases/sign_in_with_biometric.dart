import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/session.dart';
import '../repositories/auth_repository.dart';

/// Restores a Supabase session from the device secure storage
/// after successful biometric verification.
class SignInWithBiometric {
  final AuthRepository repository;
  const SignInWithBiometric(this.repository);

  Future<Either<Failure, UserSession>> call() {
    return repository.restoreSessionFromSecureStorage();
  }
}
