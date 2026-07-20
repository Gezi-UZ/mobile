import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/local_auth_repository.dart';
import '../datasources/local_auth_local_data_source.dart';

class LocalAuthRepositoryImpl implements LocalAuthRepository {
  final LocalAuthLocalDataSource localDataSource;

  LocalAuthRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, bool>> checkBiometricsAvailable() async {
    try {
      final result = await localDataSource.checkBiometricsAvailable();
      return Right(result);
    } on CacheException {
      return Left(CacheFailure('Failed to check biometrics availability'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticate({required String localizedReason}) async {
    try {
      final result = await localDataSource.authenticate(localizedReason: localizedReason);
      return Right(result);
    } on CacheException {
      return Left(CacheFailure('Failed to authenticate with biometrics'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
