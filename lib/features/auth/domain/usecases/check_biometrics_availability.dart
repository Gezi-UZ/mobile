import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/local_auth_repository.dart';

class CheckBiometricsAvailability {
  final LocalAuthRepository repository;

  CheckBiometricsAvailability(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.checkBiometricsAvailable();
  }
}
