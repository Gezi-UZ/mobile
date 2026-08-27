import '../models/recharge_model.dart';
import '../../domain/entities/meter_balance.dart';
import '../../domain/entities/recharge.dart';
import '../../../meter/presentation/pages/meter_list_page.dart';

abstract class HomeRemoteDataSource {
  /// Obtém o saldo do contador a partir do servidor remoto.
  Future<MeterBalance> getMeterBalance();

  /// Obtém as últimas [limit] recargas do utilizador.
  Future<List<Recharge>> getRecentRecharges({int limit = 5});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  // TODO: Injectar cliente HTTP (ex: Dio) ou Supabase client quando a API
  // estiver pronta. Por agora retorna dados stub para desbloquear o desenvolvimento.

  @override
  Future<MeterBalance> getMeterBalance() async {
    // Stub — substituir pela chamada real à API.
    final primaryMeter = MeterListPage.mockMeters.firstWhere(
      (m) => m.isPrimary,
      orElse: () => MeterListPage.mockMeters.first,
    );

    return MeterBalance(
      kwhBalance: primaryMeter.kwhBalance,
      meterId: primaryMeter.serialNumber,
      isOnline: primaryMeter.isOnline,
      lastSyncAt: DateTime.now(),
      isLowBalance: primaryMeter.kwhBalance < 5.0,
    );
  }

  @override
  Future<List<Recharge>> getRecentRecharges({int limit = 5}) async {
    // Stub — substituir pela chamada real à API.
    final now = DateTime.now();
    final stubs = [
      RechargeModel(
        id: 'RCH-001',
        kwhAmount: 50.0,
        paidAmount: 250.00,
        currency: 'MT',
        rechargedAt: now.subtract(const Duration(hours: 2)),
        status: RechargeStatus.success,
        meterAlias: 'Casa principal',
        meterSerialNumber: 'CR123456792',
        isMyMeter: true,
        paymentMethod: 'M-Pesa',
      ),
      RechargeModel(
        id: 'RCH-002',
        kwhAmount: 20.0,
        paidAmount: 100.00,
        currency: 'MT',
        rechargedAt: now.subtract(const Duration(days: 1)),
        status: RechargeStatus.success,
        meterSerialNumber: 'CR987654342',
        isMyMeter: false,
        paymentMethod: 'e-Mola',
      ),
      RechargeModel(
        id: 'RCH-003',
        kwhAmount: 100.0,
        paidAmount: 500.00,
        currency: 'MT',
        rechargedAt: now.subtract(const Duration(days: 3)),
        status: RechargeStatus.success,
        meterAlias: 'Escritório',
        meterSerialNumber: 'CR111222333',
        isMyMeter: true,
        paymentMethod: 'Conta Bancária',
      ),
      RechargeModel(
        id: 'RCH-004',
        kwhAmount: 30.0,
        paidAmount: 150.00,
        currency: 'MT',
        rechargedAt: now.subtract(const Duration(days: 7)),
        status: RechargeStatus.failed,
        meterSerialNumber: 'CR444555666',
        isMyMeter: false,
        paymentMethod: 'M-Pesa',
      ),
      RechargeModel(
        id: 'RCH-005',
        kwhAmount: 75.0,
        paidAmount: 375.00,
        currency: 'MT',
        rechargedAt: now.subtract(const Duration(days: 14)),
        status: RechargeStatus.success,
        meterAlias: 'Casa de Férias',
        meterSerialNumber: 'CR777888999',
        isMyMeter: true,
        paymentMethod: 'M-Pesa',
      ),
    ];
    return stubs.take(limit).toList();
  }
}
