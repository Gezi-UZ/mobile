import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  Future<Either<Failure, bool>> call(String phoneNumber, String code) {
    return repository.verifyOtp(phoneNumber, code);
  }
}