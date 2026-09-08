import 'package:flutter/material.dart';

class RechargeTileWidget extends StatelessWidget {
  final String dateHeader;
  final String energyAmount;
  final String timeAndMethod;
  final String cost;
  final String status;
  final Color statusColor;

  final String rechargeType; // 'SELF', 'RECEIVED', 'FOR_OTHER'
  final String? otherPartyName;

  const RechargeTileWidget({
    super.key,
    this.dateHeader = '18 JUN 2026',
    this.energyAmount = '18.5 kWh',
    this.timeAndMethod = '14:32 · M-Pesa · CR...92',
    this.cost = '500 MZN',
    this.status = 'Concluída',
    this.statusColor = const Color(0xFF2E7D32), // Default to success green
    this.rechargeType = 'SELF',
    this.otherPartyName,
  });

  IconData _getIcon() {
    if (rechargeType == 'RECEIVED') return Icons.south_west_rounded;
    if (rechargeType == 'FOR_OTHER') return Icons.north_east_rounded;
    return Icons.check_circle_outline;
  }

  String _getSubtitle() {
    if (rechargeType == 'RECEIVED') {
      return 'Recebida de ${otherPartyName ?? 'Desconhecido'}';
    } else if (rechargeType == 'FOR_OTHER') {
      return 'Para ${otherPartyName ?? 'Desconhecido'}';
    }
    return timeAndMethod;
  }

  @override
  Widget build(BuildContext context) {
    final displaySubtitle = _getSubtitle();
    final bool isThirdParty = rechargeType != 'SELF';

    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              dateHeader,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.55,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.only(
              top: 12,
              left: 12,
              right: 16,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 4,
                  height: 36,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIcon(),
                    color: statusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        energyAmount,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displaySubtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isThirdParty 
                                  ? Theme.of(context).colorScheme.primary 
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                      ),
                      if (isThirdParty) ...[
                        const SizedBox(height: 2),
                        Text(
                          timeAndMethod,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      cost,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            decoration: rechargeType == 'RECEIVED' ? TextDecoration.lineThrough : null,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
