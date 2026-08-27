import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gezi/core/services/local_notification_service.dart';
import 'package:gezi/core/network/dio_client.dart';

// Core
import 'core/supabase/supabase_client.dart';

// Auth — domain
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/repositories/local_auth_repository.dart';
import 'features/auth/domain/usecases/check_biometrics_availability.dart';
import 'features/auth/domain/usecases/authenticate_with_biometrics.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/domain/usecases/sign_in_with_biometric.dart';
import 'features/auth/domain/usecases/get_current_session.dart';
import 'features/auth/domain/usecases/sign_out.dart';

// Auth — data
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/local_auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/repositories/local_auth_repository_impl.dart';

// Auth — presentation
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/local_auth_bloc.dart';
import 'features/auth/presentation/bloc/register/register_bloc.dart';

// Home
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_meter_balance.dart';
import 'features/home/domain/usecases/get_recent_recharges.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

// Recharge
import 'features/recharge/data/datasources/recharge_remote_data_source.dart';
import 'features/recharge/data/repositories/recharge_repository_impl.dart';
import 'features/recharge/domain/repositories/recharge_repository.dart';
import 'features/recharge/domain/usecases/calculate_recharge_breakdown.dart';
import 'features/recharge/domain/usecases/initiate_recharge.dart';
import 'features/recharge/domain/usecases/apply_manual_code.dart';
import 'features/recharge/presentation/bloc/recharge_bloc.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // ── External ────────────────────────────────────────────────────

  // Supabase client (already initialized in main.dart via initSupabase())
  sl.registerLazySingleton<SupabaseClient>(() => supabase);

  // Secure Storage (hardware-backed on Android/iOS)
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(),
    ),
  );

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Local Authentication (biometrics)
  sl.registerLazySingleton(() => LocalAuthentication());

  // Dio HTTP Client (with JWT interceptor — for FastAPI endpoints)
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // Notifications
  final localNotificationService = LocalNotificationService();
  await localNotificationService.init();
  sl.registerLazySingleton(() => localNotificationService);

  // ── Auth ─────────────────────────────────────────────────────────

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(secureStorage: sl()),
  );
  sl.registerLazySingleton<LocalAuthLocalDataSource>(
    () => LocalAuthLocalDataSourceImpl(localAuth: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LocalAuthRepository>(
    () => LocalAuthRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignInWithBiometric(sl()));
  sl.registerLazySingleton(() => GetCurrentSession(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => CheckBiometricsAvailability(sl()));
  sl.registerLazySingleton(() => AuthenticateWithBiometrics(sl()));

  // Blocs
  // AuthBloc is a lazy singleton — lives for the entire app lifetime
  sl.registerLazySingleton(
    () => AuthBloc(
      getCurrentSession: sl(),
      signInWithBiometric: sl(),
      signOut: sl(),
      authRepository: sl(),
    ),
  );
  sl.registerFactory(
    () => LocalAuthBloc(
      checkBiometricsAvailability: sl(),
      authenticateWithBiometrics: sl(),
    ),
  );
  sl.registerFactory(
    () => RegisterBloc(
      signUp: sl(),
      authenticateWithBiometrics: sl(),
      authRepository: sl(),
    ),
  );

  // ── Home ─────────────────────────────────────────────────────────

  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetMeterBalance(sl()));
  sl.registerLazySingleton(() => GetRecentRecharges(sl()));
  sl.registerLazySingleton(
    () => HomeBloc(getMeterBalance: sl(), getRecentRecharges: sl()),
  );

  // ── Recharge ─────────────────────────────────────────────────────

  sl.registerLazySingleton<RechargeRemoteDataSource>(
    () => RechargeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<RechargeRepository>(
    () => RechargeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => CalculateRechargeBreakdown(sl()));
  sl.registerLazySingleton(() => InitiateRecharge(sl()));
  sl.registerLazySingleton(() => ApplyManualCode(sl()));
  sl.registerFactory(
    () => RechargeBloc(
      calculateRechargeBreakdown: sl(),
      initiateRecharge: sl(),
      applyManualCode: sl(),
    ),
  );
}