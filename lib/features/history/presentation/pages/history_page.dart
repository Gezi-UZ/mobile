import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/history/presentation/widgets/daily_consumption_chart_widget.dart';
import 'package:gezi/features/history/presentation/widgets/energy_summary_card.dart';
import 'package:gezi/features/history/presentation/widgets/history_header_widget.dart';
import 'package:gezi/features/history/presentation/widgets/meter_selector_widget.dart';
import 'package:gezi/features/history/presentation/widgets/time_filter_toggle_widget.dart';
import 'package:gezi/features/history/presentation/widgets/recharge_tile_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedMeterName = 'Todos os contadores';
  String _selectedMeterSubtitle = '3 contadores registados';

  void _showMeterSelectionBottomSheet() {
    // Mocks for meters
    final List<Map<String, String>> meters = [
      {'name': 'Todos os contadores', 'subtitle': '3 contadores registados'},
      {'name': 'Casa - Principal', 'subtitle': 'Contador: 04040404040'},
      {'name': 'Escritório', 'subtitle': 'Contador: 04040404041'},
      {'name': 'Casa de Praia', 'subtitle': 'Contador: 04040404042'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecione um contador',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textColorDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 16),
                ...meters.map((meter) {
                  final isSelected = _selectedMeterName == meter['name'];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                            : AppTheme.lightOrangeBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSelected ? Icons.check_circle : Icons.bolt_rounded,
                        color: isSelected ? AppTheme.primaryOrange : AppTheme.textColorSecondary,
                      ),
                    ),
                    title: Text(
                      meter['name']!,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppTheme.textColorDark,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                    ),
                    subtitle: Text(
                      meter['subtitle']!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textColorSecondary,
                          ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedMeterName = meter['name']!;
                        _selectedMeterSubtitle = meter['subtitle']!;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 24,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HistoryHeaderWidget(
                  onFilterTap: () {
                    // Action when filter is tapped
                  },
                ),
                const SizedBox(height: 20),
                MeterSelectorWidget(
                  title: _selectedMeterName,
                  subtitle: _selectedMeterSubtitle,
                  onTap: _showMeterSelectionBottomSheet,
                ),
                const SizedBox(height: 16),
                TimeFilterToggleWidget(
                  onFilterChanged: (filter) {
                    // Handle filter change
                  },
                ),
                const SizedBox(height: 24),
                const EnergySummaryCard(),
                const SizedBox(height: 16),
                const DailyConsumptionChartWidget(),
                const SizedBox(height: 24),
                Text(
                  'Recargas efectuadas',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.textColorDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                ),
                const RechargeTileWidget(
                  dateHeader: '18 JUN 2026',
                  energyAmount: '18.5 kWh',
                  timeAndMethod: '14:32 · M-Pesa · CR...92',
                  cost: '500 MZN',
                ),
                const RechargeTileWidget(
                  dateHeader: '15 JUN 2026',
                  energyAmount: '20.0 kWh',
                  timeAndMethod: '09:15 · e-Mola · CR...14',
                  cost: '600 MZN',
                ),
                const RechargeTileWidget(
                  dateHeader: '10 JUN 2026',
                  energyAmount: '10.2 kWh',
                  timeAndMethod: '18:45 · M-Pesa · CR...88',
                  cost: '300 MZN',
                ),
                const RechargeTileWidget(
                  dateHeader: '02 JUN 2026',
                  energyAmount: '35.0 kWh',
                  timeAndMethod: '11:20 · Conta Móvel · CR...42',
                  cost: '1000 MZN',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
