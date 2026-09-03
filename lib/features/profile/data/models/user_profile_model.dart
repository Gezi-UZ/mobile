import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.nome,
    super.telefone,
    required super.papel,
    required super.biometriaActiva,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      nome: json['nome'] as String? ?? '',
      telefone: json['telefone'] as String?,
      papel: json['papel'] as String? ?? 'cliente',
      biometriaActiva: json['biometria_activa'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'papel': papel,
      'biometria_activa': biometriaActiva,
    };
  }
}
