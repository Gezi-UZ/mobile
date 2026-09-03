import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String nome;
  final String? telefone;
  final String papel;
  final bool biometriaActiva;

  const UserProfile({
    required this.id,
    required this.nome,
    this.telefone,
    required this.papel,
    required this.biometriaActiva,
  });

  UserProfile copyWith({
    String? nome,
    String? telefone,
    bool? biometriaActiva,
  }) {
    return UserProfile(
      id: id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      papel: papel,
      biometriaActiva: biometriaActiva ?? this.biometriaActiva,
    );
  }

  @override
  List<Object?> get props => [id, nome, telefone, papel, biometriaActiva];
}
