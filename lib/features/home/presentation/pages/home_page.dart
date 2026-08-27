import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gezi/features/home/presentation/bloc/home_bloc.dart';
import 'package:gezi/features/home/presentation/bloc/home_event.dart';
import 'package:gezi/features/home/presentation/bloc/home_state.dart';
import 'package:gezi/features/home/presentation/widgets/dashboard_header_widgets.dart';
import 'package:gezi/features/home/presentation/widgets/low_balance_alert_widget.dart';
import 'package:gezi/features/home/presentation/widgets/meter_card_widget.dart';
import 'package:gezi/features/home/presentation/widgets/quick_actions_widget.dart';
import 'package:gezi/features/home/presentation/widgets/recharge_actions_widget.dart';
import 'package:gezi/features/home/presentation/widgets/recent_recharges_widget.dart';
import 'package:gezi/injection_container.dart';
import '../../../../core/theme/theme.dart';
import '../../../../features/meter/presentation/pages/meter_list_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Inicia o carregamento se ainda não tiver dados
    if (sl<HomeBloc>().state is HomeInitial) {
      sl<HomeBloc>().add(const HomeDashboardLoadRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<HomeBloc>(),
      child: Scaffold(
        backgroundColor: AppTheme.white,
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeError) {
                return Center(child: Text(state.message));
              }
              if (state is HomeLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardHeaderWidget(
                        userName: 'Dai Wen Xuan',
                        notificationCount: state.notificationCount,
                      ),
                      if (state.meterBalance.isLowBalance)
                        const LowBalanceAlertWidget(),
                      Builder(
                        builder: (context) {
                          final meter = MeterListPage.mockMeters.firstWhere(
                            (m) => m.serialNumber == state.meterBalance.meterId,
                            orElse: () => MeterListPage.mockMeters.first,
                          );
                          return GestureDetector(
                            onTap: () {
                              context.push('/meters/detail', extra: {
                                'meter': meter,
                                'recharges': state.recentRecharges,
                              });
                            },
                            child: MeterCardWidget(
                              balance: state.meterBalance,
                              isPrimary: meter.isPrimary,
                            ),
                          );
                        }
                      ),
                      RechargeActionsWidget(
                        onRecharge: () => context.push('/recharge'),
                        onHistory: () => context.push('/recharge?someone=true'),
                      ),
                      QuickActionsWidget(
                        onMeters: () => context.go('/meters'),
                      ),
                      RecentRechargesWidget(
                        recharges: state.recentRecharges,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
