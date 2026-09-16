import '../../domain/entities/recharge_result.dart';

class RechargeResultModel extends RechargeResult {
  const RechargeResultModel({
    required super.transactionId,
    required super.meterNumber,
    required super.amount,
    required super.kwh,
    required super.method,
    required super.timestamp,
    required super.status,
  });

  factory RechargeResultModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic raw) {
      if (raw == null) return DateTime.now();
      final str = raw.toString().trim();
      if (str.isEmpty) return DateTime.now();
      if (!str.endsWith('Z') &&
          !str.contains('+') &&
          !RegExp(r'-\d{2}:\d{2}$').hasMatch(str)) {
        return (DateTime.tryParse('${str}Z') ?? DateTime.now()).toLocal();
      }
      return (DateTime.tryParse(str) ?? DateTime.now()).toLocal();
    }

    return RechargeResultModel(
      transactionId: json['transaction_id'] ?? '',
      meterNumber: json['meter_number'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      kwh: (json['kwh'] ?? 0.0).toDouble(),
      method: json['method'] ?? 'M-Pesa',
      timestamp: parseDate(json['timestamp']),
      status: json['status'] ?? 'Concluído',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'meter_number': meterNumber,
      'amount': amount,
      'kwh': kwh,
      'method': method,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}
