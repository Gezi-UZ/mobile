import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/recharge_breakdown.dart';
import '../../domain/entities/recharge.dart';
import '../../domain/usecases/apply_manual_code.dart';
import '../../domain/usecases/calculate_recharge_breakdown.dart';
import '../../domain/usecases/initiate_recharge.dart';

part 'recharge_event.dart';
part 'recharge_state.dart';

class RechargeBloc extends Bloc<RechargeEvent, RechargeState> {
  final CalculateRechargeBreakdown calculateRechargeBreakdown;
  final InitiateRecharge initiateRecharge;
  final ApplyManualCode applyManualCode;

  RechargeBloc({
    required this.calculateRechargeBreakdown,
    required this.initiateRecharge,
    required this.applyManualCode,
  }) : super(RechargeInitial()) {
    on<CalculateBreakdownEvent>(_onCalculateBreakdown);
    on<InitiateRechargeEvent>(_onInitiateRecharge);
    on<ApplyCodeEvent>(_onApplyCode);
  }

  Future<void> _onCalculateBreakdown(
    CalculateBreakdownEvent event,
    Emitter<RechargeState> emit,
  ) async {
    emit(RechargeLoading());
    final result = await calculateRechargeBreakdown(
      CalculateRechargeBreakdownParams(
        amount: event.amount,
        meterId: event.meterId,
      ),
    );
    result.fold(
      (failure) => emit(RechargeError(failure.message)),
      (breakdown) => emit(RechargeBreakdownLoaded(breakdown)),
    );
  }

  Future<void> _onInitiateRecharge(
    InitiateRechargeEvent event,
    Emitter<RechargeState> emit,
  ) async {
    emit(RechargeLoading());
    final result = await initiateRecharge(
      InitiateRechargeParams(
        amount: event.amount,
        meterId: event.meterId,
        method: event.method,
      ),
    );
    result.fold(
      (failure) => emit(RechargeError(failure.message)),
      (rechargeResult) => emit(RechargeSuccess(rechargeResult)),
    );
  }

  Future<void> _onApplyCode(
    ApplyCodeEvent event,
    Emitter<RechargeState> emit,
  ) async {
    emit(RechargeLoading());
    final result = await applyManualCode(
      ApplyManualCodeParams(
        code: event.code,
        meterId: event.meterId,
      ),
    );
    result.fold(
      (failure) => emit(RechargeError(failure.message)),
      (rechargeResult) => emit(RechargeSuccess(rechargeResult)),
    );
  }
}
