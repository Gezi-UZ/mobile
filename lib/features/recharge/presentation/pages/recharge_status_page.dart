import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/recharge.dart';
import '../bloc/recharge_bloc.dart';

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
  @override
  void initState() {
    super.initState();
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
          // If we navigate from Step 3 without an ID, we initiate here
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
                // Now we have the rechargeId, start streaming
                context.read<RechargeBloc>().add(StreamRechargeStatusEvent(state.recharge.id));
              }
              if (state is RechargeSuccess) {
                // Sucesso
              }
            },
            builder: (context, state) {
              String status = 'PENDING';
              Recharge? currentRecharge;

              if (state is RechargeStatusUpdated) {
                status = state.recharge.status.toUpperCase();
                currentRecharge = state.recharge;
              } else if (state is RechargeSuccess) {
                status = 'SUCCESS'; // Forçado quando é sucesso
                currentRecharge = state.recharge;
              } else if (state is RechargeError) {
                status = 'FAILED';
              }

              bool isPaymentConfirmed = status == 'CONFIRMED' || 
                                        status == 'MQTT_SENT' || 
                                        status == 'CONCLUIDA' || 
                                        status == 'SUCCESS';

              bool isConcluida = status == 'CONCLUIDA' || 
                                 status == 'SUCCESS';

              return Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 24,
                      right: 24,
                      bottom: 4,
                    ),
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
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 24,
                        right: 24,
                        bottom: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Título e subtítulo
                          Text(
                            widget.isCodeRecharge
                                ? 'Estado do código STS'
                                : 'Estado da recarga',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.isCodeRecharge
                          ? 'A aplicar código'
                          : 'A processar pagamento',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Ícone principal e sumário
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF00C950),
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.isCodeRecharge
                          ? 'Código Válido'
                          : '+${estimatedKwh.toStringAsFixed(1)} kWh',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isConcluida ? const Color(0xFF008236) : AppTheme.primaryOrange,
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Lista de Passos de Processamento
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: widget.isCodeRecharge
                            ? [
                                const _StatusStepItem(
                                  title: 'Código validado',
                                  description:
                                      'O código STS introduzido é válido.',
                                  isCompleted: true,
                                  isLast: false,
                                ),
                                _StatusStepItem(
                                  title: 'A comunicar com o contador',
                                  description:
                                      'A aguardar confirmação do dispositivo...',
                                  isCompleted: isConcluida,
                                  isLast: false,
                                ),
                                _StatusStepItem(
                                  title: 'Crédito aplicado!',
                                  description:
                                      'A operação foi concluída com sucesso.',
                                  isCompleted: isConcluida,
                                  isLast: true,
                                ),
                              ]
                            : [
                                const _StatusStepItem(
                                  title: 'Pagamento solicitado',
                                  description: 'O seu pedido foi recebido.',
                                  isCompleted: true,
                                  isLast: false,
                                ),
                                _StatusStepItem(
                                  title: 'A aguardar M-Pesa',
                                  description:
                                      'Confirme o PIN no seu telemóvel.',
                                  isCompleted: isPaymentConfirmed,
                                  isLast: false,
                                ),
                                _StatusStepItem(
                                  title: 'A aplicar crédito',
                                  description: 'Comunicando com o contador...',
                                  isCompleted: isConcluida,
                                  isLast: false,
                                ),
                                _StatusStepItem(
                                  title: 'Recarga concluída!',
                                  description:
                                      'Crédito adicionado com sucesso.',
                                  isCompleted: isConcluida, 
                                  isLast: true,
                                ),
                              ],
                      ),
                    ),

                    // Botão para ver Comprovativo (Simulação do fim do processo)
                    if (isConcluida && currentRecharge != null)
                      GestureDetector(
                        onTap: () {
                          // Fix for type casting exception
                          // Map Recharge from features/recharge to Recharge from features/home
                          final mappedRecharge = currentRecharge != null
                              ? {
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
                                }
                              : null;

                          // We use the JSON parsing constructor in app_router/receipt to handle this map if we pass a model.
                          // Wait, app_router expects `extra['recharge']` to be a Recharge object from features/home.
                          // However, we don't have access to features/home/domain/entities/recharge.dart inside this onTap easily without importing.
                          // So we'll pass the JSON map and let app_router construct it or we can import it.
                          // Let's rely on GoRouter extra.
                          context.go(
                            '/recharge/receipt',
                            extra: {
                              'rechargeJson': mappedRecharge, // We will update app_router to read this
                              'isCodeRecharge': widget.isCodeRecharge,
                              'code': widget.code ?? currentRecharge?.token,
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
  final bool isCompleted;
  final bool isLast;

  const _StatusStepItem({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isCompleted
        ? const Color(0xFF00C950)
        : AppTheme.primaryOrange;
    final Color titleColor = isCompleted
        ? const Color(0xFF008236)
        : AppTheme.primaryOrange;
    final Color lineColor = isCompleted
        ? const Color(0xFF05DF72)
        : Colors.transparent;

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
                ),
                child: const Center(
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                ),
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
              padding: const EdgeInsets.only(bottom: 32),
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
