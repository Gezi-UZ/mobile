import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/pin_login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/create_pin_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static late final GoRouter router;

  static void init(SharedPreferences prefs) {
    final bool hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    router = GoRouter(
      initialLocation: hasSeenOnboarding ? '/login' : '/onboarding',
      routes: [
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
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
  }
}
