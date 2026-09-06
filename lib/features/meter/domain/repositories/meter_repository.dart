import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/meter.dart';

abstract class MeterRepository {
  /// Obtém a lista de contadores associados ao utilizador logado.
  Future<Either<Failure, List<Meter>>> getMeters();

  /// Adiciona um novo contador (associação).
  Future<Either<Failure, Meter>> addMeter({
    required String serialNumber,
    required String alias,
    required double latitude,
    required double longitude,
    required String address,
  });

  /// Obtém detalhes de um contador específico pelo seu ID.
  Future<Either<Failure, Meter>> getMeterDetails(String meterId);

  /// Atualiza dados do contador.
  Future<Either<Failure, Meter>> updateMeter(String meterId, {String? alias, bool? isPrimary});

  /// Subscreve às atualizações em tempo real do estado do contador.
  Stream<Meter> watchMeterStatus(String meterId);
}
