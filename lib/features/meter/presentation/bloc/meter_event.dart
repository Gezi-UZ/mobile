import 'package:equatable/equatable.dart';
import '../../domain/entities/meter.dart';

abstract class MeterEvent extends Equatable {
  const MeterEvent();

  @override
  List<Object?> get props => [];
}

/// Disparado para carregar a lista de contadores do utilizador logado.
class MeterListRequested extends MeterEvent {
  const MeterListRequested();
}

/// Disparado para definir um contador como principal.
class MeterSetPrimaryRequested extends MeterEvent {
  final String meterId;

  const MeterSetPrimaryRequested(this.meterId);

  @override
  List<Object?> get props => [meterId];
}

/// Disparado internamente quando chegam atualizações via Supabase Realtime.
class MeterUpdatedRealtime extends MeterEvent {
  final List<Meter> meters;

  const MeterUpdatedRealtime(this.meters);

  @override
  List<Object?> get props => [meters];
}

/// Disparado para validar a existência de um contador pelo número de série.
class MeterValidateRequested extends MeterEvent {
  final String serialNumber;

  const MeterValidateRequested(this.serialNumber);

  @override
  List<Object?> get props => [serialNumber];
}

/// Disparado para registar um novo contador.
class MeterAddRequested extends MeterEvent {
  final String serialNumber;
  final String alias;
  final double latitude;
  final double longitude;
  final String address;

  const MeterAddRequested({
    required this.serialNumber,
    required this.alias,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [serialNumber, alias, latitude, longitude, address];
}

/// Disparado para atualizar os dados de um contador (ex: etiqueta).
class MeterUpdateRequested extends MeterEvent {
  final String meterId;
  final String? alias;
  final bool? isPrimary;

  const MeterUpdateRequested({
    required this.meterId,
    this.alias,
    this.isPrimary,
  });

  @override
  List<Object?> get props => [meterId, alias, isPrimary];
}

