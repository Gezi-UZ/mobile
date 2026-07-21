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
    return RechargeResultModel(
      transactionId: json['transaction_id'] ?? '',
      meterNumber: json['meter_number'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      kwh: (json['kwh'] ?? 0.0).toDouble(),
      method: json['method'] ?? 'M-Pesa',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
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
