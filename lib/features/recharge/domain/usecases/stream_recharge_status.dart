import '../entities/recharge.dart';
import '../repositories/recharge_repository.dart';

class StreamRechargeStatus {
  final RechargeRepository repository;

  StreamRechargeStatus(this.repository);

  Stream<Recharge> call(String rechargeId) {
    return repository.streamRechargeStatus(rechargeId);
  }
}
