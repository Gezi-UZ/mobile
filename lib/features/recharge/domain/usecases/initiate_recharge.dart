import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/recharge.dart';
import '../repositories/recharge_repository.dart';

class InitiateRecharge implements UseCase<Recharge, InitiateRechargeParams> {
  final RechargeRepository repository;

  InitiateRecharge(this.repository);

  @override
  Future<Either<Failure, Recharge>> call(InitiateRechargeParams params) async {
    return await repository.initiateRecharge(
      amount: params.amount,
      meterId: params.meterId,
      phone: params.phone,
    );
  }
}

class InitiateRechargeParams extends Equatable {
  final double amount;
  final String meterId;
  final String method;
  final String? phone;

  const InitiateRechargeParams({
    required this.amount,
    required this.meterId,
    required this.method,
    this.phone,
  });

  @override
  List<Object?> get props => [amount, meterId, method, phone];
}
