import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class LocalAuthRepository {
  Future<Either<Failure, bool>> checkBiometricsAvailable();
  Future<Either<Failure, bool>> authenticate({required String localizedReason});
}
