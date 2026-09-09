import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/create_pin_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/pin_login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/passkey_setup_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/report/presentation/pages/report_list_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/meter/presentation/pages/meter_list_page.dart';
import '../../features/meter/presentation/pages/meter_form_page.dart';
import '../../features/meter/presentation/pages/meter_detail_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/recharge_detail_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/recharge/presentation/pages/recharge_page.dart';
import '../../features/recharge/presentation/pages/recharge_status_page.dart';
import '../../features/recharge/presentation/pages/recharge_receipt_page.dart';
import '../../features/recharge/presentation/pages/recharge_by_code_page.dart';
import '../../features/alert/presentation/pages/alerts_page.dart';
import '../shared_widgets/bottom_nav_bar.dart';
import '../../features/meter/domain/entities/meter.dart';
import '../../features/meter/presentation/bloc/meter_bloc.dart';
import '../../features/meter/presentation/bloc/meter_state.dart';
import '../../features/home/domain/entities/recharge.dart';
import '../../injection_container.dart';

/// Routes that do NOT require authentication
const _publicRoutes = ['/onboarding', '/login', '/pin-login', '/signup', '/passkey-setup', '/create-pin'];

class AppRouter {
  static late final GoRouter router;
  static late final AuthBloc _authBloc;

  static void init(SharedPreferences prefs) {
    final bool hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    // Singleton AuthBloc — drives reactive auth-based routing
    _authBloc = sl<AuthBloc>()..add(const AppStarted());

    router = GoRouter(
      initialLocation: hasSeenOnboarding ? '/login' : '/onboarding',
      refreshListenable: _GoRouterAuthNotifier(_authBloc),
      redirect: (context, state) {
        final authState = _authBloc.state;
        final isPublic = _publicRoutes.contains(state.matchedLocation);

        if (authState is AuthAuthenticated && isPublic) {
          // Already authenticated — skip login/register and go to home
          return '/home';
        }

        if (authState is AuthUnauthenticated && !isPublic) {
          // Not authenticated — redirect to login
          return '/login';
        }

        return null; // No redirect needed
      },
      routes: [
        // ── Public routes (no bottom nav) ────────────────────────────
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
          path: '/signup',
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: '/passkey-setup',
          builder: (context, state) => const PasskeySetupPage(),
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
            final isCodeRecharge =
                state.uri.queryParameters['isCodeRecharge'] == 'true';
            final code = state.uri.queryParameters['code'];
            final rechargeId = state.uri.queryParameters['rechargeId'] ?? '';
            final meterId = state.uri.queryParameters['meterId'];
            final phone = state.uri.queryParameters['phone'];
            return RechargeStatusPage(
              amount: amount,
              meterNumber: meterNumber,
              isCodeRecharge: isCodeRecharge,
              code: code,
              rechargeId: rechargeId,
              meterId: meterId,
              phone: phone,
            );
          },
        ),
        GoRoute(
          path: '/recharge/receipt',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            
            Recharge? recharge;
            if (extra.containsKey('rechargeJson') && extra['rechargeJson'] != null) {
              final json = extra['rechargeJson'] as Map<String, dynamic>;
              recharge = Recharge(
                id: json['id'],
                kwhAmount: json['kwhAmount'],
                paidAmount: json['paidAmount'],
                currency: json['currency'],
                rechargedAt: DateTime.parse(json['rechargedAt']),
                status: RechargeStatus.success, // We assume success here based on mapping
                meterSerialNumber: json['meterSerialNumber'],
                isMyMeter: json['isMyMeter'],
                paymentMethod: json['paymentMethod'],
                meterAlias: json['meterAlias'],
              );
            } else {
              recharge = extra['recharge'] as Recharge?;
            }
            
            final isCodeRecharge = extra['isCodeRecharge'] as bool? ?? false;
            final code = extra['code'] as String?;
            
            if (recharge == null) {
              return const Scaffold(body: Center(child: Text('Recarga não encontrada')));
            }

            return RechargeReceiptPage(
              recharge: recharge,
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
            Meter? meter = extra['meter'] as Meter?;
            if (meter == null) {
              final meterState = sl<MeterBloc>().state;
              if (meterState is MeterLoaded && meterState.meters.isNotEmpty) {
                meter = meterState.primaryMeter ?? meterState.meters.first;
              }
            }
            final recharges = (extra['recharges'] as List?)?.cast<Recharge>().toList() ?? [];
            return MeterDetailPage(
              meter: meter ??
                  const Meter(
                    id: '',
                    alias: 'Contador',
                    serialNumber: '',
                    isOnline: false,
                    isPrimary: true,
                    kwhBalance: 0.0,
                    iconType: MeterIconType.home,
                  ),
              initialRecharges: recharges,
            );
          },
        ),
        GoRoute(
          path: '/recharge_detail',
          builder: (context, state) {
            final recharge = state.extra as Recharge;
            return RechargeDetailPage(recharge: recharge);
          },
        ),
        GoRoute(
          path: '/receipt_preview',
          builder: (context, state) {
            final recharge = state.extra as Recharge;
            // Reusing RechargeReceiptPage for preview
            return RechargeReceiptPage(
              recharge: recharge,
            );
          },
        ),
        // ── Shell with bottom nav (protected) ─────────────────────────
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
                  builder: (context, state) => const HistoryPage(),
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
                      builder: (context, state) => const MeterFormPage(),
                    ),
                    GoRoute(
                      path: 'edit',
                      builder: (context, state) {
                        final extra =
                            state.extra as Map<String, dynamic>? ?? {};
                        final meter = extra['meter'] as Meter?;
                        return MeterFormPage(meter: meter);
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/reports',
                  builder: (context, state) => const ReportListPage(),
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

/// Bridges AuthBloc state changes to GoRouter's [refreshListenable].
/// Notifies GoRouter to re-evaluate the redirect whenever auth state changes.
class _GoRouterAuthNotifier extends ChangeNotifier {
  _GoRouterAuthNotifier(AuthBloc authBloc) {
    authBloc.stream.listen((_) => notifyListeners());
  }
}

/// Root widget that provides the global [AuthBloc] to the entire widget tree.
class GeziApp extends StatelessWidget {
  const GeziApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: sl<AuthBloc>(),
      child: MaterialApp.router(
        title: 'Gezi',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
