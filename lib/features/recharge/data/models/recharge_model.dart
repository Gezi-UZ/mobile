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
    // O backend envia timestamps em UTC sem sufixo 'Z'. Forçar parse como UTC e converter para local.
    DateTime parseDate(dynamic raw) {
      if (raw == null) return DateTime.now();
      final s = raw.toString();
      final utcStr = (s.endsWith('Z') || s.contains('+')) ? s : '${s}Z';
      return (DateTime.tryParse(utcStr) ?? DateTime.now()).toLocal();
    }

    return RechargeModel(
      id: json['recharge_id'] ?? json['id'] ?? '',
      meterId: json['meter_id'] ?? '',
      amountMzn: double.tryParse(json['amount_mzn']?.toString() ?? '') ?? 0.0,
      creditKwh: double.tryParse(json['credit_kwh']?.toString() ?? '') ?? 0.0,
      status: json['status'] ?? json['payment_status'] ?? 'UNKNOWN',
      createdAt: parseDate(json['created_at'] ?? json['recharged_at'] ?? json['applied_at']),
      token: json['token_sts']?.toString() ?? json['token']?.toString(),
      paymentMethod: json['payment_method'],
      paymentReference: json['referencia_mpesa'] ?? json['payment_reference'],
      rechargeType: json['recharge_type'] ?? 'SELF',
      otherPartyName: json['other_party_name'],
      meterNumber: json['meter_number'] ?? json['meter_serial_number'],
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
