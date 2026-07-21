import 'package:equatable/equatable.dart';

abstract class RechargeEvent extends Equatable {
  const RechargeEvent();

  @override
  List<Object?> get props => [];
}

class AmountInputChanged extends RechargeEvent {
  final double amount;
  final String meterNumber;

  const AmountInputChanged({
    required this.amount,
    required this.meterNumber,
  });

  @override
  List<Object?> get props => [amount, meterNumber];
}

class TargetMeterSelected extends RechargeEvent {
  final String meterNumber;

  const TargetMeterSelected(this.meterNumber);

  @override
  List<Object?> get props => [meterNumber];
}

class SubmitRechargePayment extends RechargeEvent {
  final double amount;
  final String meterNumber;
  final String method;

  const SubmitRechargePayment({
    required this.amount,
    required this.meterNumber,
    required this.method,
  });

  @override
  List<Object?> get props => [amount, meterNumber, method];
}

class SubmitSTSCodeRecharge extends RechargeEvent {
  final String code;
  final String meterNumber;

  const SubmitSTSCodeRecharge({
    required this.code,
    required this.meterNumber,
  });

  @override
  List<Object?> get props => [code, meterNumber];
}
