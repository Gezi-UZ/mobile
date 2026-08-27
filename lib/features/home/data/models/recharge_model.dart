import 'package:gezi/features/home/domain/entities/recharge.dart';

class RechargeModel extends Recharge {
  const RechargeModel({
    required super.id,
    required super.kwhAmount,
    required super.paidAmount,
    required super.currency,
    required super.rechargedAt,
    required super.status,
    super.meterAlias,
    required super.meterSerialNumber,
    required super.isMyMeter,
    required super.paymentMethod,
  });

  factory RechargeModel.fromJson(Map<String, dynamic> json) {
    return RechargeModel(
      id: json['id'] as String,
      kwhAmount: (json['kwh_amount'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num).toDouble(),
      currency: json['currency'] as String,
      rechargedAt: DateTime.parse(json['recharged_at'] as String),
      status: _parseStatus(json['status'] as String),
      meterAlias: json['meter_alias'] as String?,
      meterSerialNumber: json['meter_serial_number'] as String,
      isMyMeter: json['is_my_meter'] as bool? ?? false,
      paymentMethod: json['payment_method'] as String? ?? 'M-Pesa',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kwh_amount': kwhAmount,
        'paid_amount': paidAmount,
        'currency': currency,
        'recharged_at': rechargedAt.toIso8601String(),
        'status': status.name,
        'meter_alias': meterAlias,
        'meter_serial_number': meterSerialNumber,
        'is_my_meter': isMyMeter,
        'payment_method': paymentMethod,
      };

  static RechargeStatus _parseStatus(String raw) {
    return RechargeStatus.values.firstWhere(
      (s) => s.name == raw,
      orElse: () => RechargeStatus.pending,
    );
  }
}
