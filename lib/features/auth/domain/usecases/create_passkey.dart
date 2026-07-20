import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class CreatePasskey {
  final AuthRepository repository;

  CreatePasskey(this.repository);

  Future<Either<Failure, void>> call(String phoneNumber) {
    return repository.createPasskey(phoneNumber);
  }
}
