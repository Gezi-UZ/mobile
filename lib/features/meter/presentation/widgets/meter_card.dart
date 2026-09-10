import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/meter/domain/entities/meter.dart';
import 'package:go_router/go_router.dart';
import 'package:gezi/features/meter/presentation/widgets/meter_status_badge.dart';

/// Card que representa um contador na lista de contadores.
///
/// Exibe o avatar com ícone, nome amigável, número de série, badge de status,
/// consumo em kWh e um botão de opções. O contador principal é destacado com
/// borda laranja e label "⭐ PRINCIPAL".
class MeterCard extends StatelessWidget {
  final Meter meter;
  final VoidCallback? onSetPrimary;

  const MeterCard({
    super.key,
    required this.meter,
    this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.1,
            color: meter.isPrimary
                ? AppTheme.primaryOrange
                : Colors.black.withValues(alpha: 0.08),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label "PRINCIPAL" dentro do card
            if (meter.isPrimary)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppTheme.primaryOrange,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'PRINCIPAL',
                      style: TextStyle(
                        color: AppTheme.primaryOrange,
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        letterSpacing: 0.25,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar com ícone
                _MeterAvatar(meter: meter),
                const SizedBox(width: 12),
                // Informações do contador
                Expanded(child: _MeterInfo(meter: meter)),
                const SizedBox(width: 12),
                // Botão de opções
                _OptionsButton(meter: meter, onSetPrimary: onSetPrimary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Subwidgets privados
// ──────────────────────────────────────────────

class _MeterAvatar extends StatelessWidget {
  final Meter meter;

  const _MeterAvatar({required this.meter});

  bool get _isOnline {
    final sync = meter.lastSyncAt;
    if (sync == null) return meter.isOnline;
    return DateTime.now().difference(sync.toLocal()).inMinutes <= 5;
  }

  Color get _statusColor {
    if (!_isOnline) return const Color(0xFFD32F2F);
    if (meter.kwhBalance >= 5) return const Color(0xFF00C950);
    if (meter.kwhBalance > 0) return const Color(0xFFFFB300);
    return const Color(0xFFD32F2F);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        _avatarIcon,
        color: _statusColor,
        size: 24,
      ),
    );
  }

  IconData get _avatarIcon {
    switch (meter.iconType) {
      case MeterIconType.home:
        return Icons.home_outlined;
      case MeterIconType.office:
        return Icons.business_outlined;
      case MeterIconType.store:
        return Icons.warehouse_outlined;
      case MeterIconType.generic:
        return Icons.electric_meter_outlined;
    }
  }
}

class _MeterInfo extends StatelessWidget {
  final Meter meter;

  const _MeterInfo({required this.meter});

  bool get _isOnline {
    final sync = meter.lastSyncAt;
    if (sync == null) return meter.isOnline;
    return DateTime.now().difference(sync.toLocal()).inMinutes <= 5;
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = _isOnline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nome amigável
        Text(
          meter.alias,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.43,
          ),
        ),
        // Número de série
        Text(
          meter.serialNumber,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 1.33,
          ),
        ),
        const SizedBox(height: 4),
        // Badge de status + kWh
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            MeterStatusBadge(isOnline: isOnline),
            Text(
              isOnline
                  ? '${meter.kwhBalance.toStringAsFixed(2).replaceAll(RegExp(r'0$'), '')} kWh'
                  : '0 kWh',
              style: TextStyle(
                color: _kwhColor,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color get _kwhColor {
    if (!_isOnline) return const Color(0xFFD32F2F);
    if (meter.kwhBalance >= 5) return const Color(0xFF00C950);
    if (meter.kwhBalance > 0) return const Color(0xFFFFB300);
    return const Color(0xFFD32F2F);
  }
}

class _OptionsButton extends StatelessWidget {
  final Meter meter;
  final VoidCallback? onSetPrimary;

  const _OptionsButton({required this.meter, this.onSetPrimary});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 20,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surface,
      onSelected: (value) {
        if (value == 'primary') {
          onSetPrimary?.call();
        } else if (value == 'details') {
          context.push('/meters/detail', extra: {'meter': meter});
        } else if (value == 'edit') {
          context.push('/meters/edit', extra: {'meter': meter});
        } else if (value == 'remove') {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Remover contador: Em breve')),
          );
        }
      },
      itemBuilder: (context) => [
        if (!meter.isPrimary)
          PopupMenuItem(
            value: 'primary',
            child: Row(
              spacing: 12,
              children: [
                Icon(Icons.star_outline, size: 20, color: Theme.of(context).colorScheme.onSurface),
                const Text('Definir como principal', style: TextStyle(fontFamily: 'Inter', fontSize: 14)),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'details',
          child: Row(
            spacing: 12,
            children: [
              Icon(Icons.visibility_outlined, size: 20, color: Theme.of(context).colorScheme.onSurface),
              const Text('Ver detalhes', style: TextStyle(fontFamily: 'Inter', fontSize: 14)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: Row(
            spacing: 12,
            children: [
              Icon(Icons.edit_outlined, size: 20, color: Theme.of(context).colorScheme.onSurface),
              const Text('Editar', style: TextStyle(fontFamily: 'Inter', fontSize: 14)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'remove',
          child: Row(
            spacing: 12,
            children: [
              Icon(Icons.delete_outline, size: 20, color: Color(0xFFD32F2F)),
              Text('Remover', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Color(0xFFD32F2F))),
            ],
          ),
        ),
      ],
    );
  }
}
