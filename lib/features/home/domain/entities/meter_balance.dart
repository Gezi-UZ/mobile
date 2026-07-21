import 'package:equatable/equatable.dart';

class MeterBalance extends Equatable {
  final double kwhBalance;
  final String meterId;
  final bool isOnline;
  final DateTime lastSyncAt;
  final bool isLowBalance;

  const MeterBalance({
    required this.kwhBalance,
    required this.meterId,
    required this.isOnline,
    required this.lastSyncAt,
    required this.isLowBalance,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [kwhBalance, meterId, isOnline, lastSyncAt, isLowBalance];
}
