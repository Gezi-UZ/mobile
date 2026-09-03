import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  /// Fetches the authenticated user's profile from public.utilizadores.
  Future<Either<Failure, UserProfile>> getProfile();

  /// Updates nome and/or telefone for the authenticated user.
  Future<Either<Failure, UserProfile>> updateProfile({
    required String nome,
    String? telefone,
  });
}
