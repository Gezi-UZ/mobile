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
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>()
        ..add(const HomeDashboardLoadRequested()),
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
                      MeterCardWidget(
                        balance: state.meterBalance,
                      ),
                      RechargeActionsWidget(
                        onRecharge: () => context.push('/recharge'),
                        onHistory: () => context.push('/recharge?someone=true'),
                      ),
                      const QuickActionsWidget(),
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
