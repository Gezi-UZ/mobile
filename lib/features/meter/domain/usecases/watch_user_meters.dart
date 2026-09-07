import '../entities/meter.dart';
import '../repositories/meter_repository.dart';

class WatchUserMeters {
  final MeterRepository repository;

  WatchUserMeters(this.repository);

  Stream<List<Meter>> call(String userId) {
    return repository.watchUserMeters(userId);
  }
}

