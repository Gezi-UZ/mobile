import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/meter.dart';
import '../repositories/meter_repository.dart';

class EditMeter implements UseCase<Meter, EditMeterParams> {
  final MeterRepository repository;

  EditMeter(this.repository);

  @override
  Future<Either<Failure, Meter>> call(EditMeterParams params) async {
    return await repository.updateMeter(
      params.meterId,
      alias: params.alias,
      isPrimary: params.isPrimary,
    );
  }
}

class EditMeterParams extends Equatable {
  final String meterId;
  final String? alias;
  final bool? isPrimary;

  const EditMeterParams({
    required this.meterId,
    this.alias,
    this.isPrimary,
  });

  @override
  List<Object?> get props => [meterId, alias, isPrimary];
}
