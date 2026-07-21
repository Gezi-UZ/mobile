import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recharge_breakdown.dart';
import '../entities/recharge_result.dart';

abstract class RechargeRepository {
  Future<Either<Failure, RechargeBreakdown>> calculateBreakdown({
    required double amount,
    required String meterNumber,
  });

  Future<Either<Failure, RechargeResult>> initiateRecharge({
    required double amount,
    required String meterNumber,
    required String method,
  });

  Future<Either<Failure, RechargeResult>> applyCode({
    required String code,
    required String meterNumber,
  });
}
