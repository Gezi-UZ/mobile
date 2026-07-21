import '../models/recharge_breakdown_model.dart';
import '../models/recharge_result_model.dart';

abstract class RechargeRemoteDataSource {
  Future<RechargeBreakdownModel> calculateBreakdown({
    required double amount,
    required String meterNumber,
  });

  Future<RechargeResultModel> initiateRecharge({
    required double amount,
    required String meterNumber,
    required String method,
  });

  Future<RechargeResultModel> applyCode({
    required String code,
    required String meterNumber,
  });
}

class RechargeRemoteDataSourceImpl implements RechargeRemoteDataSource {
  @override
  Future<RechargeBreakdownModel> calculateBreakdown({
    required double amount,
    required String meterNumber,
  }) async {
    // Cálculo stub baseado nas regras tarifárias da EDM
    const bool isFirstPurchase = true;
    const double ratePerKwh = 7.64;
    final double txLixo = (isFirstPurchase && amount >= 100) ? 100.0 : 0.0;
    const double txRadio = 0.0;
    const double dividaPaga = 0.0;

    final double remainingAfterFees = (amount - txLixo - txRadio - dividaPaga).clamp(0.0, double.infinity);
    final double valEnergia = remainingAfterFees / 1.16;
    final double iva = remainingAfterFees - valEnergia;
    final double calculatedKwh = remainingAfterFees / ratePerKwh;

    return RechargeBreakdownModel(
      meterNumber: meterNumber,
      totalAmount: amount,
      valEnergia: valEnergia,
      iva: iva,
      dividaPaga: dividaPaga,
      txRadio: txRadio,
      txLixo: txLixo,
      calculatedKwh: calculatedKwh,
      isFirstPurchaseOfMonth: isFirstPurchase,
    );
  }

  @override
  Future<RechargeResultModel> initiateRecharge({
    required double amount,
    required String meterNumber,
    required String method,
  }) async {
    final breakdown = await calculateBreakdown(amount: amount, meterNumber: meterNumber);
    return RechargeResultModel(
      transactionId: 'REF-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      meterNumber: meterNumber,
      amount: amount,
      kwh: breakdown.calculatedKwh,
      method: method,
      timestamp: DateTime.now(),
      status: 'Concluído',
    );
  }

  @override
  Future<RechargeResultModel> applyCode({
    required String code,
    required String meterNumber,
  }) async {
    return RechargeResultModel(
      transactionId: 'REF-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      meterNumber: meterNumber,
      amount: 0.0,
      kwh: 150.0,
      method: 'Código STS',
      timestamp: DateTime.now(),
      status: 'Concluído',
    );
  }
}
