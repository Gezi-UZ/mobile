import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'chart_data_point.dart';

enum ChartPeriod { week, month }

class MeterConsumptionChart extends StatefulWidget {
  final List<ChartDataPoint> weeklyData;
  final List<ChartDataPoint> monthlyData;

  const MeterConsumptionChart({
    super.key,
    required this.weeklyData,
    required this.monthlyData,
  });

  @override
  State<MeterConsumptionChart> createState() => _MeterConsumptionChartState();
}

class _MeterConsumptionChartState extends State<MeterConsumptionChart> {
  ChartPeriod _selectedPeriod = ChartPeriod.week;

  @override
  Widget build(BuildContext context) {
    final isWeek = _selectedPeriod == ChartPeriod.week;
    final currentData = isWeek ? widget.weeklyData : widget.monthlyData;
    
    // Calcula o valor máximo para escalar a altura das barras (max altura visual ~80-100)
    final double maxValue = currentData.isEmpty 
        ? 0 
        : currentData.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPeriod = ChartPeriod.week;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isWeek ? AppTheme.primaryOrange : Theme.of(context).extension<AppColorsExtension>()!.inputBackground,
                    borderRadius: BorderRadius.circular(37282700),
                  ),
                  child: Text(
                    'Semana',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isWeek ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPeriod = ChartPeriod.month;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: !isWeek ? AppTheme.primaryOrange : Theme.of(context).extension<AppColorsExtension>()!.inputBackground,
                    borderRadius: BorderRadius.circular(37282700),
                  ),
                  child: Text(
                    'Mês',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: !isWeek ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1.11,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consumo (kWh)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 110,
                  alignment: Alignment.bottomCenter,
                  child: currentData.isEmpty
                      ? Center(
                          child: Text(
                            'Sem dados de consumo',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: currentData.map((point) {
                            // Altura máxima da barra é 80
                            final double height = maxValue > 0 
                                ? (point.value / maxValue) * 80 
                                : 0;
                            // Se tiver valor mínimo garantimos ao menos 4px para se ver a barra
                            final double displayHeight = point.value > 0 ? height.clamp(4.0, 80.0) : 0;
                            
                            return _buildChartBar(context, point.label, displayHeight);
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(BuildContext context, String label, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 8,
          height: height,
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
