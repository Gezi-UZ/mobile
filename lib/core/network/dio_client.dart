import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../supabase/supabase_client.dart';

enum ApiEnvironment {
  local,
  production,
}

/// Singleton Dio HTTP client pre-configured for the Gezi FastAPI backend.
///
/// Automatically injects the Supabase JWT in the [Authorization] header
/// so every REST call to [/meters, /recharges, /payments, etc.] is authenticated.
class DioClient {
  late final Dio _dio;

  static const ApiEnvironment currentEnv = ApiEnvironment.local;

  DioClient() {
    String baseUrl;

    if (currentEnv == ApiEnvironment.local) {
      // Nota: 10.0.2.2 liga o Android Emulator ao localhost (127.0.0.1) do seu computador.
      // Se estiver a testar num iPhone Simulator use 127.0.0.1:8000
      // Se for um dispositivo físico, use o seu IP (ex: 192.168.1.100:8000)
      baseUrl = 'http://10.0.2.2:8000/v1'; 
    } else {
      baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://gezi.up.railway.app/v1';
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60), // STK Push pode demorar até o utilizador inserir o PIN
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
          
          assert(() {
            try {
              final parts = session.accessToken.split('.');
              if (parts.isNotEmpty) {
                final normalized = base64Url.normalize(parts[0]);
                utf8.decode(base64Url.decode(normalized));
                // print('[DioClient] TOKEN HEADER: $decoded');
              }
            } catch (e) {
              debugPrint('[DioClient] Error decoding token header: $e');
            }
            return true;
          }());
        }

        handler.next(options);
      },
      onError: (DioException error, handler) async {
        // Prevent infinite loop if the retry itself returns 401
        if (error.requestOptions.extra['isRetry'] == true) {
          return handler.next(error);
        }

        // 401 — token may have just expired; let Supabase auto-refresh and retry once
        if (error.response?.statusCode == 401) {
          try {
            final refreshed = await supabase.auth.refreshSession();
            final newToken = refreshed.session?.accessToken;
            if (newToken != null) {
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';
              opts.extra['isRetry'] = true;
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
          debugPrint('[DioClient] ${options.method} ${options.uri}');
          return true;
        }());
        handler.next(options);
      },
      onError: (error, handler) {
        assert(() {
          // ignore: avoid_print
          debugPrint('[DioClient] ERROR ${error.response?.statusCode}: ${error.message}');
          debugPrint('[DioClient] ERROR DATA: ${error.response?.data}');
          return true;
        }());
        handler.next(error);
      },
    );
  }
}
