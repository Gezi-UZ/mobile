import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/recharge_breakdown.dart';
import '../../domain/entities/recharge.dart';
import '../../domain/usecases/apply_manual_code.dart';
import '../../domain/usecases/calculate_recharge_breakdown.dart';
import '../../domain/usecases/initiate_recharge.dart';
import '../../domain/usecases/stream_recharge_status.dart';

part 'recharge_event.dart';
part 'recharge_state.dart';

class RechargeBloc extends Bloc<RechargeEvent, RechargeState> {
  final CalculateRechargeBreakdown calculateRechargeBreakdown;
  final InitiateRecharge initiateRecharge;
  final ApplyManualCode applyManualCode;
  final StreamRechargeStatus streamRechargeStatus;

  RechargeBloc({
    required this.calculateRechargeBreakdown,
    required this.initiateRecharge,
    required this.applyManualCode,
    required this.streamRechargeStatus,
  }) : super(RechargeInitial()) {
    on<CalculateBreakdownEvent>(_onCalculateBreakdown);
    on<InitiateRechargeEvent>(_onInitiateRecharge);
    on<ApplyCodeEvent>(_onApplyCode);
    on<StreamRechargeStatusEvent>(_onStreamRechargeStatus);
    on<ForceRechargeSuccessEvent>(_onForceRechargeSuccess);
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
        phone: event.phone,
      ),
    );
    result.fold(
      (failure) => emit(RechargeError(failure.message)),
      (rechargeResult) => emit(RechargeInitiated(rechargeResult)),
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
      ),
    );
    result.fold(
      (failure) => emit(RechargeError(failure.message)),
      (rechargeResult) => emit(RechargeSuccess(rechargeResult)),
    );
  }

  Future<void> _onStreamRechargeStatus(
    StreamRechargeStatusEvent event,
    Emitter<RechargeState> emit,
  ) async {
    bool hasEmittedSuccess = false;

    await emit.forEach<Recharge>(
      streamRechargeStatus(event.rechargeId),
      onData: (recharge) {
        if (hasEmittedSuccess) return RechargeSuccess(recharge);

        if (recharge.status == 'FAILED') {
          return RechargeError('Falha no pagamento');
        }
        if (recharge.status == 'CONCLUIDA' || 
            recharge.status == 'SUCCESS' || 
            recharge.status == 'ACK_RECEIVED' ||
            recharge.status == 'CONFIRMED_NO_DEVICE') {
          hasEmittedSuccess = true;
          return RechargeSuccess(recharge);
        }

        if (recharge.status == 'MQTT_SENT') {
          // Se recebermos MQTT_SENT, damos 4 segundos ao dispositivo para enviar o ACK.
          // Se nao enviar, forcamos o sucesso para que o utilizador veja o recibo com o token STS e tente manualmente.
          Future.delayed(const Duration(seconds: 4), () {
            if (!isClosed && state is RechargeStatusUpdated) {
              final currentState = state as RechargeStatusUpdated;
              if (currentState.recharge.status == 'MQTT_SENT') {
                add(ForceRechargeSuccessEvent(currentState.recharge));
              }
            }
          });
          return RechargeStatusUpdated(recharge);
        }

        return RechargeStatusUpdated(recharge);
      },
      onError: (error, stackTrace) => RechargeError(error.toString()),
    );
  }

  void _onForceRechargeSuccess(
    ForceRechargeSuccessEvent event,
    Emitter<RechargeState> emit,
  ) {
    emit(RechargeSuccess(event.recharge));
  }
}
