import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/recharge_breakdown.dart';
import '../repositories/recharge_repository.dart';

class CalculateRechargeBreakdown implements UseCase<RechargeBreakdown, CalculateRechargeBreakdownParams> {
  final RechargeRepository repository;

  CalculateRechargeBreakdown(this.repository);

  @override
  Future<Either<Failure, RechargeBreakdown>> call(CalculateRechargeBreakdownParams params) async {
    return await repository.calculateBreakdown(
      amount: params.amount,
      meterId: params.meterId,
    );
  }
}

class CalculateRechargeBreakdownParams extends Equatable {
  final double amount;
  final String meterId;

  const CalculateRechargeBreakdownParams({
    required this.amount,
    required this.meterId,
  });

  @override
  List<Object?> get props => [amount, meterId];
}
