import 'package:equatable/equatable.dart';

/// Representa uma recarga efectuada no contador.
class Recharge extends Equatable {
  final String id;
  final double kwhAmount;
  final double paidAmount;
  final String currency;
  final DateTime rechargedAt;
  final RechargeStatus status;

  const Recharge({
    required this.id,
    required this.kwhAmount,
    required this.paidAmount,
    required this.currency,
    required this.rechargedAt,
    required this.status,
  });

  @override
  List<Object?> get props => [id, kwhAmount, paidAmount, currency, rechargedAt, status];
}

enum RechargeStatus { success, pending, failed }
