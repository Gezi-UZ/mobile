import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/meter/domain/entities/meter.dart';
import 'package:go_router/go_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColorDark),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEdit ? 'Editar contador' : 'Adicionar contador',
          style: const TextStyle(
            color: AppTheme.textColorDark,
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
                enabled: !isEdit, // Número de contador normalmente não é editável
              ),
              const SizedBox(height: 24),
              _buildLabel('Nome / etiqueta'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _aliasController,
                hintText: 'Ex: Casa principal',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 24),
              _buildLabel('Localização'),
              const SizedBox(height: 8),
              _buildDropdown(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implementar lógica de salvar
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEdit ? 'Contador atualizado' : 'Contador associado')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryOrange,
                    foregroundColor: AppTheme.white,
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
      style: const TextStyle(
        color: AppTheme.textColorDark,
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
        color: enabled ? AppTheme.white : const Color(0xFFF5F5F5),
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
        style: const TextStyle(
          color: AppTheme.textColorDark,
          fontSize: 15,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppTheme.textColorSecondary,
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
        color: AppTheme.white,
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
          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textColorSecondary),
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
