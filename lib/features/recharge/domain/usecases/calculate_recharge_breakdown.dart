import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recharge_breakdown.dart';
import '../repositories/recharge_repository.dart';

class CalculateRechargeBreakdownParams {
  final double amount;
  final String meterNumber;

  const CalculateRechargeBreakdownParams({
    required this.amount,
    required this.meterNumber,
  });
}

class CalculateRechargeBreakdown {
  final RechargeRepository repository;

  CalculateRechargeBreakdown(this.repository);

  Future<Either<Failure, RechargeBreakdown>> call(CalculateRechargeBreakdownParams params) async {
    return await repository.calculateBreakdown(
      amount: params.amount,
      meterNumber: params.meterNumber,
    );
  }
}
