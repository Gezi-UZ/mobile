import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'features/led_control/data/datasources/led_remote_data_source.dart';
import 'features/led_control/data/repositories/led_repository_impl.dart';
import 'features/led_control/domain/repositories/led_repository.dart';
import 'features/led_control/domain/usecases/get_all_leds.dart';
import 'features/led_control/domain/usecases/toggle_led.dart';
import 'features/led_control/presentation/bloc/led_bloc.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init({required String esp32IpAddress}) async {
  // BLoC
  sl.registerFactory(
    () => LedBloc(
      getAllLeds: sl(),
      toggleLed: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAllLeds(sl()));
  sl.registerLazySingleton(() => ToggleLed(sl()));

  // Repository
  sl.registerLazySingleton<LedRepository>(
    () => LedRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<LedRemoteDataSource>(
    () => LedRemoteDataSourceImpl(
      dio: sl(),
      baseUrl: 'http://$esp32IpAddress',
    ),
  );

  // External - Dio HTTP Client
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);
    return dio;
  });
}