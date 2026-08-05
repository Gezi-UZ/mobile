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
import '../../features/meter/presentation/pages/register_meter_page.dart';
import '../../features/meter/presentation/pages/meter_detail_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/recharge/presentation/pages/recharge_history_page.dart';
import '../../features/recharge/presentation/pages/recharge_page.dart';
import '../../features/recharge/presentation/pages/recharge_status_page.dart';
import '../../features/recharge/presentation/pages/recharge_receipt_page.dart';
import '../../features/recharge/presentation/pages/recharge_by_code_page.dart';
import '../../features/alert/presentation/pages/alerts_page.dart';
import '../shared_widgets/bottom_nav_bar.dart';
import '../../features/meter/domain/entities/meter.dart';
import '../../features/home/domain/entities/recharge.dart';

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
        GoRoute(
          path: '/recharge',
          builder: (context, state) {
            final isForSomeone = state.uri.queryParameters['someone'] == 'true';
            return RechargePage(isForSomeone: isForSomeone);
          },
        ),
        GoRoute(
          path: '/recharge/status',
          builder: (context, state) {
            final amount = state.uri.queryParameters['amount'] ?? '0';
            final meterNumber = state.uri.queryParameters['meterNumber'] ?? '';
            final isCodeRecharge = state.uri.queryParameters['isCodeRecharge'] == 'true';
            final code = state.uri.queryParameters['code'];
            return RechargeStatusPage(
              amount: amount,
              meterNumber: meterNumber,
              isCodeRecharge: isCodeRecharge,
              code: code,
            );
          },
        ),
        GoRoute(
          path: '/recharge/receipt',
          builder: (context, state) {
            final amount = state.uri.queryParameters['amount'] ?? '0';
            final meterNumber = state.uri.queryParameters['meterNumber'] ?? '';
            final isCodeRecharge = state.uri.queryParameters['isCodeRecharge'] == 'true';
            final code = state.uri.queryParameters['code'];
            return RechargeReceiptPage(
              amount: amount,
              meterNumber: meterNumber,
              isCodeRecharge: isCodeRecharge,
              code: code,
            );
          },
        ),
        GoRoute(
          path: '/recharge/code',
          builder: (context, state) => const RechargeByCodePage(),
        ),
        GoRoute(
          path: '/alerts',
          builder: (context, state) => const AlertsPage(),
        ),
        GoRoute(
          path: '/meters/detail',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final meter = extra['meter'] as Meter? ?? MeterListPage.mockMeters.first;
            final recharges = extra['recharges'] as List<Recharge>? ?? [];
            return MeterDetailPage(meter: meter, recentRecharges: recharges);
          },
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
                  routes: [
                    GoRoute(
                      path: 'register',
                      builder: (context, state) => const RegisterMeterPage(),
                    ),
                  ],
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

