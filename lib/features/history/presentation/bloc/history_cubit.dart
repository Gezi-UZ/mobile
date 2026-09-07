import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../recharge/domain/entities/recharge.dart';
import '../../../recharge/domain/entities/dashboard_stats.dart';
import '../../../recharge/domain/usecases/get_recharge_history.dart';
import '../../../recharge/domain/usecases/get_dashboard_stats.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetRechargeHistory getRechargeHistory;
  final GetDashboardStats getDashboardStats;

  HistoryCubit({
    required this.getRechargeHistory,
    required this.getDashboardStats,
  }) : super(HistoryInitial());

  Future<void> fetchHistoryData(String meterId, String period) async {
    emit(HistoryLoading());

    try {
      final historyResult = await getRechargeHistory(GetRechargeHistoryParams(
        meterId: meterId,
        page: 1,
        pageSize: 50,
      ));

      final statsResult = await getDashboardStats(GetDashboardStatsParams(
        meterId: meterId,
        period: period,
      ));

      List<Recharge> recharges = [];
      DashboardStats? stats;
      String? errorMessage;

      historyResult.fold(
        (failure) => errorMessage = failure.message,
        (data) => recharges = data,
      );

      statsResult.fold(
        (failure) => errorMessage ??= failure.message,
        (data) => stats = data,
      );

      if (errorMessage != null && recharges.isEmpty) {
        emit(HistoryError(errorMessage!));
      } else {
        emit(HistoryLoaded(
          recharges: recharges,
          stats: stats,
        ));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
