import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class HistoryHeaderWidget extends StatelessWidget {
  final VoidCallback? onFilterTap;

  const HistoryHeaderWidget({
    super.key,
    this.onFilterTap,
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
                color: AppTheme.textColorDark,
                fontSize: 20,
              ),
        ),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.lightOrangeBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.filter_list_rounded,
              color: AppTheme.primaryOrange,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
