import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_preferences_card.dart';
import '../widgets/profile_logout_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const UserProfileCard(
                userName: 'Dai Wen Xuan',
                phoneNumber: '+258 83 361 7829',
              ),
              const SizedBox(height: 8), // To balance with the margin of menu items
              ProfileMenuItem(
                icon: Icons.people_outline,
                title: 'Os meus contadores',
                onTap: () {},
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
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
