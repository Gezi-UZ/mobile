import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

import 'package:gezi/features/meter/domain/entities/meter.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart';
import 'package:gezi/core/shared_widgets/buttons/primary_button.dart';

import '../widgets/meter_balance_card.dart';
import '../widgets/meter_stats_row.dart';
import '../widgets/meter_consumption_chart.dart';
import '../widgets/meter_recent_transactions.dart';

class MeterDetailPage extends StatelessWidget {
  final Meter meter;
  final List<Recharge> recentRecharges;

  const MeterDetailPage({
    super.key,
    required this.meter,
    required this.recentRecharges,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textColorDark),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMeterHeader(context),
              MeterBalanceCard(meter: meter),
              const MeterStatsRow(),
              const MeterConsumptionChart(),
              MeterRecentTransactions(recharges: recentRecharges),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 12),
          child: SizedBox(
            child: PrimaryButton(
              text: 'Recarregar este contador',
              icon: Image.asset(
                'assets/images/recharge_icon.png',
                width: 24,
                height: 24,
                color: AppTheme.white,
              ),
              onPressed: () {
                // TODO: Navigate to recharge with this specific meter
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeterHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.flash_on_rounded, color: AppTheme.primaryOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meter.alias,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textColorDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  meter.serialNumber,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textColorSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: meter.isOnline ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(37282700),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: meter.isOnline ? const Color(0xFF00C950) : const Color(0xFF9CA3AF),
                    borderRadius: BorderRadius.circular(37282700),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  meter.isOnline ? 'Online' : 'Offline',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: meter.isOnline ? const Color(0xFF008236) : const Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
