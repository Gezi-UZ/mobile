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
      meterNumber: json['meter_number'] ?? '',
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      valEnergia: (json['val_energia'] ?? 0.0).toDouble(),
      iva: (json['iva'] ?? 0.0).toDouble(),
      dividaPaga: (json['divida_paga'] ?? 0.0).toDouble(),
      txRadio: (json['tx_radio'] ?? 0.0).toDouble(),
      txLixo: (json['tx_lixo'] ?? 0.0).toDouble(),
      calculatedKwh: (json['calculated_kwh'] ?? 0.0).toDouble(),
      isFirstPurchaseOfMonth: json['is_first_purchase_of_month'] ?? true,
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
