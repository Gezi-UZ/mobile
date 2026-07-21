import '../../domain/entities/meter_balance.dart';

class MeterBalanceModel extends MeterBalance {
  const MeterBalanceModel({
    required super.kwhBalance,
    required super.meterId,
    required super.isOnline,
    required super.lastSyncAt,
    required super.isLowBalance,
  });

  factory MeterBalanceModel.fromJson(Map<String, dynamic> json) {
    return MeterBalanceModel(
      kwhBalance: (json['kwh_balance'] as num).toDouble(),
      meterId: json['meter_id'] as String,
      isOnline: json['is_online'] as bool,
      lastSyncAt: DateTime.parse(json['last_sync_at'] as String),
      isLowBalance: json['is_low_balance'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'kwh_balance': kwhBalance,
        'meter_id': meterId,
        'is_online': isOnline,
        'last_sync_at': lastSyncAt.toIso8601String(),
        'is_low_balance': isLowBalance,
      };
}
