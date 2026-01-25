import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/led.dart';
import '../repositories/led_repository.dart';

/// Use case for toggling LED state
class ToggleLed implements UseCase<Led, ToggleLedParams> {
  final LedRepository repository;

  ToggleLed(this.repository);

  @override
  Future<Either<Failure, Led>> call(ToggleLedParams params) async {
    return await repository.setLed(params.ledId, params.state);
  }
}

/// Parameters for ToggleLed use case
class ToggleLedParams extends Equatable {
  final String ledId;
  final bool state;

  const ToggleLedParams({
    required this.ledId,
    required this.state,
  });

  @override
  List<Object?> get props => [ledId, state];
}