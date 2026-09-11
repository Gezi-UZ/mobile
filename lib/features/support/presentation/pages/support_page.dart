import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/support_option_card.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 24),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: Theme.of(context).colorScheme.onSurface,
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Apoio ao cliente',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SupportOptionCard(
                    //   icon: Icons.chat_bubble_outline,
                    //   title: 'Chat com suporte',
                    //   description: 'Conversa em tempo real ou WhatsApp Business',
                    //   onTap: () {
                    //     // TODO: Implement chat logic
                    //   },
                    // ),
                    SupportOptionCard(
                      icon: Icons.phone_outlined,
                      title: 'Linha de apoio',
                      description: '800 100 200 · Toque para ligar directamente',
                      onTap: () {
                        // TODO: Implement phone call logic
                      },
                    ),
                    SupportOptionCard(
                      icon: Icons.help_outline,
                      title: 'Perguntas frequentes',
                      description: 'Respostas às dúvidas mais comuns',
                      onTap: () {
                        context.go('/profile/support/faq');
                      },
                    ),
                    // SupportOptionCard(
                    //   icon: Icons.report_problem_outlined,
                    //   title: 'Reportar um problema',
                    //   description: 'Formulário de ocorrência',
                    //   onTap: () {
                    //     // TODO: Implement report problem logic
                    //   },
                    // ),
                    
                    const SizedBox(height: 48),
                    
                    // Footer
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Horário de atendimento: Seg–Sex, 08h–18h',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colors?.textColorSecondary ?? AppTheme.textColorSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '800 100 200 · Gratuito',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.primaryOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
