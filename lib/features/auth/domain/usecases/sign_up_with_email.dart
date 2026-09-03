import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/session.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmail {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  Future<Either<Failure, UserSession>> call({
    required String fullName,
    required String email,
    required String pin,
  }) async {
    return await repository.signUpWithEmail(
      fullName: fullName,
      email: email,
      pin: pin,
    );
  }
}
