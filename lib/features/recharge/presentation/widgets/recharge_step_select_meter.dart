import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class RechargeStepSelectMeter extends StatefulWidget {
  final VoidCallback onNext;
  final Function(String) onMeterSelected;
  final String? selectedMeterNumber;

  const RechargeStepSelectMeter({
    super.key,
    required this.onNext,
    required this.onMeterSelected,
    this.selectedMeterNumber,
  });

  @override
  State<RechargeStepSelectMeter> createState() => _RechargeStepSelectMeterState();
}

class _RechargeStepSelectMeterState extends State<RechargeStepSelectMeter> {
  // Lista fictícia de contadores do utilizador (o 1º é o favorito por padrão)
  final List<Map<String, String>> _meters = [
    {
      'name': 'Casa',
      'number': '12345678901',
      'isFavorite': 'true',
    },
    {
      'name': 'Escritório',
      'number': '98765432109',
      'isFavorite': 'false',
    },
  ];

  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.selectedMeterNumber != null) {
      final index = _meters.indexWhere((m) => m['number'] == widget.selectedMeterNumber);
      if (index != -1) {
        _selectedIndex = index;
      } else {
        _selectedIndex = 0;
      }
    } else {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _meters.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final meter = _meters[index];
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    widget.onMeterSelected(meter['number']!);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      color: isSelected ? AppTheme.lightOrangeBackground : Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.11,
                          color: isSelected
                              ? AppTheme.primaryOrange
                              : Colors.black.withValues(alpha: 0.08),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF5F5F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.electric_meter_outlined,
                              color: AppTheme.primaryOrange,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    meter['name']!,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: AppTheme.textColorDark,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  if (meter['isFavorite'] == 'true') ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Favorito',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppTheme.primaryOrange,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                meter['number']!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textColorSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: ShapeDecoration(
                            color: isSelected ? AppTheme.primaryOrange : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.11,
                                color: isSelected
                                    ? AppTheme.primaryOrange
                                    : Colors.black.withValues(alpha: 0.08),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Botão Continuar
          GestureDetector(
            onTap: _selectedIndex != null ? widget.onNext : null,
            child: Opacity(
              opacity: _selectedIndex != null ? 1.0 : 0.50,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: ShapeDecoration(
                  color: _selectedIndex != null
                      ? AppTheme.primaryOrange
                      : const Color(0xFFCCCCCC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Continuar',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
