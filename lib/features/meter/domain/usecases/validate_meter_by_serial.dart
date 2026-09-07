import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/meter.dart';
import '../repositories/meter_repository.dart';

class ValidateMeterBySerial implements UseCase<Meter, ValidateMeterParams> {
  final MeterRepository repository;

  ValidateMeterBySerial(this.repository);

  @override
  Future<Either<Failure, Meter>> call(ValidateMeterParams params) async {
    return await repository.validateMeterBySerial(params.serialNumber);
  }
}

class ValidateMeterParams extends Equatable {
  final String serialNumber;

  const ValidateMeterParams({required this.serialNumber});

  @override
  List<Object?> get props => [serialNumber];
}

