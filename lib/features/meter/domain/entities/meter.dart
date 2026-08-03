import 'package:equatable/equatable.dart';

/// Tipo de ícone/avatar associado ao contador.
enum MeterIconType {
  home,    // Casa
  office,  // Escritório
  store,   // Armazém / Loja
  generic, // Genérico
}

/// Entidade de domínio que representa um contador de energia.
class Meter extends Equatable {
  /// Identificador único (UUID/DB).
  final String id;

  /// Nome amigável atribuído pelo utilizador (ex: "Casa principal").
  final String alias;

  /// Número de série truncado do contador (ex: "CR...92").
  final String serialNumber;

  /// Indica se o contador está em comunicação com o servidor.
  final bool isOnline;

  /// Indica se este é o contador principal do utilizador.
  final bool isPrimary;

  /// Saldo de energia disponível em kWh.
  final double kwhBalance;

  /// Tipo de ícone/avatar a exibir no card.
  final MeterIconType iconType;

  const Meter({
    required this.id,
    required this.alias,
    required this.serialNumber,
    required this.isOnline,
    required this.isPrimary,
    required this.kwhBalance,
    required this.iconType,
  });

  @override
  List<Object?> get props => [
        id,
        alias,
        serialNumber,
        isOnline,
        isPrimary,
        kwhBalance,
        iconType,
      ];
}
