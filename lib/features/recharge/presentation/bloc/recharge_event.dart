part of 'recharge_bloc.dart';

abstract class RechargeEvent extends Equatable {
  const RechargeEvent();

  @override
  List<Object?> get props => [];
}

class CalculateBreakdownEvent extends RechargeEvent {
  final double amount;
  final String meterId;

  const CalculateBreakdownEvent({
    required this.amount,
    required this.meterId,
  });

  @override
  List<Object?> get props => [amount, meterId];
}

class InitiateRechargeEvent extends RechargeEvent {
  final double amount;
  final String meterId;
  final String method;

  const InitiateRechargeEvent({
    required this.amount,
    required this.meterId,
    required this.method,
  });

  @override
  List<Object?> get props => [amount, meterId, method];
}

class ApplyCodeEvent extends RechargeEvent {
  final String code;
  final String meterId;

  const ApplyCodeEvent({
    required this.code,
    required this.meterId,
  });

  @override
  List<Object?> get props => [code, meterId];
}
