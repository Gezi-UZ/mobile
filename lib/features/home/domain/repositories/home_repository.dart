import 'package:dartz/dartz.dart' show Either;
import 'package:gezi/core/errors/failures.dart';
import 'package:gezi/features/home/domain/entities/meter_balance.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart';

abstract class HomeRepository {
  Future<Either<Failure, MeterBalance>> getMeterBalance();
  Future<Either<Failure, List<Recharge>>> getRecentRecharges({int limit = 5});
}