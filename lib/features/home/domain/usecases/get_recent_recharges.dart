import 'package:dartz/dartz.dart';
import 'package:gezi/core/errors/failures.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart';
import 'package:gezi/features/home/domain/repositories/home_repository.dart';

/// Obtém as últimas [limit] recargas do utilizador autenticado.
class GetRecentRecharges {
  final HomeRepository repository;

  GetRecentRecharges(this.repository);

  Future<Either<Failure, List<Recharge>>> call({int limit = 5}) {
    return repository.getRecentRecharges(limit: limit);
  }
}
