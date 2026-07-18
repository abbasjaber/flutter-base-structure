import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/network/dio_client.dart';
import 'package:app/core/network/api_error_handler.dart';
import 'package:app/core/interfaces/repo_interface.dart';
import 'package:app/features/auth/models/user_model.dart';
import 'package:app/core/network/api_response.dart';
import 'package:app/core/constants/config_model.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo extends RepoAbstract {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});
  
  @override
  Future<ApiResponse> get() async {
    throw UnimplementedError();
  }

  Future<ApiResponse> login(UserModel c) async {
    try {
      // DioClient already sets baseUrl from config, so just pass the endpoint path.
      Response response = await dioClient.post(
        BaseUrls.login,
        data: c.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<void> saveUserToken(String token) async {
    // We only need to save it to SharedPreferences.
    // The AuthInterceptor will automatically pick it up for future requests.
    try {
      await sharedPreferences.setString(AppConstants.token, token);
    } catch (e) {
      rethrow;
    }
  }

  bool isLogin() {
    return sharedPreferences.getString(AppConstants.token) != null;
  }

  bool logout() {
    sharedPreferences.remove(AppConstants.token);
    return sharedPreferences.getString(AppConstants.token) == null;
  }

  Future<ApiResponse> register(UserModel c) async {
    try {
      Response response = await dioClient.post(
        BaseUrls.register,
        data: c.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
