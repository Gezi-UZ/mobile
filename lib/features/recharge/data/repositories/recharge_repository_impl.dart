import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/recharge_breakdown.dart';
import '../../domain/entities/recharge.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/recharge_repository.dart';
import '../datasources/recharge_remote_data_source.dart';

class RechargeRepositoryImpl implements RechargeRepository {
  final RechargeRemoteDataSource remoteDataSource;

  RechargeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RechargeBreakdown>> calculateBreakdown({
    required double amount,
    required String meterId,
  }) async {
    try {
      final breakdown = await remoteDataSource.calculateBreakdown(
        amount: amount,
        meterId: meterId,
      );
      return Right(breakdown);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recharge>> initiateRecharge({
    required double amount,
    required String meterId,
    String? phone,
  }) async {
    try {
      final result = await remoteDataSource.initiateRecharge(
        amount: amount,
        meterId: meterId,
        phone: phone,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recharge>> applyCode({
    required String code,
  }) async {
    try {
      final result = await remoteDataSource.applyCode(
        code: code,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Recharge> streamRechargeStatus(String rechargeId) {
    return remoteDataSource.streamRechargeStatus(rechargeId);
  }

  @override
  Future<Either<Failure, List<Recharge>>> getRechargeHistory({
    required String meterId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final result = await remoteDataSource.getRechargeHistory(
        meterId: meterId,
        page: page,
        pageSize: pageSize,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats({
    required String meterId,
    required String period,
  }) async {
    try {
      final result = await remoteDataSource.getDashboardStats(
        meterId: meterId,
        period: period,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
