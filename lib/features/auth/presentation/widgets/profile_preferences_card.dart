import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class ProfilePreferencesCard extends StatelessWidget {
  const ProfilePreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: AppTheme.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.11,
            color: Colors.black.withValues(alpha: 0.08),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREFERÊNCIAS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.textColorSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.30,
              height: 1.33,
            ),
          ),
          const SizedBox(height: 16),
          _PreferenceToggleRow(
            icon: Icons.fingerprint,
            title: 'Biometria',
            value: true,
            onChanged: (val) {},
          ),
          const SizedBox(height: 16),
          _PreferenceToggleRow(
            icon: Icons.dark_mode_outlined,
            title: 'Modo escuro',
            value: false,
            onChanged: (val) {},
          ),
          const SizedBox(height: 16),
          _PreferenceItemRow(
            icon: Icons.language,
            title: 'Idioma · Português (MZ)',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _PreferenceToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceToggleRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: ShapeDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                shape: const CircleBorder(),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryOrange,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textColorDark,
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24,
          width: 48,
          child: Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppTheme.white,
              activeTrackColor: AppTheme.primaryOrange,
              inactiveThumbColor: AppTheme.white,
              inactiveTrackColor: const Color(0xFFCBCED4),
              trackOutlineColor: WidgetStateProperty.resolveWith(
                  (states) => Colors.transparent),
            ),
          ),
        ),
      ],
    );
  }
}

class _PreferenceItemRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _PreferenceItemRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: ShapeDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  shape: const CircleBorder(),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryOrange,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textColorDark,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.chevron_right,
            color: AppTheme.textColorSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
