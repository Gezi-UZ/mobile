import '../../domain/entities/recharge_breakdown.dart';

class RechargeBreakdownModel extends RechargeBreakdown {
  const RechargeBreakdownModel({
    required super.meterNumber,
    required super.totalAmount,
    required super.valEnergia,
    required super.iva,
    required super.dividaPaga,
    required super.txRadio,
    required super.txLixo,
    required super.calculatedKwh,
    required super.isFirstPurchaseOfMonth,
  });

  factory RechargeBreakdownModel.fromJson(Map<String, dynamic> json) {
    return RechargeBreakdownModel(

      meterNumber: json['meter_number'] as String? ?? json['meter_id'] as String? ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ??
          (json['montante_total'] as num?)?.toDouble() ??
          (json['amount_mzn'] as num?)?.toDouble() ??
          0.0,
      valEnergia: (json['val_energia'] as num?)?.toDouble() ?? 0.0,
      iva: (json['iva'] as num?)?.toDouble() ?? 0.0,
      dividaPaga: (json['divida_paga'] as num?)?.toDouble() ?? 0.0,
      txRadio: (json['tx_radio'] as num?)?.toDouble() ?? 0.0,
      txLixo: (json['tx_lixo'] as num?)?.toDouble() ?? 0.0,
      calculatedKwh: (json['calculated_kwh'] as num?)?.toDouble() ??
          (json['kwh_calculado'] as num?)?.toDouble() ??
          (json['estimated_kwh'] as num?)?.toDouble() ??
          0.0,
      isFirstPurchaseOfMonth: json['is_first_purchase_of_month'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meter_number': meterNumber,
      'total_amount': totalAmount,
      'val_energia': valEnergia,
      'iva': iva,
      'divida_paga': dividaPaga,
      'tx_radio': txRadio,
      'tx_lixo': txLixo,
      'calculated_kwh': calculatedKwh,
      'is_first_purchase_of_month': isFirstPurchaseOfMonth,
    };
  }
}
