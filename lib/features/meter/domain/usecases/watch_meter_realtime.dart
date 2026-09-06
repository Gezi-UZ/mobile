import '../entities/meter.dart';
import '../repositories/meter_repository.dart';

class WatchMeterRealtime {
  final MeterRepository repository;

  WatchMeterRealtime(this.repository);

  Stream<Meter> call(String meterId) {
    return repository.watchMeterStatus(meterId);
  }
}
