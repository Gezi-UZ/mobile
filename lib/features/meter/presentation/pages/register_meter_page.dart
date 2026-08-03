import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

/// Placeholder para a tela de registo de um novo contador.
///
/// TODO: Implementar formulário de registo de contador.
class RegisterMeterPage extends StatelessWidget {
  const RegisterMeterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColorDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Adicionar contador',
          style: TextStyle(
            color: AppTheme.textColorDark,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.electric_meter_outlined,
              size: 64,
              color: Color(0x66FF6A00),
            ),
            SizedBox(height: 16),
            Text(
              'Em breve',
              style: TextStyle(
                color: AppTheme.textColorSecondary,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
