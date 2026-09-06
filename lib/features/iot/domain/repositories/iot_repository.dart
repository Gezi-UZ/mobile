import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class IotRepository {
  Future<Either<Failure, void>> sendCommand({
    required String meterId,
    required String commandType,
    Map<String, dynamic>? payload,
  });
}
