import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/recharge_breakdown.dart';
import '../../domain/entities/recharge_result.dart';
import '../../domain/repositories/recharge_repository.dart';
import '../datasources/recharge_remote_data_source.dart';

class RechargeRepositoryImpl implements RechargeRepository {
  final RechargeRemoteDataSource remoteDataSource;

  RechargeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RechargeBreakdown>> calculateBreakdown({
    required double amount,
    required String meterNumber,
  }) async {
    try {
      final breakdown = await remoteDataSource.calculateBreakdown(
        amount: amount,
        meterNumber: meterNumber,
      );
      return Right(breakdown);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RechargeResult>> initiateRecharge({
    required double amount,
    required String meterNumber,
    required String method,
  }) async {
    try {
      final result = await remoteDataSource.initiateRecharge(
        amount: amount,
        meterNumber: meterNumber,
        method: method,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RechargeResult>> applyCode({
    required String code,
    required String meterNumber,
  }) async {
    try {
      final result = await remoteDataSource.applyCode(
        code: code,
        meterNumber: meterNumber,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
