import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final String userName;
  final int notificationCount;

  const DashboardHeaderWidget({
    super.key,
    required this.userName,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildGreeting(context),
          _buildActionIcons(),
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bem-vindo,',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textColorSecondary,
            fontSize: 12,
          ),
        ),
        Text(
          userName,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppTheme.textColorDark,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcons() {
    return Row(
      spacing: 8,
      children: [
        _NotificationIconButton(count: notificationCount),
        const _AvatarIconButton(),
      ],
    );
  }
}

/// Botão de notificações com badge de contagem.
class _NotificationIconButton extends StatelessWidget {
  final int count;

  const _NotificationIconButton({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const ShapeDecoration(
            color: AppTheme.lightOrangeBackground,
            shape: CircleBorder(),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: AppTheme.primaryOrange,
            size: 20,
          ),
        ),
        if (count > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: const ShapeDecoration(
                color: AppTheme.primaryOrange,
                shape: CircleBorder(),
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Botão do avatar/perfil do utilizador.
class _AvatarIconButton extends StatelessWidget {
  const _AvatarIconButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: ShapeDecoration(
        color: AppTheme.primaryOrange.withValues(alpha: 0.20),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.primaryOrange, width: 1.11),
          borderRadius: BorderRadius.all(Radius.circular(37282700)),
        ),
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        color: AppTheme.primaryOrange,
        size: 20,
      ),
    );
  }
}
