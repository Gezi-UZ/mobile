import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> requestOtp(String phoneNumber);
  Future<Either<Failure, bool>> verifyOtp(String phoneNumber, String code);
  Future<Either<Failure, void>> createPasskey(String phoneNumber);
}