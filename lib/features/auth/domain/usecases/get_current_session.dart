import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/session.dart';
import '../repositories/auth_repository.dart';

/// Returns the current active Supabase session, or null if not authenticated.
class GetCurrentSession {
  final AuthRepository repository;
  const GetCurrentSession(this.repository);

  Future<Either<Failure, UserSession?>> call() {
    return repository.getCurrentSession();
  }
}
