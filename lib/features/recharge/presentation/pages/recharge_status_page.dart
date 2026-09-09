import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/recharge.dart';
import '../bloc/recharge_bloc.dart';

enum StepState { completed, processing, pending }

class RechargeStatusPage extends StatefulWidget {
  final String amount;
  final String meterNumber;
  final bool isCodeRecharge;
  final String? code;
  final String rechargeId;
  final String? meterId;
  final String? phone;

  const RechargeStatusPage({
    super.key,
    required this.amount,
    required this.meterNumber,
    required this.rechargeId,
    this.isCodeRecharge = true,
    this.code,
    this.meterId,
    this.phone,
  });

  @override
  State<RechargeStatusPage> createState() => _RechargeStatusPageState();
}

class _RechargeStatusPageState extends State<RechargeStatusPage> {
  bool _successDialogShown = false;

  @override
  void initState() {
    super.initState();
  }

  void _showSuccessDialog(Map<String, dynamic> mappedRecharge, Recharge currentRecharge) {
    if (_successDialogShown) return;
    _successDialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF00C950),
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Recarga Concluída!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pop();
        context.go(
          '/recharge/receipt',
          extra: {
            'rechargeJson': mappedRecharge,
            'isCodeRecharge': widget.isCodeRecharge,
            'code': widget.code ?? currentRecharge.token,
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double totalAmount = double.tryParse(widget.amount) ?? 0.0;
    const bool isFirstPurchaseOfMonth = true;
    const double ratePerKwh = 7.64;
    double txLixo = 0.0;
    if (isFirstPurchaseOfMonth) {
      if (totalAmount == 100.0) {
        txLixo = 50.0;
      } else if (totalAmount > 100.0) {
        txLixo = 100.0;
      }
    }
    const double txRadio = 0.0;
    const double dividaPaga = 0.0;

    final double remainingAfterFees =
        (totalAmount - txLixo - txRadio - dividaPaga).clamp(
          0.0,
          double.infinity,
        );
    final double estimatedKwh = remainingAfterFees / ratePerKwh;

    return BlocProvider(
      create: (_) {
        final bloc = sl<RechargeBloc>();
        if (!widget.isCodeRecharge && widget.rechargeId.isNotEmpty) {
          bloc.add(StreamRechargeStatusEvent(widget.rechargeId));
        } else if (widget.isCodeRecharge && widget.code != null && widget.code!.isNotEmpty) {
          bloc.add(ApplyCodeEvent(
            code: widget.code!,
          ));
        } else if (!widget.isCodeRecharge && widget.rechargeId.isEmpty) {
          bloc.add(InitiateRechargeEvent(
            amount: totalAmount,
            meterId: widget.meterId ?? widget.meterNumber,
            method: 'MPESA',
            phone: widget.phone,
          ));
        }
        return bloc;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: BlocConsumer<RechargeBloc, RechargeState>(
            listener: (context, state) {
              if (state is RechargeInitiated) {
                context.read<RechargeBloc>().add(StreamRechargeStatusEvent(state.recharge.id));
              }
              if (state is RechargeSuccess) {
                final currentRecharge = state.recharge;
                final mappedRecharge = {
                  'id': currentRecharge.id,
                  'kwhAmount': currentRecharge.creditKwh,
                  'paidAmount': currentRecharge.amountMzn,
                  'currency': 'MT',
                  'rechargedAt': currentRecharge.createdAt.toIso8601String(),
                  'status': 'SUCCESS',
                  'meterAlias': null,
                  'meterSerialNumber': currentRecharge.meterNumber ?? widget.meterNumber,
                  'isMyMeter': true,
                  'paymentMethod': widget.isCodeRecharge ? 'Código STS' : 'M-Pesa',
                };
                
                _showSuccessDialog(mappedRecharge, currentRecharge);
              }
            },
            builder: (context, state) {
              String status = 'PENDING';
              Recharge? currentRecharge;

              if (state is RechargeStatusUpdated) {
                status = state.recharge.status.toUpperCase();
                currentRecharge = state.recharge;
              } else if (state is RechargeSuccess) {
                status = 'SUCCESS';
                currentRecharge = state.recharge;
              } else if (state is RechargeError) {
                status = 'FAILED';
              }

              bool isMpesaConfirmed = status == 'CONFIRMED' || status == 'MQTT_SENT' || status == 'SUCCESS' || status == 'CONCLUIDA' || status == 'ACK_RECEIVED';
              bool isApplyingCredit = status == 'CONFIRMED' || status == 'MQTT_SENT';
              bool isConcluida = status == 'SUCCESS' || status == 'CONCLUIDA' || status == 'ACK_RECEIVED';
              bool isFailed = status == 'FAILED' || status == 'ERROR';

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/home');
                            }
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.isCodeRecharge ? 'Estado do código STS' : 'Estado da recarga',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.isCodeRecharge ? 'A aplicar código' : 'A processar pagamento',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 32),

                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: isFailed 
                                  ? const Color(0xFFFEE2E2) 
                                  : (isConcluida ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7)),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: isFailed 
                                  ? const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40)
                                  : (isConcluida 
                                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFF00C950), size: 40)
                                      : const SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: CircularProgressIndicator(color: AppTheme.primaryOrange, strokeWidth: 3),
                                        )),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.isCodeRecharge
                                ? (isConcluida ? 'Código Válido' : 'Validando...')
                                : (isFailed ? 'Falha no Pagamento' : '+${estimatedKwh.toStringAsFixed(1)} kWh'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isFailed 
                                  ? Colors.red 
                                  : (isConcluida ? const Color(0xFF008236) : AppTheme.primaryOrange),
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.isCodeRecharge
                                ? 'A ser aplicado ao contador ${currentRecharge?.meterNumber ?? widget.meterNumber}'
                                : 'adicionados ao contador ${currentRecharge?.meterNumber ?? widget.meterNumber}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 32),

                          Expanded(
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: widget.isCodeRecharge
                                  ? [
                                      const _StatusStepItem(
                                        title: 'Código validado',
                                        description: 'O código STS introduzido é válido.',
                                        state: StepState.completed,
                                        isLast: false,
                                      ),
                                      _StatusStepItem(
                                        title: 'A comunicar com o contador',
                                        description: 'A aguardar confirmação do dispositivo...',
                                        state: isConcluida ? StepState.completed : StepState.processing,
                                        isLast: false,
                                      ),
                                      _StatusStepItem(
                                        title: 'Crédito aplicado!',
                                        description: 'A operação foi concluída com sucesso.',
                                        state: isConcluida ? StepState.completed : StepState.pending,
                                        isLast: true,
                                      ),
                                    ]
                                  : [
                                      _StatusStepItem(
                                        title: 'Pagamento solicitado',
                                        description: 'O seu pedido foi recebido.',
                                        state: isFailed ? StepState.pending : StepState.completed,
                                        isLast: false,
                                      ),
                                      _StatusStepItem(
                                        title: 'A aguardar M-Pesa',
                                        description: 'Confirme o PIN no seu telemóvel.',
                                        state: isFailed 
                                            ? StepState.pending 
                                            : (isMpesaConfirmed ? StepState.completed : StepState.processing),
                                        isLast: false,
                                      ),
                                      _StatusStepItem(
                                        title: 'A aplicar crédito',
                                        description: 'Comunicando com o contador...',
                                        state: isFailed 
                                            ? StepState.pending 
                                            : (isConcluida ? StepState.completed : (isApplyingCredit ? StepState.processing : StepState.pending)),
                                        isLast: false,
                                      ),
                                      _StatusStepItem(
                                        title: 'Recarga concluída!',
                                        description: 'Crédito adicionado com sucesso.',
                                        state: isFailed 
                                            ? StepState.pending 
                                            : (isConcluida ? StepState.completed : StepState.pending),
                                        isLast: true,
                                      ),
                                    ],
                            ),
                          ),

                          if (isConcluida && currentRecharge != null && _successDialogShown)
                            GestureDetector(
                              onTap: () {
                                final recharge = currentRecharge;
                                if (recharge == null) return;
                                final mappedRecharge = {
                                  'id': recharge.id,
                                  'kwhAmount': recharge.creditKwh,
                                  'paidAmount': recharge.amountMzn,
                                  'currency': 'MT',
                                  'rechargedAt': recharge.createdAt.toIso8601String(),
                                  'status': 'SUCCESS',
                                  'meterAlias': null,
                                  'meterSerialNumber': recharge.meterNumber ?? widget.meterNumber,
                                  'isMyMeter': true,
                                  'paymentMethod': widget.isCodeRecharge ? 'Código STS' : 'M-Pesa',
                                };
                                context.go(
                                  '/recharge/receipt',
                                  extra: {
                                    'rechargeJson': mappedRecharge,
                                    'isCodeRecharge': widget.isCodeRecharge,
                                    'code': widget.code ?? recharge.token,
                                  },
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: ShapeDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Ver comprovativo',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                        ],
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

class _StatusStepItem extends StatelessWidget {
  final String title;
  final String description;
  final StepState state;
  final bool isLast;

  const _StatusStepItem({
    required this.title,
    required this.description,
    required this.state,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    Color titleColor;
    Color lineColor;
    Widget iconWidget;

    switch (state) {
      case StepState.completed:
        iconColor = const Color(0xFF00C950);
        titleColor = const Color(0xFF008236);
        lineColor = const Color(0xFF05DF72);
        iconWidget = const Icon(Icons.check, color: Colors.white, size: 16);
        break;
      case StepState.processing:
        iconColor = Theme.of(context).colorScheme.surface;
        titleColor = AppTheme.primaryOrange;
        lineColor = Colors.transparent;
        iconWidget = SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.primaryOrange,
          ),
        );
        break;
      case StepState.pending:
        iconColor = Theme.of(context).colorScheme.surfaceContainerHighest;
        titleColor = Theme.of(context).colorScheme.onSurfaceVariant;
        lineColor = Colors.transparent;
        iconWidget = Icon(Icons.circle, color: Theme.of(context).colorScheme.surfaceContainerHighest, size: 10);
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                  border: state == StepState.processing
                      ? Border.all(color: AppTheme.primaryOrange, width: 2)
                      : null,
                ),
                child: Center(child: iconWidget),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.only(top: 4, bottom: 4),
                    color: lineColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
