import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recharge_result.dart';
import '../repositories/recharge_repository.dart';

class ApplyManualCodeParams {
  final String code;
  final String meterNumber;

  const ApplyManualCodeParams({
    required this.code,
    required this.meterNumber,
  });
}

class ApplyManualCode {
  final RechargeRepository repository;

  ApplyManualCode(this.repository);

  Future<Either<Failure, RechargeResult>> call(ApplyManualCodeParams params) async {
    return await repository.applyCode(
      code: params.code,
      meterNumber: params.meterNumber,
    );
  }
}
