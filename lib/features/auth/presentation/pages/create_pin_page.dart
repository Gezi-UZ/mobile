import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/pin_input_field.dart';

class CreatePinPage extends StatefulWidget {
  const CreatePinPage({super.key});

  @override
  State<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  bool _showPin = false;
  bool _isConfirmStep = false;
  bool _isPinComplete = false;
  bool _isConfirmPinComplete = false;
  String? _errorMessage;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _onPinChanged(String value) {
    final complete = value.length == 6;
    if (complete != _isPinComplete) {
      setState(() {
        _isPinComplete = complete;
      });
    }
  }

  void _onConfirmPinChanged(String value) {
    final complete = value.length == 6;
    setState(() {
      _isConfirmPinComplete = complete;
      if (complete) {
        if (value != _pinController.text) {
          _errorMessage = 'Os PINs não coincidem. Tente novamente.';
        } else {
          _errorMessage = null;
        }
      } else {
        _errorMessage = null;
      }
    });
  }

  void _advanceToConfirm() {
    if (_isPinComplete) {
      setState(() {
        _isConfirmStep = true;
        _errorMessage = null;
      });
    }
  }

  void _backToCreateStep() {
    setState(() {
      _isConfirmStep = false;
      _confirmPinController.clear();
      _isConfirmPinComplete = false;
      _errorMessage = null;
    });
  }

  void _submit() {
    if (_isConfirmStep &&
        _isConfirmPinComplete &&
        _confirmPinController.text == _pinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN configurado com sucesso!')),
      );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _isConfirmStep
        ? (_isConfirmPinComplete && _errorMessage == null)
        : _isPinComplete;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_isConfirmStep) {
                                  _backToCreateStep();
                                } else if (context.canPop()) {
                                  context.pop();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.arrow_back),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(Icons.lock_outline_rounded,
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Segurança',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppTheme.textColorDark,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        Text(
                          _isConfirmStep
                              ? 'Confirmar PIN de segurança'
                              : 'Criar PIN de segurança',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: AppTheme.textColorDark,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isConfirmStep
                              ? 'Reintroduza o PIN de 6 dígitos para confirmar.'
                              : 'Defina um PIN de 6 dígitos que utilizará para aceder à sua conta com facilidade e segurança.',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.textColorSecondary,
                                    fontSize: 14,
                                  ),
                        ),
                        const SizedBox(height: 32),

                        // PIN Input Field
                        PinInputField(
                          key: ValueKey(_isConfirmStep ? 'confirm' : 'create'),
                          controller: _isConfirmStep
                              ? _confirmPinController
                              : _pinController,
                          length: 6,
                          autofocus: true,
                          obscureText: !_showPin,
                          onChanged: _isConfirmStep
                              ? _onConfirmPinChanged
                              : _onPinChanged,
                          onCompleted: (pin) {
                            if (!_isConfirmStep) {
                              _advanceToConfirm();
                            } else {
                              _submit();
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        // PIN Visibility Toggle & Error Message Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _showPin = !_showPin;
                                });
                              },
                              icon: Icon(
                                _showPin
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppTheme.textColorSecondary,
                                size: 18,
                              ),
                              label: Text(
                                _showPin ? 'Ocultar PIN' : 'Mostrar PIN',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: AppTheme.textColorSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            if (_isConfirmStep)
                              TextButton(
                                onPressed: _backToCreateStep,
                                child: Text(
                                  'Alterar PIN',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: AppTheme.primaryOrange,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                          ],
                        ),

                        if (_errorMessage != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],

                        const Spacer(),

                        // Primary Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: canSubmit
                                ? (_isConfirmStep ? _submit : _advanceToConfirm)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canSubmit
                                  ? AppTheme.primaryOrange
                                  : const Color(0xFFCCCCCC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              _isConfirmStep ? 'Guardar PIN' : 'Continuar',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
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
          },
        ),
      ),
    );
  }
}
