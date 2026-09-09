import '../../domain/entities/recharge.dart';

class RechargeModel extends Recharge {
  const RechargeModel({
    required super.id,
    required super.meterId,
    required super.amountMzn,
    required super.creditKwh,
    required super.status,
    required super.createdAt,
    super.token,
    super.paymentMethod,
    super.paymentReference,
    super.rechargeType = 'SELF',
    super.otherPartyName,
    super.meterNumber,
  });

  factory RechargeModel.fromJson(Map<String, dynamic> json) {
    return RechargeModel(
      id: json['recharge_id'] ?? json['id'] ?? '',
      meterId: json['meter_id'] ?? '',
      amountMzn: (json['amount_mzn'] as num?)?.toDouble() ?? 0.0,
      creditKwh: (json['credit_kwh'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? json['payment_status'] ?? 'UNKNOWN',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      token: json['token'],
      paymentMethod: json['payment_method'],
      paymentReference: json['referencia_mpesa'] ?? json['payment_reference'],
      rechargeType: json['recharge_type'] ?? 'SELF',
      otherPartyName: json['other_party_name'],
      meterNumber: json['meter_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recharge_id': id,
      'meter_id': meterId,
      'amount_mzn': amountMzn,
      'credit_kwh': creditKwh,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'token': token,
      'payment_method': paymentMethod,
      'referencia_mpesa': paymentReference,
      'recharge_type': rechargeType,
      'other_party_name': otherPartyName,
      'meter_number': meterNumber,
    };
  }
}
