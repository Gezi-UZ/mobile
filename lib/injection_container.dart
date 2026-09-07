import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:gezi/features/recharge/domain/usecases/stream_recharge_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gezi/core/services/local_notification_service.dart';
import 'package:gezi/core/network/dio_client.dart';
import 'package:gezi/core/theme/theme_cubit.dart';

// Core
import 'core/supabase/supabase_client.dart';

// Auth — domain
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/repositories/local_auth_repository.dart';
import 'features/auth/domain/usecases/check_biometrics_availability.dart';
import 'features/auth/domain/usecases/authenticate_with_biometrics.dart';
import 'features/auth/domain/usecases/sign_up_with_email.dart';
import 'features/auth/domain/usecases/sign_in_with_email.dart';
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
import 'features/auth/presentation/bloc/email_auth/login_bloc.dart';
import 'features/auth/presentation/bloc/email_auth/signup_bloc.dart';
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
import 'features/recharge/domain/usecases/get_recharge_history.dart';
import 'features/recharge/domain/usecases/get_dashboard_stats.dart';
import 'features/recharge/presentation/bloc/recharge_bloc.dart';

// History
import 'features/history/presentation/bloc/history_cubit.dart';

// Meter
import 'features/meter/data/datasources/meter_remote_data_source.dart';
import 'features/meter/data/datasources/meter_realtime_data_source.dart';
import 'features/meter/data/repositories/meter_repository_impl.dart';
import 'features/meter/domain/repositories/meter_repository.dart';
import 'features/meter/domain/usecases/get_my_meters.dart';
import 'features/meter/domain/usecases/get_meter_status.dart';
import 'features/meter/domain/usecases/register_meter.dart';
import 'features/meter/domain/usecases/edit_meter.dart';
import 'features/meter/domain/usecases/validate_meter_by_serial.dart';
import 'features/meter/domain/usecases/watch_meter_realtime.dart';
import 'features/meter/domain/usecases/watch_user_meters.dart';
import 'features/meter/presentation/bloc/meter_bloc.dart';

// IoT
import 'features/iot/data/datasources/iot_remote_data_source.dart';
import 'features/iot/data/repositories/iot_repository_impl.dart';
import 'features/iot/domain/repositories/iot_repository.dart';

// Profile
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_user_profile.dart';
import 'features/profile/domain/usecases/update_user_profile.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

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

  // Theme
  sl.registerLazySingleton(() => ThemeCubit(sharedPreferences: sl()));

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
  sl.registerLazySingleton(() => SignUpWithEmail(sl()));
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
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
    () => LoginBloc(
      signInWithEmail: sl(),
    ),
  );
  sl.registerFactory(
    () => SignupBloc(
      signUpWithEmail: sl(),
    ),
  );
  sl.registerFactory(
    () => RegisterBloc(
      authenticateWithBiometrics: sl(),
      authRepository: sl(),
    ),
  );

  // ── Home ─────────────────────────────────────────────────────────

  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetMeterBalance(sl()));
  sl.registerLazySingleton(() => GetRecentRecharges(sl()));
  sl.registerLazySingleton(
    () => HomeBloc(getMeterBalance: sl(), getRecentRecharges: sl()),
  );

  // ── Meter ────────────────────────────────────────────────────────

  sl.registerLazySingleton<MeterRealtimeDataSource>(
    () => MeterRealtimeDataSourceImpl(),
  );
  sl.registerLazySingleton<MeterRemoteDataSource>(
    () => MeterRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<MeterRepository>(
    () => MeterRepositoryImpl(
      remoteDataSource: sl(),
      realtimeDataSource: sl(),
    ),
  );

  // Meter Use cases
  sl.registerLazySingleton(() => GetMyMeters(sl()));
  sl.registerLazySingleton(() => GetMeterStatus(sl()));
  sl.registerLazySingleton(() => RegisterMeter(sl()));
  sl.registerLazySingleton(() => EditMeter(sl()));
  sl.registerLazySingleton(() => ValidateMeterBySerial(sl()));
  sl.registerLazySingleton(() => WatchMeterRealtime(sl()));
  sl.registerLazySingleton(() => WatchUserMeters(sl()));

  // MeterBloc is a lazy singleton — shared between HomePage, MeterListPage, and Recharge flows
  sl.registerLazySingleton(
    () => MeterBloc(
      getMyMeters: sl(),
      editMeter: sl(),
      registerMeter: sl(),
      validateMeterBySerial: sl(),
      watchUserMeters: sl(),
    ),
  );

  // ── Recharge ─────────────────────────────────────────────────────

  sl.registerLazySingleton<RechargeRemoteDataSource>(
    () => RechargeRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<RechargeRepository>(
    () => RechargeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => CalculateRechargeBreakdown(sl()));
  sl.registerLazySingleton(() => InitiateRecharge(sl()));
  sl.registerLazySingleton(() => ApplyManualCode(sl()));
  sl.registerLazySingleton(() => StreamRechargeStatus(sl()));
  sl.registerLazySingleton(() => GetRechargeHistory(sl()));
  sl.registerLazySingleton(() => GetDashboardStats(sl()));
  sl.registerFactory(
    () => RechargeBloc(
      calculateRechargeBreakdown: sl(),
      initiateRecharge: sl(),
      applyManualCode: sl(),
      streamRechargeStatus: sl(),
    ),
  );

  // ── History ──────────────────────────────────────────────────────

  sl.registerFactory(
    () => HistoryCubit(
      getRechargeHistory: sl(),
      getDashboardStats: sl(),
    ),
  );

  // ── IoT ──────────────────────────────────────────────────────────

  sl.registerLazySingleton<IotRemoteDataSource>(
    () => IotRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<IotRepository>(
    () => IotRepositoryImpl(remoteDataSource: sl()),
  );

  // ── Profile ───────────────────────────────────────────────────────

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));

  // ProfileBloc is a lazy singleton — shared between HomePage header and ProfilePage
  sl.registerLazySingleton(
    () => ProfileBloc(
      getUserProfile: sl(),
      updateUserProfile: sl(),
    ),
  );
}