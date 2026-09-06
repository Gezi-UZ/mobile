import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/meter.dart';
import '../repositories/meter_repository.dart';

class GetMeterStatus implements UseCase<Meter, GetMeterStatusParams> {
  final MeterRepository repository;

  GetMeterStatus(this.repository);

  @override
  Future<Either<Failure, Meter>> call(GetMeterStatusParams params) async {
    return await repository.getMeterDetails(params.meterId);
  }
}

class GetMeterStatusParams extends Equatable {
  final String meterId;

  const GetMeterStatusParams({required this.meterId});

  @override
  List<Object?> get props => [meterId];
}
