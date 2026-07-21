import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gezi/features/home/domain/repositories/home_repository.dart';
import 'package:gezi/features/home/presentation/bloc/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

// Auth
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/repositories/local_auth_repository.dart';
import 'features/auth/domain/usecases/check_biometrics_availability.dart';
import 'features/auth/domain/usecases/authenticate_with_biometrics.dart';
import 'features/auth/domain/usecases/request_otp.dart';
import 'features/auth/domain/usecases/verify_otp.dart';
import 'features/auth/domain/usecases/create_passkey.dart';


import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/local_auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/repositories/local_auth_repository_impl.dart';
import 'features/auth/presentation/bloc/local_auth_bloc.dart';
import 'features/auth/presentation/bloc/register/register_bloc.dart';

// Home
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/usecases/get_meter_balance.dart';
import 'features/home/domain/usecases/get_recent_recharges.dart';

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
  // Features - Auth
  // Bloc
  sl.registerFactory(() =>
      LocalAuthBloc(
        checkBiometricsAvailability: sl(),
        authenticateWithBiometrics: sl(),
      ));
  sl.registerFactory(() =>
      RegisterBloc(
        requestOtp: sl(),
        verifyOtp: sl(),
        createPasskey: sl(),
      ));
  sl.registerFactory(() => HomeBloc(
      getMeterBalance: sl(),
      getRecentRecharges: sl(),
  ));
  sl.registerFactory(() => RechargeBloc(
        calculateRechargeBreakdown: sl(),
        initiateRecharge: sl(),
        applyManualCode: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => CheckBiometricsAvailability(sl()));
  sl.registerLazySingleton(() => AuthenticateWithBiometrics(sl()));
  sl.registerLazySingleton(() => RequestOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => CreatePasskey(sl()));
  sl.registerLazySingleton(() => GetMeterBalance(sl()));
  sl.registerLazySingleton(() => GetRecentRecharges(sl()));
  sl.registerLazySingleton(() => CalculateRechargeBreakdown(sl()));
  sl.registerLazySingleton(() => InitiateRecharge(sl()));
  sl.registerLazySingleton(() => ApplyManualCode(sl()));

  // Repository
  sl.registerLazySingleton<LocalAuthRepository>(
        () => LocalAuthRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<RechargeRemoteDataSource>(
      () => RechargeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<RechargeRepository>(
      () => RechargeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocalAuthLocalDataSource>(
        () => LocalAuthLocalDataSourceImpl(localAuth: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // External - Dio HTTP Client
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);
    return dio;
  });

  // Local Auth
  sl.registerLazySingleton(() => LocalAuthentication());
}