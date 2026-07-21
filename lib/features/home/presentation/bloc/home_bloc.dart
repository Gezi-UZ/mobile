import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/features/home/domain/entities/meter_balance.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart';
import 'package:gezi/features/home/domain/usecases/get_meter_balance.dart';
import 'package:gezi/features/home/domain/usecases/get_recent_recharges.dart';
import 'package:gezi/core/errors/failures.dart';
import 'home_state.dart';
import 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMeterBalance getMeterBalance;
  final GetRecentRecharges getRecentRecharges;

  HomeBloc({
    required this.getMeterBalance,
    required this.getRecentRecharges,
  }) : super(HomeInitial()) {
    on<HomeDashboardLoadRequested>(_onDashboardLoadRequest);
  }

  Future<void> _onDashboardLoadRequest(
    HomeDashboardLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    // Dispara os dois pedidos em paralelo, mantendo os tipos.
    final Future<Either<Failure, MeterBalance>> balanceFuture = getMeterBalance();
    final Future<Either<Failure, List<Recharge>>> rechargesFuture = getRecentRecharges();

    final Either<Failure, MeterBalance> balanceResult = await balanceFuture;
    final Either<Failure, List<Recharge>> rechargesResult = await rechargesFuture;

    balanceResult.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (balance) {
        // Recargas podem falhar silenciosamente — usa lista vazia como fallback.
        final List<Recharge> recharges = rechargesResult.fold((_) => [], (r) => r);
        emit(HomeLoaded(
          meterBalance: balance,
          notificationCount: 2, // use case futuro
          recentRecharges: recharges,
        ));
      },
    );
  }
}


