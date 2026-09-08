import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/meter/domain/entities/meter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_bloc.dart';
import 'package:gezi/features/meter/presentation/bloc/meter_event.dart';

class MeterFormPage extends StatefulWidget {
  final Meter? meter; // Se for null, é registo. Se não, é edição.

  const MeterFormPage({
    super.key,
    this.meter,
  });

  @override
  State<MeterFormPage> createState() => _MeterFormPageState();
}

class _MeterFormPageState extends State<MeterFormPage> {
  late final TextEditingController _numberController;
  late final TextEditingController _aliasController;
  MeterIconType _selectedIcon = MeterIconType.home;
  bool _isLoading = false;

  bool get isEdit => widget.meter != null;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.meter?.serialNumber ?? '');
    _aliasController = TextEditingController(text: widget.meter?.alias ?? '');
    if (widget.meter != null) {
      _selectedIcon = widget.meter!.iconType;
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Os serviços de localização estão desativados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('As permissões de localização foram negadas.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('As permissões de localização estão permanentemente negadas.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEdit ? 'Editar contador' : 'Adicionar contador',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Número do contador'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _numberController,
                hintText: '11 dígitos',
                keyboardType: TextInputType.number,
                enabled: !isEdit && !_isLoading, // Número de contador normalmente não é editável
              ),
              const SizedBox(height: 24),
              _buildLabel('Nome / etiqueta'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _aliasController,
                hintText: 'Ex: Casa principal',
                keyboardType: TextInputType.text,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),
              _buildLabel('Localização'),
              const SizedBox(height: 8),
              _buildDropdown(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    final serial = _numberController.text;
                    final alias = _aliasController.text;
                    if (serial.isEmpty || alias.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios')),
                      );
                      return;
                    }

                    if (isEdit) {
                      // Dispara a edição do contador (apenas envia a etiqueta)
                      context.read<MeterBloc>().add(
                        MeterUpdateRequested(
                          meterId: widget.meter!.id,
                          alias: alias,
                        ),
                      );
                      if (context.mounted) {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Atualização solicitada')),
                        );
                      }
                    } else {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final position = await _determinePosition();
                        if (context.mounted) {
                          context.read<MeterBloc>().add(
                            MeterAddRequested(
                              serialNumber: serial,
                              alias: alias,
                              latitude: position.latitude,
                              longitude: position.longitude,
                              address: _selectedIcon == MeterIconType.home ? 'Casa' 
                                  : _selectedIcon == MeterIconType.office ? 'Escritório' : 'Armazém',
                            ),
                          );
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Associação solicitada')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro: $e')),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEdit ? 'Guardar alterações' : 'Validar e associar',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.10,
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 13,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        height: 1.54,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Theme.of(context).colorScheme.surface : Theme.of(context).extension<AppColorsExtension>()!.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 15,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 15,
            fontFamily: 'Inter',
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MeterIconType>(
          value: _selectedIcon,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).colorScheme.onSurfaceVariant),
          items: const [
            DropdownMenuItem(
              value: MeterIconType.home,
              child: Text('Casa principal', style: TextStyle(fontFamily: 'Inter', fontSize: 15)),
            ),
            DropdownMenuItem(
              value: MeterIconType.office,
              child: Text('Escritório', style: TextStyle(fontFamily: 'Inter', fontSize: 15)),
            ),
            DropdownMenuItem(
              value: MeterIconType.store,
              child: Text('Armazém', style: TextStyle(fontFamily: 'Inter', fontSize: 15)),
            ),
          ],
          onChanged: (MeterIconType? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedIcon = newValue;
              });
            }
          },
        ),
      ),
    );
  }
}
