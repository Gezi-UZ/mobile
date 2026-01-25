import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/led.dart';
import '../../domain/repositories/led_repository.dart';
import '../datasources/led_remote_data_source.dart';

/// Implementation of LED Repository
class LedRepositoryImpl implements LedRepository {
  final LedRemoteDataSource remoteDataSource;

  LedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, bool>>> getAllLeds() async {
    try {
      final result = await remoteDataSource.getAllLeds();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Led>> getLed(String ledId) async {
    try {
      final result = await remoteDataSource.getLed(ledId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Led>> setLed(String ledId, bool state) async {
    try {
      final result = await remoteDataSource.setLed(ledId, state);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}