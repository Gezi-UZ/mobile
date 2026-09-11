import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/faq_item_card.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Perguntas frequentes',
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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  _buildSectionTitle(context, 'RECARGA'),
                  const SizedBox(height: 4),
                  const FaqItemCard(
                    question: 'Porque o meu saldo não actualizou imediatamente?',
                    answer: 'A comunicação com o contador pode demorar alguns minutos. Verifique a ligação à internet ou tente reiniciar a aplicação.',
                  ),
                  const FaqItemCard(
                    question: 'Posso recarregar sem internet?',
                    answer: 'Não é possível iniciar uma nova recarga sem ligação. O histórico e saldo em cache ficam disponíveis offline.',
                  ),
                  const FaqItemCard(
                    question: 'Como funciona a recarga para outra pessoa?',
                    answer: 'Basta introduzir o número de telefone ou contador associado à conta do destinatário. Ele receberá a recarga imediatamente.',
                  ),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'PAGAMENTO'),
                  const SizedBox(height: 4),
                  const FaqItemCard(
                    question: 'Quais os métodos de pagamento aceites?',
                    answer: 'Aceitamos pagamentos por M-Pesa, E-Mola e cartões de crédito/débito nacionais.',
                  ),
                  const FaqItemCard(
                    question: 'O que acontece se o pagamento falhar?',
                    answer: 'O valor não será deduzido da sua conta. Caso aconteça, contacte o apoio ao cliente com o comprovativo.',
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'CONTADOR'),
                  const SizedBox(height: 4),
                  const FaqItemCard(
                    question: 'Como adicionar um novo contador?',
                    answer: 'Vá a Perfil > Os meus contadores e toque em "Adicionar novo contador".',
                  ),
                  const FaqItemCard(
                    question: 'Onde encontro o número do meu contador?',
                    answer: 'O número do contador está impresso no próprio aparelho, geralmente no formato de 11 dígitos.',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.primaryOrange,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.30,
          ),
    );
  }
}
