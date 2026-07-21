import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/calculate_recharge_breakdown.dart';
import '../../domain/usecases/initiate_recharge.dart';
import '../../domain/usecases/apply_manual_code.dart';
import 'recharge_event.dart';
import 'recharge_state.dart';

class RechargeBloc extends Bloc<RechargeEvent, RechargeState> {
  final CalculateRechargeBreakdown calculateRechargeBreakdown;
  final InitiateRecharge initiateRecharge;
  final ApplyManualCode applyManualCode;

  RechargeBloc({
    required this.calculateRechargeBreakdown,
    required this.initiateRecharge,
    required this.applyManualCode,
  }) : super(RechargeInitialState()) {
    on<AmountInputChanged>(_onAmountInputChanged);
    on<SubmitRechargePayment>(_onSubmitRechargePayment);
    on<SubmitSTSCodeRecharge>(_onSubmitSTSCodeRecharge);
  }

  Future<void> _onAmountInputChanged(
    AmountInputChanged event,
    Emitter<RechargeState> emit,
  ) async {
    if (event.amount <= 0) {
      emit(RechargeInitialState());
      return;
    }

    final result = await calculateRechargeBreakdown(
      CalculateRechargeBreakdownParams(
        amount: event.amount,
        meterNumber: event.meterNumber,
      ),
    );

    result.fold(
      (failure) => emit(RechargeErrorState(failure.message)),
      (breakdown) => emit(RechargeBreakdownLoadedState(breakdown)),
    );
  }

  Future<void> _onSubmitRechargePayment(
    SubmitRechargePayment event,
    Emitter<RechargeState> emit,
  ) async {
    emit(RechargeProcessingState());

    final result = await initiateRecharge(
      InitiateRechargeParams(
        amount: event.amount,
        meterNumber: event.meterNumber,
        method: event.method,
      ),
    );

    result.fold(
      (failure) => emit(RechargeErrorState(failure.message)),
      (rechargeResult) => emit(RechargeSuccessState(rechargeResult)),
    );
  }

  Future<void> _onSubmitSTSCodeRecharge(
    SubmitSTSCodeRecharge event,
    Emitter<RechargeState> emit,
  ) async {
    emit(RechargeProcessingState());

    final result = await applyManualCode(
      ApplyManualCodeParams(
        code: event.code,
        meterNumber: event.meterNumber,
      ),
    );

    result.fold(
      (failure) => emit(RechargeErrorState(failure.message)),
      (rechargeResult) => emit(RechargeSuccessState(rechargeResult)),
    );
  }
}
