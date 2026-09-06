import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalSpentMzn,
    required super.totalKwhPurchased,
    required super.averageConsumptionKwhDay,
    required super.rechargeCount,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalSpentMzn: (json['total_spent_mzn'] as num?)?.toDouble() ?? 0.0,
      totalKwhPurchased: (json['total_kwh_purchased'] as num?)?.toDouble() ?? 0.0,
      averageConsumptionKwhDay: (json['average_consumption_kwh_day'] as num?)?.toDouble() ?? 0.0,
      rechargeCount: json['recharge_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_spent_mzn': totalSpentMzn,
      'total_kwh_purchased': totalKwhPurchased,
      'average_consumption_kwh_day': averageConsumptionKwhDay,
      'recharge_count': rechargeCount,
    };
  }
}
