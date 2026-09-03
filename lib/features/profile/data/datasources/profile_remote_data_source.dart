import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> updateProfile({
    required String nome,
    String? telefone,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  // ─────────────────────────────────────────────────────────────────
  // Get Profile
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<UserProfileModel> getProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException('Utilizador não autenticado.');
    }

    final data = await supabase
        .from('utilizadores')
        .select()
        .eq('id', userId)
        .single();

    return UserProfileModel.fromJson(data);
  }

  // ─────────────────────────────────────────────────────────────────
  // Update Profile
  // ─────────────────────────────────────────────────────────────────

  @override
  Future<UserProfileModel> updateProfile({
    required String nome,
    String? telefone,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException('Utilizador não autenticado.');
    }

    final updates = <String, dynamic>{'nome': nome};
    // Only include telefone if explicitly provided (allows clearing if null passed)
    if (telefone != null && telefone.isNotEmpty) {
      updates['telefone'] = telefone;
    }

    final data = await supabase
        .from('utilizadores')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();

    return UserProfileModel.fromJson(data);
  }
}
