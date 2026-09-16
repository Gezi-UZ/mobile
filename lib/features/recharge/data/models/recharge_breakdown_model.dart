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
    final map = (json['breakdown'] is Map<String, dynamic>)
        ? json['breakdown'] as Map<String, dynamic>
        : json;

    double parseNum(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return RechargeBreakdownModel(
      meterNumber:
          json['meter_number'] as String? ??
          json['meter_id'] as String? ??
          map['meter_number'] as String? ??
          '',
      totalAmount: parseNum(
        map['total_amount'] ??
            map['montante_total'] ??
            map['amount_mzn'] ??
            json['amount_mzn'],
      ),
      valEnergia: parseNum(map['val_energia']),
      iva: parseNum(map['iva']),
      dividaPaga: parseNum(map['divida_paga']),
      txRadio: parseNum(map['tx_radio']),
      txLixo: parseNum(map['tx_lixo']),
      calculatedKwh: parseNum(
        map['calculated_kwh'] ??
            map['kwh_calculado'] ??
            map['estimated_kwh'] ??
            json['estimated_kwh'],
      ),
      isFirstPurchaseOfMonth:
          map['is_primeira_compra_mes'] as bool? ??
          map['is_first_purchase_of_month'] as bool? ??
          json['is_primeira_compra_mes'] as bool? ??
          json['is_first_purchase_of_month'] as bool? ??
          false,
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
