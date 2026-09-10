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
    super.latitude,
    super.longitude,
    super.address,
    super.relayState,
    super.lastRechargeAt,
    super.lastSyncAt,
  });

  factory MeterModel.fromJson(Map<String, dynamic> json) {
    // Determine icon type based on label as a fallback if not provided
    final label = (json['label'] as String?) ?? (json['alias'] as String?) ?? '';
    MeterIconType type = MeterIconType.generic;
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('casa')) {
      type = MeterIconType.home;
    } else if (lowerLabel.contains('escritório') || lowerLabel.contains('office')) {
      type = MeterIconType.office;
    } else if (lowerLabel.contains('loja') || lowerLabel.contains('armazém')) {
      type = MeterIconType.store;
    }

    double? lat;
    double? lng;
    String? addr;
    if (json['location'] is Map<String, dynamic>) {
      final loc = json['location'] as Map<String, dynamic>;
      lat = (loc['latitude'] as num?)?.toDouble();
      lng = (loc['longitude'] as num?)?.toDouble();
      addr = loc['address'] as String?;
    } else {
      lat = (json['latitude'] as num?)?.toDouble();
      lng = (json['longitude'] as num?)?.toDouble();
      addr = json['address'] as String?;
    }

    // is_online: prefer the explicit backend field (dynamically computed), fallback to estado string
    final isOnlineVal = json['is_online'] as bool?
        ?? (json['estado'] == 'ONLINE' || json['status'] == 'ONLINE');
    final relayStateVal = json['estado_rele'] as bool? ?? json['relay_state'] as bool? ?? true;

    DateTime? parseDate(dynamic raw) {
      if (raw == null) return null;
      final str = raw.toString().trim();
      if (str.isEmpty) return null;
      if (!str.endsWith('Z') && !str.contains('+') && !RegExp(r'-\d{2}:\d{2}$').hasMatch(str)) {
        return DateTime.tryParse('${str}Z')?.toLocal();
      }
      return DateTime.tryParse(str)?.toLocal();
    }

    final lastRecharge = parseDate(json['ultima_recarga'] ?? json['last_recharge_at']);
    final lastSync = parseDate(json['ultima_sincronizacao'] ?? json['last_seen_at']);

    final idVal = (json['id'] ?? json['meter_id'] ?? json['_id'])?.toString() ?? '';
    final serialVal = (json['serial_number'] ?? json['meter_number'] ?? json['numero_serie'] ?? json['serialNumber'] ?? json['meterNumber'])?.toString() ?? '';

    return MeterModel(
      id: idVal.isNotEmpty ? idVal : serialVal, // fallback to serial if id is missing
      alias: label,
      serialNumber: serialVal,
      isOnline: isOnlineVal,
      isPrimary: json['is_primary'] as bool? ?? false,
      kwhBalance: (json['kwh_saldo'] as num?)?.toDouble() ??
          (json['credit_kwh'] as num?)?.toDouble() ??
          0.0,
      iconType: type,
      latitude: lat,
      longitude: lng,
      address: addr,
      relayState: relayStateVal,
      lastRechargeAt: lastRecharge,
      lastSyncAt: lastSync,
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
      'estado_rele': relayState,
      if (latitude != null || longitude != null || address != null)
        'location': {
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
          if (address != null) 'address': address,
        },
      if (lastRechargeAt != null) 'ultima_recarga': lastRechargeAt!.toIso8601String(),
      if (lastSyncAt != null) 'ultima_sincronizacao': lastSyncAt!.toIso8601String(),
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
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      relayState: entity.relayState,
      lastRechargeAt: entity.lastRechargeAt,
      lastSyncAt: entity.lastSyncAt,
    );
  }
}
