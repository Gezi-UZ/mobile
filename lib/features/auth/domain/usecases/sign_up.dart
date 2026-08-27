import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/session.dart';
import '../repositories/auth_repository.dart';

/// Signs up a new user with their phone number.
/// Returns a [UserSession] on success.
class SignUp {
  final AuthRepository repository;
  const SignUp(this.repository);

  Future<Either<Failure, UserSession>> call(String phone) {
    return repository.signUp(phone);
  }
}
