import 'package:equatable/equatable.dart';

class Recharge extends Equatable {
  final String id;
  final String meterId;
  final double amountMzn;
  final double creditKwh;
  final String status;
  final DateTime createdAt;
  final String? token;
  final String? paymentMethod;
  final String? paymentReference;
  final String rechargeType;
  final String? otherPartyName;

  const Recharge({
    required this.id,
    required this.meterId,
    required this.amountMzn,
    required this.creditKwh,
    required this.status,
    required this.createdAt,
    this.token,
    this.paymentMethod,
    this.paymentReference,
    this.rechargeType = 'SELF',
    this.otherPartyName,
  });

  @override
  List<Object?> get props => [id, meterId, amountMzn, creditKwh, status, createdAt, token, paymentMethod, paymentReference, rechargeType, otherPartyName];
}
