import 'package:gezi/features/home/domain/entities/recharge.dart';

class RechargeModel extends Recharge {
  const RechargeModel({
    required super.id,
    required super.kwhAmount,
    required super.paidAmount,
    required super.currency,
    required super.rechargedAt,
    required super.status,
  });

  factory RechargeModel.fromJson(Map<String, dynamic> json) {
    return RechargeModel(
      id: json['id'] as String,
      kwhAmount: (json['kwh_amount'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num).toDouble(),
      currency: json['currency'] as String,
      rechargedAt: DateTime.parse(json['recharged_at'] as String),
      status: _parseStatus(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kwh_amount': kwhAmount,
        'paid_amount': paidAmount,
        'currency': currency,
        'recharged_at': rechargedAt.toIso8601String(),
        'status': status.name,
      };

  static RechargeStatus _parseStatus(String raw) {
    return RechargeStatus.values.firstWhere(
      (s) => s.name == raw,
      orElse: () => RechargeStatus.pending,
    );
  }
}
