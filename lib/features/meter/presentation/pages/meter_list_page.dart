import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/meter/domain/entities/meter.dart';
import 'package:gezi/features/meter/presentation/widgets/meter_card.dart';

/// Tela de listagem de contadores do utilizador.
///
/// Exibe todos os contadores associados à conta, com destaque para o contador
/// principal. Permite adicionar um novo contador através do botão de ação.
class MeterListPage extends StatelessWidget {
  const MeterListPage({super.key});

  // ── Dados mockados (substituir por BLoC/Cubit quando o backend estiver pronto) ──
  static final List<Meter> _mockMeters = [
    const Meter(
      id: '1',
      alias: 'Casa principal',
      serialNumber: 'CR...92',
      isOnline: true,
      isPrimary: true,
      kwhBalance: 3.2,
      iconType: MeterIconType.home,
    ),
    const Meter(
      id: '2',
      alias: 'Escritório',
      serialNumber: 'CR...04',
      isOnline: true,
      isPrimary: false,
      kwhBalance: 18.7,
      iconType: MeterIconType.office,
    ),
    const Meter(
      id: '3',
      alias: 'Armazém',
      serialNumber: 'CR...71',
      isOnline: false,
      isPrimary: false,
      kwhBalance: 0,
      iconType: MeterIconType.store,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 48,
            left: 20,
            right: 20,
            bottom: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MeterListHeader(onAddTap: () {
                // TODO: navegar para /meters/register
              }),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _mockMeters.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final meter = _mockMeters[index];
                    return MeterCard(
                      meter: meter,
                      onOptionsTap: () => _showMeterOptions(context, meter),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMeterOptions(BuildContext context, Meter meter) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _MeterOptionsSheet(meter: meter),
    );
  }
}

// ──────────────────────────────────────────────
// Subwidgets privados
// ──────────────────────────────────────────────

/// Header da tela com título e botão de adicionar contador.
class _MeterListHeader extends StatelessWidget {
  final VoidCallback onAddTap;

  const _MeterListHeader({required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Botão back (ausente no Figma da listagem — omitido para alinhamento
        // com o shell do bottom nav que não tem back button)
        const Expanded(
          child: Text(
            'Os meus contadores',
            style: TextStyle(
              color: AppTheme.textColorDark,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 1.56,
            ),
          ),
        ),
        // Botão de adicionar contador
        GestureDetector(
          onTap: onAddTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                  spreadRadius: -1,
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              color: AppTheme.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom sheet com opções do contador (definir como principal, editar, remover).
class _MeterOptionsSheet extends StatelessWidget {
  final Meter meter;

  const _MeterOptionsSheet({required this.meter});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              meter.alias,
              style: const TextStyle(
                color: AppTheme.textColorDark,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              meter.serialNumber,
              style: const TextStyle(
                color: AppTheme.textColorSecondary,
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 8),
            if (!meter.isPrimary)
              _OptionTile(
                icon: Icons.star_outline,
                label: 'Definir como principal',
                onTap: () => Navigator.pop(context),
              ),
            _OptionTile(
              icon: Icons.edit_outlined,
              label: 'Editar nome',
              onTap: () => Navigator.pop(context),
            ),
            _OptionTile(
              icon: Icons.delete_outline,
              label: 'Remover contador',
              color: const Color(0xFFD32F2F),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppTheme.textColorDark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(
          spacing: 12,
          children: [
            Icon(icon, color: effectiveColor, size: 22),
            Text(
              label,
              style: TextStyle(
                color: effectiveColor,
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
