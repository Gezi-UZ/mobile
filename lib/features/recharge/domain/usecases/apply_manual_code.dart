import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/recharge.dart';
import '../repositories/recharge_repository.dart';

class ApplyManualCode implements UseCase<Recharge, ApplyManualCodeParams> {
  final RechargeRepository repository;

  ApplyManualCode(this.repository);

  @override
  Future<Either<Failure, Recharge>> call(ApplyManualCodeParams params) async {
    return await repository.applyCode(
      code: params.code,
    );
  }
}

class ApplyManualCodeParams extends Equatable {
  final String code;

  const ApplyManualCodeParams({
    required this.code,
  });

  @override
  List<Object?> get props => [code];
}
