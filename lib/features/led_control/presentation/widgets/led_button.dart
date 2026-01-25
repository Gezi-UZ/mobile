import 'package:flutter/material.dart';

class LedButton extends StatelessWidget {
  final String ledId;
  final String label;
  final bool isOn;
  final Color color;
  final VoidCallback onToggle;

  const LedButton({
    super.key,
    required this.ledId,
    required this.label,
    required this.isOn,
    required this.color,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isOn ? color.withValues(alpha: 0.2) : Colors.grey[200],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isOn ? Icons.lightbulb : Icons.lightbulb_outline,
                size: 48,
                color: isOn ? color : Colors.grey,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isOn ? color : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isOn ? color : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isOn ? 'ON' : 'OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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