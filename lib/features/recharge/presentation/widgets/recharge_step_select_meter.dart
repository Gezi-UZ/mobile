import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/injection_container.dart';
import '../../../meter/domain/entities/meter.dart';
import '../../../meter/presentation/bloc/meter_bloc.dart';
import '../../../meter/presentation/bloc/meter_state.dart';
import '../../../meter/presentation/bloc/meter_event.dart';

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
  String? _selectedMeterNumber;

  @override
  void initState() {
    super.initState();
    _selectedMeterNumber = widget.selectedMeterNumber;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeterBloc, MeterState>(
      bloc: sl<MeterBloc>()..add(const MeterListRequested()),
      builder: (context, state) {
        List<Meter> meters = [];
        if (state is MeterLoaded) {
          meters = state.meters;
        }

        if (state is MeterLoading && meters.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
            ),
          );
        }

        if (meters.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.electric_meter_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum contador associado',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione um contador para realizar recargas.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        // Initialize selection if null
        if (_selectedMeterNumber == null && meters.isNotEmpty) {
          final primary = meters.firstWhere(
            (m) => m.isPrimary,
            orElse: () => meters.first,
          );
          _selectedMeterNumber = primary.serialNumber;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onMeterSelected(primary.serialNumber);
          });
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: meters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final meter = meters[index];
                    final isSelected = _selectedMeterNumber == meter.serialNumber;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMeterNumber = meter.serialNumber;
                        });
                        widget.onMeterSelected(meter.serialNumber);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: isSelected
                              ? Theme.of(context).extension<AppColorsExtension>()!.lightOrangeBackground
                              : Colors.white,
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
                                        meter.alias,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurface,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      if (meter.isPrimary) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryOrange
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'Favorito',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
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
                                    meter.serialNumber,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                                color: isSelected
                                    ? AppTheme.primaryOrange
                                    : Colors.transparent,
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
                                            borderRadius:
                                                BorderRadius.circular(4),
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
                onTap: _selectedMeterNumber != null ? widget.onNext : null,
                child: Opacity(
                  opacity: _selectedMeterNumber != null ? 1.0 : 0.50,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: ShapeDecoration(
                      color: _selectedMeterNumber != null
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
      },
    );
  }
}
