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

  /// Latitude da localização do contador.
  final double? latitude;

  /// Longitude da localização do contador.
  final double? longitude;

  /// Endereço legível da localização do contador.
  final String? address;

  /// Estado do relé (true = ligado / energia fornecida, false = cortado).
  final bool relayState;

  /// Data e hora da última recarga efectuada.
  final DateTime? lastRechargeAt;

  /// Data e hora da última sincronização/telemetria recebida.
  final DateTime? lastSyncAt;

  const Meter({
    required this.id,
    required this.alias,
    required this.serialNumber,
    required this.isOnline,
    required this.isPrimary,
    required this.kwhBalance,
    required this.iconType,
    this.latitude,
    this.longitude,
    this.address,
    this.relayState = true,
    this.lastRechargeAt,
    this.lastSyncAt,
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
        latitude,
        longitude,
        address,
        relayState,
        lastRechargeAt,
        lastSyncAt,
      ];

  Meter copyWith({
    String? id,
    String? alias,
    String? serialNumber,
    bool? isOnline,
    bool? isPrimary,
    double? kwhBalance,
    MeterIconType? iconType,
    double? latitude,
    double? longitude,
    String? address,
    bool? relayState,
    DateTime? lastRechargeAt,
    DateTime? lastSyncAt,
  }) {
    return Meter(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      serialNumber: serialNumber ?? this.serialNumber,
      isOnline: isOnline ?? this.isOnline,
      isPrimary: isPrimary ?? this.isPrimary,
      kwhBalance: kwhBalance ?? this.kwhBalance,
      iconType: iconType ?? this.iconType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      relayState: relayState ?? this.relayState,
      lastRechargeAt: lastRechargeAt ?? this.lastRechargeAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }
}
