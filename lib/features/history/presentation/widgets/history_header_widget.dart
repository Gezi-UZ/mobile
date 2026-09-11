import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class HistoryHeaderWidget extends StatelessWidget {
  final VoidCallback? onDownloadTap;

  const HistoryHeaderWidget({
    super.key,
    this.onDownloadTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Histórico',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
              ),
        ),
        GestureDetector(
          onTap: onDownloadTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).extension<AppColorsExtension>()!.lightOrangeBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.download_rounded,
              color: AppTheme.primaryOrange,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
