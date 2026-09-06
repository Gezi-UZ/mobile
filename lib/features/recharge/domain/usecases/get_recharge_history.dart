import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/recharge.dart';
import '../repositories/recharge_repository.dart';

class GetRechargeHistory implements UseCase<List<Recharge>, GetRechargeHistoryParams> {
  final RechargeRepository repository;

  GetRechargeHistory(this.repository);

  @override
  Future<Either<Failure, List<Recharge>>> call(GetRechargeHistoryParams params) async {
    return await repository.getRechargeHistory(
      meterId: params.meterId,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

class GetRechargeHistoryParams extends Equatable {
  final String meterId;
  final int page;
  final int pageSize;

  const GetRechargeHistoryParams({
    required this.meterId,
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [meterId, page, pageSize];
}
