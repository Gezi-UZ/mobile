import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/equipment_estimation_card.dart';
import '../widgets/equipment_list_item.dart';

class EquipmentEstimationPage extends StatelessWidget {
  const EquipmentEstimationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 48,
            left: 20,
            right: 20,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppTheme.textColorDark,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Os meus equipamentos',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textColorDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      height: 1.56,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const EquipmentEstimationCard(
                estimateValue: 4.08,
              ),
              const SizedBox(height: 20),
              EquipmentListItem(
                icon: Icons.kitchen,
                title: 'Frigorífico',
                consumptionDetail: '150W · 24h/dia = 3.60 kWh',
                onDelete: () {},
              ),
              EquipmentListItem(
                icon: Icons.tv,
                title: 'Televisão',
                consumptionDetail: '80W · 6h/dia = 0.48 kWh',
                onDelete: () {},
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1.11,
                        color: AppTheme.primaryOrange,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Adicionar equipamento',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.43,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: ShapeDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Ver estimativa de consumo',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
