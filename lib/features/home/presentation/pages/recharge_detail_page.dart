import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart';
import 'package:intl/intl.dart';

class RechargeDetailPage extends StatelessWidget {
  final Recharge recharge;

  const RechargeDetailPage({
    super.key,
    required this.recharge,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSuccess = recharge.status == RechargeStatus.success;
    final isMyMeter = recharge.isMyMeter;

    final badgeColor = isMyMeter 
        ? (isDark ? const Color(0xFFFF8C38) : const Color(0xFFE84300)) 
        : (isDark ? const Color(0xFFFFC107) : const Color(0xFF8A5500));
    final badgeBgColor = isMyMeter 
        ? (isDark ? const Color(0x33FF6A00) : const Color(0x11FF6A00)) 
        : (isDark ? const Color(0x33FFB300) : const Color(0x17FFB300));
    final badgeText = isMyMeter ? 'Meu contador' : 'Outro';
    final smallBadgeText = isMyMeter ? 'Meu' : 'Outro';

    final meterTitle = isMyMeter ? 'Aplicado no meu contador' : 'Aplicado em outro contador';
    final meterSubtitle = isMyMeter
        ? '${recharge.meterAlias ?? ''} · ${recharge.meterSerialNumber}'
        : recharge.meterSerialNumber;

    final formattedDate = DateFormat('dd MMM yyyy', 'pt_PT').format(recharge.rechargedAt);
    final formattedTime = DateFormat('HH:mm').format(recharge.rechargedAt);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF331600) : Theme.of(context).extension<AppColorsExtension>()?.lightOrangeBackground ?? const Color(0xFFFFF6ED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/recharge_icon.png',
                        color: AppTheme.primaryOrange,
                        height: 20,
                        width: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Detalhe da recarga',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Valor e Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isSuccess 
                            ? (isDark ? const Color(0xFF052E16) : const Color(0x172E7D32)) 
                            : (isDark ? const Color(0xFF450A0A) : const Color(0xFFFFEDED)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        isSuccess ? Icons.check_circle : Icons.error,
                        color: isSuccess 
                            ? (isDark ? const Color(0xFF00C950) : const Color(0xFF2E7D32)) 
                            : (isDark ? const Color(0xFFFF453A) : const Color(0xFFFF3B30)),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${recharge.kwhAmount.toStringAsFixed(1)} kWh',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSuccess 
                                ? (isDark ? const Color(0xFF052E16) : const Color(0xFFDCFCE7)) 
                                : (isDark ? const Color(0xFF450A0A) : const Color(0xFFFFEDED)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isSuccess ? 'Recarga concluída' : 'Recarga falhou',
                            style: TextStyle(
                              color: isSuccess 
                                  ? (isDark ? const Color(0xFF00C950) : const Color(0xFF008236)) 
                                  : (isDark ? const Color(0xFFFF453A) : const Color(0xFFFF3B30)),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              color: badgeColor,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Contador Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.flash_on, // Ou outro ícone genérico de energia
                          color: badgeColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meterTitle,
                              style: TextStyle(
                                color: isDark ? Colors.white60 : const Color(0xFF666666),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              meterSubtitle,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          smallBadgeText,
                          style: TextStyle(
                            color: badgeColor,
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Info Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFF6ED),
                    borderRadius: BorderRadius.circular(16),
                    border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.10)) : null,
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(context, 'ID', recharge.id),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, 'Data e hora', '$formattedDate · $formattedTime'),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, 'Valor pago', '${recharge.paidAmount.toStringAsFixed(2)} ${recharge.currency}'),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, 'Crédito', '${recharge.kwhAmount.toStringAsFixed(1)} kWh'),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, 'Método', recharge.paymentMethod),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, 'Contador', recharge.meterSerialNumber),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, 'Destinatário', isMyMeter ? 'Próprio' : 'Outro', noBorder: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Botão
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFF6A00), Color(0xFFE84300)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      // Ver comprovativo PDF action
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 20),
                    label: const Text(
                      'Ver comprovativo PDF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {bool noBorder = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: noBorder
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: isDark ? Colors.white.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.08),
                ),
              ),
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white60 : const Color(0xFF666666),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
