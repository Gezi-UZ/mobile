import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

const String _themePrefKey = 'theme_pref_mode';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences sharedPreferences;

  ThemeCubit({required this.sharedPreferences}) : super(const ThemeState()) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeString = sharedPreferences.getString(_themePrefKey);
    ThemeMode mode;
    switch (themeString) {
      case 'dark':
        mode = ThemeMode.dark;
        break;
      case 'light':
        mode = ThemeMode.light;
        break;
      default:
        mode = ThemeMode.system;
    }
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> toggleTheme(bool isDark) async {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    await sharedPreferences.setString(_themePrefKey, isDark ? 'dark' : 'light');
    emit(state.copyWith(themeMode: mode));
  }
}
