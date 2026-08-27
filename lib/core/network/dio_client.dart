import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../supabase/supabase_client.dart';

/// Singleton Dio HTTP client pre-configured for the Gezi FastAPI backend.
///
/// Automatically injects the Supabase JWT in the [Authorization] header
/// so every REST call to [/meters, /recharges, /payments, etc.] is authenticated.
class DioClient {
  late final Dio _dio;

  DioClient() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://api.gezi.mz/v1';

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(_jwtInterceptor());
    _dio.interceptors.add(_loggingInterceptor());
  }

  Dio get dio => _dio;

  // ─────────────────────────────────────────────────────────────────
  // JWT Interceptor — injects the Supabase accessToken on every request
  // ─────────────────────────────────────────────────────────────────

  InterceptorsWrapper _jwtInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final session = supabase.auth.currentSession;

        if (session != null) {
          // If the token is expired, Supabase SDK refreshes it automatically
          options.headers['Authorization'] = 'Bearer ${session.accessToken}';
        }

        handler.next(options);
      },
      onError: (DioException error, handler) async {
        // 401 — token may have just expired; let Supabase auto-refresh and retry once
        if (error.response?.statusCode == 401) {
          try {
            final refreshed = await supabase.auth.refreshSession();
            final newToken = refreshed.session?.accessToken;
            if (newToken != null) {
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';
              final retryResponse = await _dio.fetch(opts);
              return handler.resolve(retryResponse);
            }
          } catch (_) {
            // Refresh failed — propagate original error
          }
        }
        handler.next(error);
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Logging Interceptor — debug only, stripped in release builds
  // ─────────────────────────────────────────────────────────────────

  InterceptorsWrapper _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        assert(() {
          // ignore: avoid_print
          print('[DioClient] ${options.method} ${options.uri}');
          return true;
        }());
        handler.next(options);
      },
      onError: (error, handler) {
        assert(() {
          // ignore: avoid_print
          print('[DioClient] ERROR ${error.response?.statusCode}: ${error.message}');
          return true;
        }());
        handler.next(error);
      },
    );
  }
}
