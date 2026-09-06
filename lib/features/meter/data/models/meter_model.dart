import '../../domain/entities/meter.dart';

class MeterModel extends Meter {
  const MeterModel({
    required super.id,
    required super.alias,
    required super.serialNumber,
    required super.isOnline,
    required super.isPrimary,
    required super.kwhBalance,
    required super.iconType,
  });

  factory MeterModel.fromJson(Map<String, dynamic> json) {
    // Determine icon type based on label as a fallback if not provided
    final label = (json['label'] as String?) ?? '';
    MeterIconType type = MeterIconType.generic;
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('casa')) {
      type = MeterIconType.home;
    } else if (lowerLabel.contains('escritório') || lowerLabel.contains('office')) {
      type = MeterIconType.office;
    } else if (lowerLabel.contains('loja') || lowerLabel.contains('armazém')) {
      type = MeterIconType.store;
    }

    return MeterModel(
      id: json['id'] as String? ?? '',
      alias: label,
      serialNumber: json['serial_number'] as String? ?? '',
      isOnline: json['estado'] == 'ONLINE',
      isPrimary: json['is_primary'] as bool? ?? false,
      kwhBalance: (json['kwh_saldo'] as num?)?.toDouble() ?? 0.0,
      iconType: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': alias,
      'serial_number': serialNumber,
      'estado': isOnline ? 'ONLINE' : 'OFFLINE',
      'kwh_saldo': kwhBalance,
      'is_primary': isPrimary,
    };
  }

  factory MeterModel.fromEntity(Meter entity) {
    return MeterModel(
      id: entity.id,
      alias: entity.alias,
      serialNumber: entity.serialNumber,
      isOnline: entity.isOnline,
      isPrimary: entity.isPrimary,
      kwhBalance: entity.kwhBalance,
      iconType: entity.iconType,
    );
  }
}
