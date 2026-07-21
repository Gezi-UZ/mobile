import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/pages/create_pin_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/pin_login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/documents/presentation/pages/documents_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/meter/presentation/pages/meter_list_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/recharge/presentation/pages/recharge_history_page.dart';
import '../shared_widgets/bottom_nav_bar.dart';

class AppRouter {
  static late final GoRouter router;

  static void init(SharedPreferences prefs) {
    final bool hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    router = GoRouter(
      initialLocation: hasSeenOnboarding ? '/login' : '/onboarding',
      routes: [
        // ── Rotas fora do shell (sem bottom nav) ──────────────────────────
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/pin-login',
          builder: (context, state) => const PinLoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/create-pin',
          builder: (context, state) => const CreatePinPage(),
        ),

        // ── Shell com bottom nav ──────────────────────────────────────────
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/recharges',
                  builder: (context, state) => const RechargeHistoryPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/meters',
                  builder: (context, state) => const MeterListPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/documents',
                  builder: (context, state) => const DocumentsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

