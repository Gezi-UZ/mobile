import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/meter_repository.dart';

class PingMeter extends UseCase<bool, String> {
  final MeterRepository repository;

  PingMeter(this.repository);

  @override
  Future<Either<Failure, bool>> call(String meterId) async {
    return await repository.pingMeter(meterId);
  }
}
