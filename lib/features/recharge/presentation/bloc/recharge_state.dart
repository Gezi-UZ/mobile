import 'package:equatable/equatable.dart';
import '../../domain/entities/recharge_breakdown.dart';
import '../../domain/entities/recharge_result.dart';

abstract class RechargeState extends Equatable {
  const RechargeState();

  @override
  List<Object?> get props => [];
}

class RechargeInitialState extends RechargeState {}

class RechargeBreakdownLoadedState extends RechargeState {
  final RechargeBreakdown breakdown;

  const RechargeBreakdownLoadedState(this.breakdown);

  @override
  List<Object?> get props => [breakdown];
}

class RechargeProcessingState extends RechargeState {}

class RechargeSuccessState extends RechargeState {
  final RechargeResult result;

  const RechargeSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}

class RechargeErrorState extends RechargeState {
  final String message;

  const RechargeErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
