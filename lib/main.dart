import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await di.init();
  await initializeDateFormatting('pt_PT', null);
  
  final prefs = di.sl<SharedPreferences>();
  AppRouter.init(prefs);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gezi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      routerConfig: AppRouter.router,
    );
  }
}