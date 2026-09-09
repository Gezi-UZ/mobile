import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recharge_breakdown.dart';
import '../entities/recharge.dart';
import '../entities/dashboard_stats.dart';

abstract class RechargeRepository {
  Future<Either<Failure, RechargeBreakdown>> calculateBreakdown({
    required double amount,
    required String meterId,
  });

  Future<Either<Failure, Recharge>> initiateRecharge({
    required double amount,
    required String meterId,
    String? phone,
  });

  Future<Either<Failure, Recharge>> applyCode({
    required String code,
  });

  Stream<Recharge> streamRechargeStatus(String rechargeId);

  Future<Either<Failure, List<Recharge>>> getRechargeHistory({
    required String meterId,
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, DashboardStats>> getDashboardStats({
    required String meterId,
    required String period,
  });
}
