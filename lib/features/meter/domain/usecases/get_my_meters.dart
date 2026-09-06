import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/meter.dart';
import '../repositories/meter_repository.dart';

class GetMyMeters implements UseCase<List<Meter>, NoParams> {
  final MeterRepository repository;

  GetMyMeters(this.repository);

  @override
  Future<Either<Failure, List<Meter>>> call(NoParams params) async {
    return await repository.getMeters();
  }
}
