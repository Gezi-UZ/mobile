import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class RequestOtp {
  final AuthRepository repository;

  RequestOtp(this.repository);

  Future<Either<Failure, void>> call(String phoneNumber) {
    return repository.requestOtp(phoneNumber);
  }
}