import 'package:equatable/equatable.dart';

class RechargeBreakdown extends Equatable {
  final String meterNumber;
  final double totalAmount;
  final double valEnergia;
  final double iva;
  final double dividaPaga;
  final double txRadio;
  final double txLixo;
  final double calculatedKwh;
  final bool isFirstPurchaseOfMonth;

  const RechargeBreakdown({
    required this.meterNumber,
    required this.totalAmount,
    required this.valEnergia,
    required this.iva,
    required this.dividaPaga,
    required this.txRadio,
    required this.txLixo,
    required this.calculatedKwh,
    required this.isFirstPurchaseOfMonth,
  });

  @override
  List<Object?> get props => [
        meterNumber,
        totalAmount,
        valEnergia,
        iva,
        dividaPaga,
        txRadio,
        txLixo,
        calculatedKwh,
        isFirstPurchaseOfMonth,
      ];
}
