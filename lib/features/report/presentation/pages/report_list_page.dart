import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gezi/features/history/presentation/bloc/history_cubit.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_bloc.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_state.dart';
import 'package:gezi/injection_container.dart';
import 'package:intl/intl.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart' as home_recharge;
import '../widgets/transaction_list_item.dart';

class ReportListPage extends StatelessWidget {
  const ReportListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HistoryCubit>()),
        BlocProvider.value(value: sl<MeterBloc>()),
      ],
      child: const ReportListPageView(),
    );
  }
}

class ReportListPageView extends StatefulWidget {
  const ReportListPageView({super.key});

  @override
  State<ReportListPageView> createState() => _ReportListPageViewState();
}

class _ReportListPageViewState extends State<ReportListPageView> {
  @override
  void initState() {
    super.initState();
    final meterState = context.read<MeterBloc>().state;
    if (meterState is MeterLoaded && meterState.meters.isNotEmpty) {
      final selectedMeter = meterState.primaryMeter ?? meterState.meters.first;
      context.read<HistoryCubit>().fetchHistoryData(selectedMeter.id, 'year');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Relatórios',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Histórico de Transações',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Expanded(
              child: BlocConsumer<MeterBloc, MeterState>(
                listener: (context, meterState) {
                  if (meterState is MeterLoaded && meterState.meters.isNotEmpty) {
                    final selectedMeter = meterState.primaryMeter ?? meterState.meters.first;
                    context.read<HistoryCubit>().fetchHistoryData(selectedMeter.id, 'year');
                  }
                },
                builder: (context, meterState) {
                  return BlocBuilder<HistoryCubit, HistoryState>(
                    builder: (context, state) {
                      if (state is HistoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is HistoryError) {
                        return Center(child: Text('Erro: ${state.message}'));
                      } else if (state is HistoryLoaded) {
                        if (state.recharges.isEmpty) {
                          return const Center(child: Text('Nenhuma transacção encontrada.'));
                        }

                        return ListView.builder(
                          itemCount: state.recharges.length,
                          itemBuilder: (context, index) {
                            final recharge = state.recharges[index];
                            final dateStr = DateFormat('dd MMMM yyyy, HH:mm', 'pt_PT').format(recharge.createdAt);

                            return InkWell(
                              onTap: () {
                                final lowerStatus = recharge.status.toLowerCase();
                                home_recharge.RechargeStatus mappedStatus = home_recharge.RechargeStatus.pending;
                                if (lowerStatus == 'success' || lowerStatus == 'concluída') {
                                  mappedStatus = home_recharge.RechargeStatus.success;
                                } else if (lowerStatus == 'failed' || lowerStatus == 'falhou') {
                                  mappedStatus = home_recharge.RechargeStatus.failed;
                                }

                                final homeRechargeObj = home_recharge.Recharge(
                                  id: recharge.id,
                                  kwhAmount: recharge.creditKwh,
                                  paidAmount: recharge.amountMzn,
                                  currency: 'MZN',
                                  rechargedAt: recharge.createdAt,
                                  status: mappedStatus,
                                  meterSerialNumber: recharge.meterId,
                                  isMyMeter: true,
                                  paymentMethod: recharge.paymentMethod ?? 'M-Pesa',
                                  paymentReference: recharge.paymentReference,
                                );
                                context.push('/receipt_preview', extra: homeRechargeObj);
                              },
                              child: TransactionListItem(
                                title: 'Recarga de Saldo',
                                date: dateStr,
                                amount: '${recharge.amountMzn.toStringAsFixed(0)} MT',
                                isCredit: true,
                                icon: Icons.add_card,
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
