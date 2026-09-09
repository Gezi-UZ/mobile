import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/home/domain/entities/meter_balance.dart';
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

import '../../../../features/meter/domain/entities/meter.dart';
import '../../../../features/meter/presentation/bloc/meter_bloc.dart';
import '../../../../features/meter/presentation/bloc/meter_event.dart';
import '../../../../features/meter/presentation/bloc/meter_state.dart';
import '../../../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../../../features/profile/presentation/bloc/profile_event.dart';
import '../../../../features/profile/presentation/bloc/profile_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (sl<HomeBloc>().state is HomeInitial) {
      sl<HomeBloc>().add(const HomeDashboardLoadRequested());
    }
    // Load profile for the header name
    sl<ProfileBloc>().add(const ProfileLoadRequested());
    // Load meters
    sl<MeterBloc>().add(const MeterListRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<HomeBloc>()),
        BlocProvider.value(value: sl<ProfileBloc>()),
        BlocProvider.value(value: sl<MeterBloc>()),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                return RefreshIndicator(
                  color: AppTheme.primaryOrange,
                  onRefresh: () async {
                    sl<HomeBloc>().add(
                      const HomeDashboardLoadRequested(isRefresh: true),
                    );
                    sl<ProfileBloc>().add(const ProfileLoadRequested());
                    sl<MeterBloc>().add(const MeterListRequested());
                    await sl<HomeBloc>().stream.firstWhere(
                      (s) => s is HomeLoaded || s is HomeError,
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, profileState) {
                            final name = profileState is ProfileLoaded
                                ? profileState.profile.nome
                                : profileState is ProfileUpdateSuccess
                                ? profileState.profile.nome
                                : 'Bem-vindo';
                            return DashboardHeaderWidget(
                              userName: name,
                              notificationCount: state.notificationCount,
                            );
                          },
                        ),
                        if (state.meterBalance.isLowBalance)
                          LowBalanceAlertWidget(
                            balance: state.meterBalance.kwhBalance,
                          ),
                        BlocBuilder<MeterBloc, MeterState>(
                          builder: (context, meterState) {
                            Meter? meter;
                            if (meterState is MeterLoaded &&
                                meterState.meters.isNotEmpty) {
                              meter = meterState.meters
                                  .cast<Meter>()
                                  .firstWhere(
                                    (m) =>
                                        m.serialNumber ==
                                        state.meterBalance.meterId,
                                    orElse: () =>
                                        meterState.primaryMeter ??
                                        meterState.meters.first,
                                  );
                            }
                            final activeMeter =
                                meter ??
                                Meter(
                                  id: state.meterBalance.meterId,
                                  alias: 'Contador Principal',
                                  serialNumber: state.meterBalance.meterId,
                                  isOnline: state.meterBalance.isOnline,
                                  isPrimary: true,
                                  kwhBalance: state.meterBalance.kwhBalance,
                                  iconType: MeterIconType.home,
                                );

                            final activeBalance = MeterBalance(
                              kwhBalance: activeMeter.kwhBalance,
                              meterId: activeMeter.serialNumber,
                              isOnline: activeMeter.isOnline,
                              lastSyncAt: activeMeter.lastSyncAt ?? DateTime.now(),
                              isLowBalance: activeMeter.kwhBalance < 5.0,
                            );

                            return GestureDetector(
                              onTap: () {
                                context.push(
                                  '/meters/detail',
                                  extra: {
                                    'meter': activeMeter,
                                    'recharges': state.recentRecharges,
                                  },
                                );
                              },
                              child: MeterCardWidget(
                                balance: activeBalance,
                                isPrimary: activeMeter.isPrimary,
                                meterAlias: activeMeter.alias,
                              ),
                            );
                          },
                        ),
                        RechargeActionsWidget(
                          onRecharge: () => context.push('/recharge'),
                          onHistory: () =>
                              context.push('/recharge?someone=true'),
                        ),
                        QuickActionsWidget(
                          onMeters: () => context.go('/meters'),
                        ),
                        RecentRechargesWidget(recharges: state.recentRecharges),
                      ],
                    ),
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
