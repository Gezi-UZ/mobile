import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/home/presentation/bloc/home_bloc.dart';
import 'package:gezi/features/home/presentation/bloc/home_event.dart';

import 'package:gezi/features/meter/presentation/widgets/meter_card.dart';
import 'package:gezi/injection_container.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_bloc.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_event.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_state.dart';

/// Tela de listagem de contadores do utilizador.
///
/// Exibe todos os contadores associados à conta, com destaque para o contador
/// principal. Permite adicionar um novo contador através do botão de ação.
class MeterListPage extends StatefulWidget {
  const MeterListPage({super.key});

  @override
  State<MeterListPage> createState() => _MeterListPageState();
}

class _MeterListPageState extends State<MeterListPage> {
  @override
  void initState() {
    super.initState();
    sl<MeterBloc>().add(const MeterListRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<MeterBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                  child: BlocConsumer<MeterBloc, MeterState>(
                    listener: (context, state) {
                      if (state is MeterError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is MeterLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryOrange,
                            ),
                          ),
                        );
                      }

                      if (state is MeterError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<MeterBloc>()
                                      .add(const MeterListRequested());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryOrange,
                                  foregroundColor: Theme.of(context).colorScheme.surface,
                                ),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is MeterLoaded) {
                        if (state.meters.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.electric_meter_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Ainda não tem contadores associados',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Adicione o seu primeiro contador para começar a gerir energia.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.push('/meters/register');
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Adicionar contador'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryOrange,
                                    foregroundColor: Theme.of(context).colorScheme.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          color: AppTheme.primaryOrange,
                          onRefresh: () async {
                            context
                                .read<MeterBloc>()
                                .add(const MeterListRequested());
                          },
                          child: ListView.separated(
                            itemCount: state.meters.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final meter = state.meters[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push('/meters/detail', extra: {
                                    'meter': meter,
                                    'recharges': <dynamic>[],
                                  });
                                },
                                child: MeterCard(
                                  meter: meter,
                                  onSetPrimary: () {
                                    context.read<MeterBloc>().add(
                                          MeterSetPrimaryRequested(meter.id),
                                        );
                                    sl<HomeBloc>().add(
                                      const HomeDashboardLoadRequested(),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${meter.alias} definido como principal',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
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
        Expanded(
          child: Text(
            'Os meus contadores',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
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
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.surface,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
