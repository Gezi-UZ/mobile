import '../models/recharge_model.dart';
import '../../domain/entities/meter_balance.dart';
import '../../domain/entities/recharge.dart';

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
    return MeterBalance(
      kwhBalance: 3.2,
      meterId: '12345678901',
      isOnline: true,
      lastSyncAt: DateTime.now(),
      isLowBalance: true,
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
        currency: 'MZN',
        rechargedAt: now.subtract(const Duration(hours: 2)),
        status: RechargeStatus.success,
      ),
      RechargeModel(
        id: 'RCH-002',
        kwhAmount: 20.0,
        paidAmount: 100.00,
        currency: 'MZN',
        rechargedAt: now.subtract(const Duration(days: 1)),
        status: RechargeStatus.success,
      ),
      RechargeModel(
        id: 'RCH-003',
        kwhAmount: 100.0,
        paidAmount: 500.00,
        currency: 'MZN',
        rechargedAt: now.subtract(const Duration(days: 3)),
        status: RechargeStatus.success,
      ),
      RechargeModel(
        id: 'RCH-004',
        kwhAmount: 30.0,
        paidAmount: 150.00,
        currency: 'MZN',
        rechargedAt: now.subtract(const Duration(days: 7)),
        status: RechargeStatus.failed,
      ),
      RechargeModel(
        id: 'RCH-005',
        kwhAmount: 75.0,
        paidAmount: 375.00,
        currency: 'MZN',
        rechargedAt: now.subtract(const Duration(days: 14)),
        status: RechargeStatus.success,
      ),
    ];
    return stubs.take(limit).toList();
  }
}
