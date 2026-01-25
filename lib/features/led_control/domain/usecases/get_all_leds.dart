import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/led_repository.dart';

/// Use case for getting all LED states
class GetAllLeds implements UseCase<Map<String, bool>, NoParams> {
  final LedRepository repository;

  GetAllLeds(this.repository);

  @override
  Future<Either<Failure, Map<String, bool>>> call(NoParams params) async {
    return await repository.getAllLeds();
  }
}