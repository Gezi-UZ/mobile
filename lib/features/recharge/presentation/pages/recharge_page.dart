import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gezi/core/theme/theme.dart';
import '../../../auth/presentation/widgets/step_progress_indicator.dart';
import '../widgets/recharge_step_amount.dart';
import '../widgets/recharge_step_meter.dart';
import '../widgets/recharge_step_select_meter.dart';
import '../widgets/recharge_step_confirm.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/recharge_bloc.dart';

import '../../../meter/presentation/bloc/meter_bloc.dart';
import '../../../meter/presentation/bloc/meter_state.dart';

class RechargePage extends StatefulWidget {
  final bool isForSomeone;

  const RechargePage({super.key, this.isForSomeone = false});

  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  String _amount = '0';
  String _meterNumber = '';

  @override
  void initState() {
    super.initState();
    // Inicializa com o contador favorito real se disponível
    if (!widget.isForSomeone) {
      final meterState = sl<MeterBloc>().state;
      if (meterState is MeterLoaded && meterState.meters.isNotEmpty) {
        final primary = meterState.primaryMeter ?? meterState.meters.first;
        _meterNumber = primary.serialNumber;
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(BuildContext context, {String? phone}) {
    const int totalSteps = 3;
    if (_currentStep < totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Step 3 Confirmation -> Iniciar Recarga via BLoC
      context.read<RechargeBloc>().add(
        InitiateRechargeEvent(
          amount: double.parse(_amount),
          meterId: _meterNumber,
          method: 'MPESA',
          phone: phone,
        ),
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home');
      }
    }
  }

  String get _title {
    if (widget.isForSomeone) {
      return 'Recarregar para alguém';
    }
    return 'Recarregar energia';
  }

  String get _stepLabel {
    if (widget.isForSomeone) {
      if (_currentStep == 0) return 'Contador';
      if (_currentStep == 1) return 'Valor';
      return 'Pagamento';
    } else {
      if (_currentStep == 0) return 'Valor';
      if (_currentStep == 1) return 'Contador';
      return 'Pagamento';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RechargeBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
        child: BlocConsumer<RechargeBloc, RechargeState>(
          listener: (context, state) {
            if (state is RechargeInitiated) {
              context.go(Uri(
                path: '/recharge/status',
                queryParameters: {
                  'amount': _amount,
                  'meterNumber': _meterNumber,
                  'rechargeId': state.recharge.id,
                },
              ).toString());
            } else if (state is RechargeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is RechargeLoading;
            
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _previousPage,
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),

                    // Step Progress Indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: StepProgressIndicator(
                        currentStep: _currentStep + 1,
                        label: _stepLabel,
                      ),
                    ),

                    // PageView Content
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(), // Desativa o swipe manual
                        onPageChanged: (index) {
                          setState(() {
                            _currentStep = index;
                          });
                        },
                        children: widget.isForSomeone
                            ? [
                                RechargeStepMeter(onNext: (val) {
                                  _meterNumber = val;
                                  _nextPage(context);
                                }),
                                RechargeStepAmount(
                                  isForSomeone: true,
                                  meterNumber: _meterNumber,
                                  onNext: (val) {
                                    setState(() => _amount = val);
                                    _nextPage(context);
                                  },
                                ),
                                RechargeStepConfirm(
                                  amount: _amount,
                                  meterNumber: _meterNumber,
                                  isForSomeone: true,
                                  onConfirm: (phone) => _nextPage(context, phone: phone),
                                ),
                              ]
                            : [
                                RechargeStepAmount(
                                  isForSomeone: false,
                                  meterNumber: _meterNumber,
                                  onNext: (val) {
                                    setState(() => _amount = val);
                                    _nextPage(context);
                                  },
                                ),
                                RechargeStepSelectMeter(
                                  selectedMeterNumber: _meterNumber,
                                  onMeterSelected: (val) => setState(() => _meterNumber = val),
                                  onNext: () => _nextPage(context),
                                ),
                                RechargeStepConfirm(
                                  amount: _amount,
                                  meterNumber: _meterNumber,
                                  isForSomeone: false,
                                  onConfirm: (phone) => _nextPage(context, phone: phone),
                                ),
                              ],
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ),
  );
  }
}


