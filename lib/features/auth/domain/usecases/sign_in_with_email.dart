import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/session.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmail {
  final AuthRepository repository;

  SignInWithEmail(this.repository);

  Future<Either<Failure, UserSession>> call({
    required String email,
    required String pin,
  }) async {
    return await repository.signInWithEmail(
      email: email,
      pin: pin,
    );
  }
}
