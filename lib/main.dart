import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/theme/theme.dart';
import 'core/supabase/supabase_client.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load environment variables
  await dotenv.load(fileName: '.env');

  // 2. Initialize Supabase (must be before di.init which registers the client)
  await initSupabase();

  // 3. Initialize all DI dependencies
  await di.init();

  // 3.5 Initialize Firebase and Push Notifications
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await di.sl<PushNotificationService>().init();
  } catch (e) {
    debugPrint('Firebase initialization failed (probably missing config): $e');
  }

  // 4. Localisation
  await initializeDateFormatting('pt_PT', null);

  // 5. Init router (checks onboarding flag + wires AuthBloc)
  final prefs = di.sl<SharedPreferences>();
  AppRouter.init(prefs);

  runApp(const GeziApp());
}

/// Root widget — provides the global AuthBloc to the entire tree.
class GeziApp extends StatelessWidget {
  const GeziApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: di.sl<AuthBloc>()),
        BlocProvider<ThemeCubit>.value(value: di.sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Gezi',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.themeData,
            darkTheme: AppTheme.darkThemeData,
            themeMode: themeState.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}