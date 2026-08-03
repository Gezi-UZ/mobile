import 'package:flutter/material.dart';

/// Badge de status de ligação do contador (Online / Offline).
///
/// Exibe um ponto colorido e um label consoante o estado de conectividade.
class MeterStatusBadge extends StatelessWidget {
  final bool isOnline;

  const MeterStatusBadge({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: ShapeDecoration(
        color: isOnline
            ? const Color(0xFFDCFCE7) // verde claro
            : const Color(0xFFF3F4F6), // cinza claro
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: ShapeDecoration(
              color: isOnline
                  ? const Color(0xFF00C950) // verde
                  : const Color(0xFF99A1AF), // cinza
              shape: const CircleBorder(),
            ),
          ),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              color: isOnline
                  ? const Color(0xFF008236)
                  : const Color(0xFF6A7282),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}
