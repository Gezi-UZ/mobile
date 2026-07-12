import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/theme.dart';

class PinInputField extends StatefulWidget {
  final int length;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autofocus;
  final bool obscureText;

  const PinInputField({
    super.key,
    this.length = 6,
    this.controller,
    this.onChanged,
    this.onCompleted,
    this.autofocus = false,
    this.obscureText = false,
  });

  @override
  State<PinInputField> createState() => _PinInputFieldState();
}

class _PinInputFieldState extends State<PinInputField> {
  late final TextEditingController _effectiveController;
  late final FocusNode _focusNode;
  bool _isCreatedLocally = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _effectiveController = TextEditingController();
      _isCreatedLocally = true;
    } else {
      _effectiveController = widget.controller!;
    }
    _focusNode = FocusNode();
    _effectiveController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onTextChanged);
    if (_isCreatedLocally) {
      _effectiveController.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _effectiveController.text;
    widget.onChanged?.call(text);
    if (text.length == widget.length) {
      widget.onCompleted?.call(text);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final text = _effectiveController.text;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Invisible TextField overlaying for soft-keyboard and input control
          Opacity(
            opacity: 0.0,
            child: TextField(
              controller: _effectiveController,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              autofocus: widget.autofocus,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.length),
              ],
            ),
          ),

          // Visual representation of PIN digit boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              final isFocused =
                  _focusNode.hasFocus && text.length == index ||
                  (_focusNode.hasFocus &&
                      index == widget.length - 1 &&
                      text.length == widget.length);
              final hasChar = index < text.length;
              final char = hasChar ? text[index] : '';

              return Container(
                width: 48,
                height: 56,
                margin: EdgeInsets.only(
                  right: index < widget.length - 1 ? 12.0 : 0.0,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  border: Border.all(
                    color: isFocused
                        ? AppTheme.primaryOrange
                        : Colors.black.withValues(alpha: 0.08),
                    width: isFocused ? 1.5 : 1.11,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.obscureText && hasChar ? '●' : char,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textColorDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
