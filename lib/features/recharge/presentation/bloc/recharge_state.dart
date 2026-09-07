part of 'recharge_bloc.dart';

abstract class RechargeState extends Equatable {
  const RechargeState();
  
  @override
  List<Object?> get props => [];
}

class RechargeInitial extends RechargeState {}

class RechargeLoading extends RechargeState {}

class RechargeBreakdownLoaded extends RechargeState {
  final RechargeBreakdown breakdown;

  const RechargeBreakdownLoaded(this.breakdown);

  @override
  List<Object?> get props => [breakdown];
}

class RechargeSuccess extends RechargeState {
  final Recharge recharge;

  const RechargeSuccess(this.recharge);

  @override
  List<Object?> get props => [recharge];
}

class RechargeInitiated extends RechargeState {
  final Recharge recharge;

  const RechargeInitiated(this.recharge);

  @override
  List<Object?> get props => [recharge];
}

class RechargeStatusUpdated extends RechargeState {
  final Recharge recharge;

  const RechargeStatusUpdated(this.recharge);

  @override
  List<Object?> get props => [recharge];
}

class RechargeError extends RechargeState {
  final String message;

  const RechargeError(this.message);

  @override
  List<Object?> get props => [message];
}
