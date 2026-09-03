import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/session_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserSession>> signUpWithEmail({
    required String fullName,
    required String email,
    required String pin,
  }) async {
    try {
      final session = await remoteDataSource.signUpWithEmail(
        fullName: fullName,
        email: email,
        pin: pin,
      );
      return Right(session);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSession>> signInWithEmail({
    required String email,
    required String pin,
  }) async {
    try {
      final session = await remoteDataSource.signInWithEmail(
        email: email,
        pin: pin,
      );
      return Right(session);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSession?>> getCurrentSession() async {
    try {
      final session = await remoteDataSource.getCurrentSession();
      return Right(session);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enableBiometric(UserSession session) async {
    try {
      await remoteDataSource.enableBiometric(session as SessionModel);
      return const Right(null);
    } catch (e) {
      return Left(BiometricFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> savePin(String pin, UserSession session) async {
    try {
      await remoteDataSource.savePin(pin, session as SessionModel);
      return const Right(null);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSession>> verifyPin(String pin) async {
    try {
      final session = await remoteDataSource.verifyPin(pin);
      return Right(session);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSession>> restoreSessionFromSecureStorage() async {
    try {
      final session = await remoteDataSource.restoreSessionFromSecureStorage();
      return Right(session);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(BiometricFailure(e.toString()));
    }
  }

  @override
  Future<bool> isBiometricEnabled() {
    return remoteDataSource.isBiometricEnabled();
  }

  @override
  Future<bool> isPinConfigured() {
    return remoteDataSource.isPinConfigured();
  }
}
