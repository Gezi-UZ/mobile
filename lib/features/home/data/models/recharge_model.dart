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
    super.paymentReference,
  });

  factory RechargeModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.now();
    final dateStr = json['recharged_at'] ?? json['created_at'] ?? json['applied_at'];
    if (dateStr != null) {
      // O backend envia timestamps em UTC sem sufixo 'Z'. Forçar parse como UTC e converter para local.
      final s = dateStr.toString();
      final utcStr = (s.endsWith('Z') || s.contains('+')) ? s : '${s}Z';
      parsedDate = (DateTime.tryParse(utcStr) ?? DateTime.now()).toLocal();
    }

    return RechargeModel(
      id: json['id'] as String? ?? json['recharge_id'] as String? ?? '',
      kwhAmount: (json['kwh_amount'] as num?)?.toDouble() ??
          (json['credit_kwh'] as num?)?.toDouble() ??
          (json['kwh'] as num?)?.toDouble() ??
          0.0,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ??
          (json['amount_mzn'] as num?)?.toDouble() ??
          (json['amount'] as num?)?.toDouble() ??
          0.0,
      currency: json['currency'] as String? ?? 'MT',
      rechargedAt: parsedDate,
      status: _parseStatus((json['status'] ?? json['payment_status'])?.toString() ?? ''),
      meterAlias: json['meter_alias'] as String? ?? json['label'] as String?,
      meterSerialNumber: (json['meter_serial_number'] ??
              json['meter_number'] ??
              json['serial_number'] ??
              json['numero_serie'] ??
              json['meter_id'])
          ?.toString() ??
          '',
      isMyMeter: json['is_my_meter'] as bool? ?? true,
      paymentMethod: json['payment_method'] as String? ??
          json['provider'] as String? ??
          'M-Pesa',
      paymentReference: json['referencia_mpesa'] as String? ?? json['payment_reference'] as String?,
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
        'referencia_mpesa': paymentReference,
      };

  static RechargeStatus _parseStatus(String raw) {
    final upper = raw.toUpperCase();
    if (upper == 'SUCCESS' ||
        upper == 'CONFIRMED' ||
        upper == 'CONCLUIDA' ||
        upper == 'ACK_RECEIVED') {
      return RechargeStatus.success;
    }
    if (upper == 'FAILED' || 
        upper == 'FAIL' || 
        upper == 'FALHADA' || 
        upper == 'FALHOU' || 
        upper == 'ERROR' || 
        upper == 'ERRO' || 
        upper == 'REJECTED' || 
        upper == 'CANCELLED' || 
        upper == 'REFUNDED') {
      return RechargeStatus.failed;
    }
    return RechargeStatus.pending;
  }
}
