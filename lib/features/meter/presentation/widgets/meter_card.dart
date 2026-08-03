import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/meter/domain/entities/meter.dart';
import 'package:gezi/features/meter/presentation/widgets/meter_status_badge.dart';

/// Card que representa um contador na lista de contadores.
///
/// Exibe o avatar com ícone, nome amigável, número de série, badge de status,
/// consumo em kWh e um botão de opções. O contador principal é destacado com
/// borda laranja e label "⭐ PRINCIPAL".
class MeterCard extends StatelessWidget {
  final Meter meter;
  final VoidCallback? onOptionsTap;

  const MeterCard({
    super.key,
    required this.meter,
    this.onOptionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: AppTheme.white,
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
        padding: EdgeInsets.only(
          left: 17,
          right: 17,
          top: meter.isPrimary ? 40 : 17,
          bottom: 17,
        ),
        child: Stack(
          children: [
            // Label "⭐ PRINCIPAL" posicionada no topo do card principal
            if (meter.isPrimary)
              Positioned(
                top: -23,
                left: 0,
                child: Text(
                  '⭐ PRINCIPAL',
                  style: TextStyle(
                    color: AppTheme.primaryOrange,
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12,
              children: [
                // Avatar com ícone
                _MeterAvatar(iconType: meter.iconType),

                // Informações do contador
                Expanded(child: _MeterInfo(meter: meter)),

                // Botão de opções
                _OptionsButton(onTap: onOptionsTap),
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
  final MeterIconType iconType;

  const _MeterAvatar({required this.iconType});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _avatarBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        _avatarIcon,
        color: _avatarIconColor,
        size: 24,
      ),
    );
  }

  Color get _avatarBackgroundColor {
    switch (iconType) {
      case MeterIconType.home:
        return const Color(0x17D32F2F);
      case MeterIconType.office:
        return const Color(0x17FFB300);
      case MeterIconType.store:
        return const Color(0x17D32F2F);
      case MeterIconType.generic:
        return const Color(0x17FF6A00);
    }
  }

  Color get _avatarIconColor {
    switch (iconType) {
      case MeterIconType.home:
        return const Color(0xFFD32F2F);
      case MeterIconType.office:
        return const Color(0xFFFFB300);
      case MeterIconType.store:
        return const Color(0xFFD32F2F);
      case MeterIconType.generic:
        return AppTheme.primaryOrange;
    }
  }

  IconData get _avatarIcon {
    switch (iconType) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nome amigável
        Text(
          meter.alias,
          style: const TextStyle(
            color: AppTheme.textColorDark,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.43,
          ),
        ),
        // Número de série
        Text(
          meter.serialNumber,
          style: const TextStyle(
            color: AppTheme.textColorSecondary,
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
            MeterStatusBadge(isOnline: meter.isOnline),
            Text(
              meter.isOnline
                  ? '${meter.kwhBalance.toStringAsFixed(1)} kWh'
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
    if (!meter.isOnline) return const Color(0xFFD32F2F);
    if (meter.kwhBalance > 10) return const Color(0xFFFFB300);
    return const Color(0xFFD32F2F);
  }
}

class _OptionsButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _OptionsButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.more_vert,
          color: AppTheme.textColorSecondary,
          size: 20,
        ),
      ),
    );
  }
}
