import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/meter_balance.dart';
import '../repositories/home_repository.dart';

/// Obtém o saldo actual do contador associado ao utilizador autenticado.
///
/// Não requer parâmetros — o repositório resolve o utilizador
/// pela sessão activa (Supabase auth).
class GetMeterBalance {
  final HomeRepository repository;

  GetMeterBalance(this.repository);

  Future<Either<Failure, MeterBalance>> call() {
    return repository.getMeterBalance();
  }
}
