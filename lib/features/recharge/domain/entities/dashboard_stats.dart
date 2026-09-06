import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final double totalSpentMzn;
  final double totalKwhPurchased;
  final double averageConsumptionKwhDay;
  final int rechargeCount;

  const DashboardStats({
    required this.totalSpentMzn,
    required this.totalKwhPurchased,
    required this.averageConsumptionKwhDay,
    required this.rechargeCount,
  });

  @override
  List<Object?> get props => [
        totalSpentMzn,
        totalKwhPurchased,
        averageConsumptionKwhDay,
        rechargeCount,
      ];
}
