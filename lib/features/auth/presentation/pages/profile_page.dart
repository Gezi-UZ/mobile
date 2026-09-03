import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../../../features/profile/presentation/bloc/profile_event.dart';
import '../../../../features/profile/presentation/bloc/profile_state.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_preferences_card.dart';
import '../widgets/profile_logout_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => sl<ProfileBloc>()..add(const ProfileLoadRequested()),
      child: Scaffold(
        backgroundColor: AppTheme.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 48,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perfil',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textColorDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    height: 1.40,
                  ),
                ),
                const SizedBox(height: 24),

                // Profile Card — reacts to ProfileBloc state
                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final profile = switch (state) {
                      ProfileLoaded(:final profile) => profile,
                      ProfileUpdateSuccess(:final profile) => profile,
                      _ => null,
                    };

                    return UserProfileCard(profile: profile);
                  },
                ),

                const SizedBox(height: 8),
                ProfileMenuItem(
                  icon: Icons.electric_meter_outlined,
                  title: 'Os meus contadores',
                  onTap: () => context.go('/meters'),
                ),
                ProfileMenuItem(
                  icon: Icons.support_agent,
                  title: 'Apoio ao cliente',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.analytics_outlined,
                  title: 'Estimativa de consumo',
                  onTap: () {},
                ),
                const ProfilePreferencesCard(),
                ProfileLogoutButton(
                  onTap: () {
                    context.read<AuthBloc>().add(const SignOutRequested());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
