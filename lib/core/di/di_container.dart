import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/network/auth_interceptor.dart';
import 'package:app/core/network/dio_client.dart';
import 'package:app/core/network/logging_interceptor.dart';
import 'package:app/features/auth/providers/auth_provider.dart';
import 'package:app/features/auth/repositories/auth_repository.dart';
import 'package:app/features/home/providers/example_provider.dart';
import 'package:app/features/home/repositories/example_repository.dart';
import 'package:app/core/constants/config_model.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => AuthInterceptor(sharedPreferences: sl()));

  // Core
  sl.registerLazySingleton(() => DioClient(
        BaseUrls.productionAPi,
        sl(),
        loggingInterceptor: sl(),
        authInterceptor: sl(),
        sharedPreferences: sl(),
      ));

  // Repository
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ExampleRepo(dioClient: sl()));

  // Providers
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => ExampleProvider(exampleRepo: sl()));

  sharedPreferences.setBool(AppConstants.push, true);
}
