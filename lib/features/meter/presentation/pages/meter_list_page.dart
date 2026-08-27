import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/home/presentation/bloc/home_bloc.dart';
import 'package:gezi/features/home/presentation/bloc/home_event.dart';
import 'package:gezi/features/meter/domain/entities/meter.dart';
import 'package:gezi/features/meter/presentation/widgets/meter_card.dart';
import 'package:gezi/injection_container.dart';
import 'package:go_router/go_router.dart';

/// Tela de listagem de contadores do utilizador.
///
/// Exibe todos os contadores associados à conta, com destaque para o contador
/// principal. Permite adicionar um novo contador através do botão de ação.
class MeterListPage extends StatefulWidget {
  const MeterListPage({super.key});

  @override
  State<MeterListPage> createState() => _MeterListPageState();

  // ── Dados mockados ──
  static List<Meter> mockMeters = [
    const Meter(
      id: '1',
      alias: 'Casa principal',
      serialNumber: '12345678901',
      isOnline: true,
      isPrimary: true,
      kwhBalance: 4.9,
      iconType: MeterIconType.home,
    ),
    const Meter(
      id: '2',
      alias: 'Escritório',
      serialNumber: '12345678902',
      isOnline: true,
      isPrimary: false,
      kwhBalance: 18.7,
      iconType: MeterIconType.office,
    ),
    const Meter(
      id: '3',
      alias: 'Armazém',
      serialNumber: '12345678903',
      isOnline: false,
      isPrimary: false,
      kwhBalance: 0,
      iconType: MeterIconType.store,
    ),
  ];
}

class _MeterListPageState extends State<MeterListPage> {
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
                context.push('/meters/register');
              }),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: MeterListPage.mockMeters.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final meter = MeterListPage.mockMeters[index];
                    return MeterCard(
                      meter: meter,
                      onSetPrimary: () {
                        setState(() {
                          // Update all meters
                          MeterListPage.mockMeters = MeterListPage.mockMeters.map((m) {
                            if (m.id == meter.id) {
                              return m.copyWith(isPrimary: true);
                            }
                            return m.copyWith(isPrimary: false);
                          }).toList();
                        });
                        
                        // Notify HomeBloc to reload with the new primary meter
                        sl<HomeBloc>().add(const HomeDashboardLoadRequested());

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${meter.alias} definido como principal')),
                        );
                      },
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
