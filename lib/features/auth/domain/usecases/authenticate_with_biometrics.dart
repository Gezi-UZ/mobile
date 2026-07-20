import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/local_auth_repository.dart';

class AuthenticateWithBiometrics {
  final LocalAuthRepository repository;

  AuthenticateWithBiometrics(this.repository);

  Future<Either<Failure, bool>> call({required String localizedReason}) async {
    return await repository.authenticate(localizedReason: localizedReason);
  }
}
