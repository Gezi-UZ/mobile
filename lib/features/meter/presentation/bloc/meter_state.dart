import 'package:equatable/equatable.dart';
import '../../domain/entities/meter.dart';

abstract class MeterState extends Equatable {
  const MeterState();

  @override
  List<Object?> get props => [];
}

class MeterInitial extends MeterState {
  const MeterInitial();
}

class MeterLoading extends MeterState {
  const MeterLoading();
}

class MeterLoaded extends MeterState {
  final List<Meter> meters;

  const MeterLoaded({required this.meters});

  Meter? get primaryMeter {
    if (meters.isEmpty) return null;
    return meters.firstWhere(
      (m) => m.isPrimary,
      orElse: () => meters.first,
    );
  }

  @override
  List<Object?> get props => [meters];
}

class MeterError extends MeterState {
  final String message;

  const MeterError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MeterValidating extends MeterState {
  const MeterValidating();
}

class MeterValidationSuccess extends MeterState {
  final Meter meter;

  const MeterValidationSuccess({required this.meter});

  @override
  List<Object?> get props => [meter];
}

class MeterValidationFailure extends MeterState {
  final String message;

  const MeterValidationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

