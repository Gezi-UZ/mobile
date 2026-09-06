import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/dashboard_stats.dart';
import '../repositories/recharge_repository.dart';

class GetDashboardStats implements UseCase<DashboardStats, GetDashboardStatsParams> {
  final RechargeRepository repository;

  GetDashboardStats(this.repository);

  @override
  Future<Either<Failure, DashboardStats>> call(GetDashboardStatsParams params) async {
    return await repository.getDashboardStats(
      meterId: params.meterId,
      period: params.period,
    );
  }
}

class GetDashboardStatsParams extends Equatable {
  final String meterId;
  final String period;

  const GetDashboardStatsParams({
    required this.meterId,
    required this.period,
  });

  @override
  List<Object?> get props => [meterId, period];
}
