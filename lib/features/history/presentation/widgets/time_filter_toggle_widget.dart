import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

enum TimeFilter { hoje, semana, mes, anual }

class TimeFilterToggleWidget extends StatefulWidget {
  final TimeFilter initialFilter;
  final ValueChanged<TimeFilter>? onFilterChanged;

  const TimeFilterToggleWidget({
    super.key,
    this.initialFilter = TimeFilter.semana,
    this.onFilterChanged,
  });

  @override
  State<TimeFilterToggleWidget> createState() => _TimeFilterToggleWidgetState();
}

class _TimeFilterToggleWidgetState extends State<TimeFilterToggleWidget> {
  late TimeFilter _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
  }

  void _onTap(TimeFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
    widget.onFilterChanged?.call(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildFilterItem(TimeFilter.hoje, 'Hoje'),
          _buildFilterItem(TimeFilter.semana, 'Semana'),
          _buildFilterItem(TimeFilter.mes, 'Mês'),
          _buildFilterItem(TimeFilter.anual, 'Anual'),
        ],
      ),
    );
  }

  Widget _buildFilterItem(TimeFilter filter, String label) {
    final isSelected = _selectedFilter == filter;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTap(filter),
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                )
              : null,
          alignment: Alignment.center,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? AppTheme.textColorDark
                      : AppTheme.textColorSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
        ),
      ),
    );
  }
}
