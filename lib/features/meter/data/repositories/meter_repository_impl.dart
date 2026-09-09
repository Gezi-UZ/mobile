import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/meter.dart';
import '../../domain/repositories/meter_repository.dart';
import '../datasources/meter_realtime_data_source.dart';
import '../datasources/meter_remote_data_source.dart';

class MeterRepositoryImpl implements MeterRepository {
  final MeterRemoteDataSource remoteDataSource;
  final MeterRealtimeDataSource realtimeDataSource;

  MeterRepositoryImpl({
    required this.remoteDataSource,
    required this.realtimeDataSource,
  });

  @override
  Future<Either<Failure, List<Meter>>> getMeters() async {
    try {
      final meters = await remoteDataSource.getMeters();
      return Right(meters);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Meter>> addMeter({
    required String serialNumber,
    required String alias,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      final meter = await remoteDataSource.addMeter(
        serialNumber: serialNumber,
        alias: alias,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      return Right(meter);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Meter>> getMeterDetails(String meterId) async {
    try {
      final meter = await remoteDataSource.getMeterDetails(meterId);
      return Right(meter);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Meter>> updateMeter(String meterId, {String? alias, bool? isPrimary}) async {
    try {
      final meter = await remoteDataSource.updateMeter(meterId, alias: alias, isPrimary: isPrimary);
      return Right(meter);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Meter> watchMeterStatus(String meterId) {
    return realtimeDataSource.watchMeterStatus(meterId);
  }

  @override
  Future<Either<Failure, Meter>> validateMeterBySerial(String serialNumber) async {
    try {
      final meter = await remoteDataSource.validateMeterBySerial(serialNumber);
      return Right(meter);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<Meter>> watchUserMeters(String userId) {
    return realtimeDataSource.watchUserMeters(userId);
  }

  @override
  Future<Either<Failure, bool>> pingMeter(String meterId) async {
    try {
      final isOnline = await remoteDataSource.pingMeter(meterId);
      return Right(isOnline);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
