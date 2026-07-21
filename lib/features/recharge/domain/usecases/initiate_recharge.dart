import 'package:dartz/dartz.dart';
import 'package:gezi/core/errors/failures.dart';
import '../entities/recharge_result.dart';
import '../repositories/recharge_repository.dart';

class InitiateRechargeParams {
  final double amount;
  final String meterNumber;
  final String method;

  const InitiateRechargeParams({
    required this.amount,
    required this.meterNumber,
    required this.method,
  });
}

class InitiateRecharge {
  final RechargeRepository repository;

  InitiateRecharge(this.repository);

  Future<Either<Failure, RechargeResult>> call(InitiateRechargeParams params) async {
    return await repository.initiateRecharge(
      amount: params.amount,
      meterNumber: params.meterNumber,
      method: params.method,
    );
  }
}
