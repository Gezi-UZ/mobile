import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/theme/theme.dart';
import 'core/supabase/supabase_client.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load environment variables
  await dotenv.load(fileName: '.env');

  // 2. Initialize Supabase (must be before di.init which registers the client)
  await initSupabase();

  // 3. Initialize all DI dependencies
  await di.init();

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
    return BlocProvider<AuthBloc>.value(
      value: di.sl<AuthBloc>(),
      child: MaterialApp.router(
        title: 'Gezi',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        routerConfig: AppRouter.router,
      ),
    );
  }
}