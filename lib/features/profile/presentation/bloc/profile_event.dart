import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  final String nome;
  final String? telefone;

  const ProfileUpdateRequested({required this.nome, this.telefone});

  @override
  List<Object?> get props => [nome, telefone];
}
