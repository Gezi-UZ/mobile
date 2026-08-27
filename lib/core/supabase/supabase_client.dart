import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Initializes Supabase with credentials from the .env file.
/// Must be called before [di.init()] in main.dart.
Future<void> initSupabase() async {
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
}

/// Convenience getter for the shared SupabaseClient instance.
SupabaseClient get supabase => Supabase.instance.client;
