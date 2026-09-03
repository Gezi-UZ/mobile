import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfile {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  Future<Either<Failure, UserProfile>> call({
    required String nome,
    String? telefone,
  }) {
    return repository.updateProfile(nome: nome, telefone: telefone);
  }
}
