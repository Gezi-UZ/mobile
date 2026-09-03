import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/profile/presentation/bloc/profile_bloc.dart';
import '../../../../features/profile/domain/entities/user_profile.dart';
import '../pages/edit_profile_page.dart';

class UserProfileCard extends StatelessWidget {
  final UserProfile? profile;

  // Legacy params kept for fallback during transition
  final String? userName;
  final String? phoneNumber;

  const UserProfileCard({
    super.key,
    this.profile,
    this.userName,
    this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final name = profile?.nome ?? userName ?? '—';
    final phone = profile?.telefone != null
        ? '+258 ${profile!.telefone}'
        : phoneNumber ?? 'Sem telefone';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: AppTheme.lightOrangeBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: ShapeDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.person,
              color: AppTheme.primaryOrange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textColorDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    height: 1.50,
                  ),
                ),
                Opacity(
                  opacity: 0.61,
                  child: Text(
                    phone,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textColorSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (profile != null)
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppTheme.primaryOrange,
                size: 20,
              ),
              tooltip: 'Editar Perfil',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<ProfileBloc>(),
                      child: EditProfilePage(profile: profile!),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
