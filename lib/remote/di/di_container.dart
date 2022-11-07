import 'package:app/remote/constants/app_constants.dart';
import 'package:app/remote/constants/config_model.dart';
import 'package:app/remote/dio/dio_client.dart';
import 'package:app/remote/dio/logging_interceptor.dart';
import 'package:app/remote/providers/auth_provider.dart';
import 'package:app/remote/repositories/auth_repository.dart';

import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(BaseUrls.productionAPi, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository

  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));

  // Providers
  sl.registerFactory(() => AuthProvider(authRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());

  sharedPreferences.setBool(AppConstants.push, true);
}
