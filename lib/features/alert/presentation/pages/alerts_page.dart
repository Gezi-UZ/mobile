import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/alert_toggle_item.dart';
import '../widgets/notification_card.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  bool isLowBalanceEnabled = false;
  bool isRechargeConfirmedEnabled = true;
  bool isPaymentFailedEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textColorDark),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alertas',
                style: GoogleFonts.inter(
                  color: AppTheme.textColorDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.40,
                ),
              ),
              const SizedBox(height: 24),
              
              // CONFIGURAR ALERTAS
              Text(
                'CONFIGURAR ALERTAS',
                style: GoogleFonts.inter(
                  color: AppTheme.textColorSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                  letterSpacing: 0.30,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08),
                    width: 0.88,
                  ),
                ),
                child: Column(
                  children: [
                    AlertToggleItem(
                      title: 'Saldo baixo',
                      value: isLowBalanceEnabled,
                      onChanged: (value) {
                        setState(() {
                          isLowBalanceEnabled = value;
                        });
                      },
                    ),
                    AlertToggleItem(
                      title: 'Recarga confirmada',
                      value: isRechargeConfirmedEnabled,
                      onChanged: (value) {
                        setState(() {
                          isRechargeConfirmedEnabled = value;
                        });
                      },
                    ),
                    AlertToggleItem(
                      title: 'Falha de pagamento',
                      value: isPaymentFailedEnabled,
                      onChanged: (value) {
                        setState(() {
                          isPaymentFailedEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // NOTIFICAÇÕES RECENTES
              Text(
                'NOTIFICAÇÕES RECENTES',
                style: GoogleFonts.inter(
                  color: AppTheme.textColorSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                  letterSpacing: 0.30,
                ),
              ),
              const SizedBox(height: 12),
              
              const NotificationCard(
                title: 'Saldo baixo',
                description: 'O seu saldo está abaixo de 5 kWh. Recarregue para evitar interrupção.',
                time: 'há 2 horas',
                icon: Icons.warning_amber_rounded,
                iconBackgroundColor: Color(0xFFFEF9C2),
                iconColor: Color(0xFFEAB308), // A matching yellow for the icon
              ),
              const NotificationCard(
                title: 'Recarga confirmada',
                description: '18.5 kWh adicionados ao contador CRED-4892.',
                time: 'há 1 dia',
                icon: Icons.check_circle_outline,
                iconBackgroundColor: Color(0xFFDCFCE7),
                iconColor: Color(0xFF22C55E), // A matching green for the icon
              ),
              const NotificationCard(
                title: 'Pagamento falhou',
                description: 'O pagamento via M-Pesa não foi confirmado. Nenhum valor foi cobrado.',
                time: 'há 1 dia',
                icon: Icons.error_outline,
                iconBackgroundColor: Color(0xFFFFE2E2),
                iconColor: Color(0xFFEF4444), // A matching red for the icon
              ),
            ],
          ),
        ),
      ),
    );
  }
}
