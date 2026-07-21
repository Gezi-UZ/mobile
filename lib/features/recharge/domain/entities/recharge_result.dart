import 'package:equatable/equatable.dart';

class RechargeResult extends Equatable {
  final String transactionId;
  final String meterNumber;
  final double amount;
  final double kwh;
  final String method;
  final DateTime timestamp;
  final String status;

  const RechargeResult({
    required this.transactionId,
    required this.meterNumber,
    required this.amount,
    required this.kwh,
    required this.method,
    required this.timestamp,
    required this.status,
  });

  @override
  List<Object?> get props => [
        transactionId,
        meterNumber,
        amount,
        kwh,
        method,
        timestamp,
        status,
      ];
}
