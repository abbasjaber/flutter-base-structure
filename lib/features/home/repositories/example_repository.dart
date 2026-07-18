import 'package:app/core/network/dio_client.dart';
import 'package:app/core/network/api_error_handler.dart';
import 'package:app/core/interfaces/repo_interface.dart';
import 'package:app/core/network/api_response.dart';

import 'package:dio/dio.dart';

class ExampleRepo extends RepoAbstract {
  final DioClient dioClient;

  ExampleRepo({required this.dioClient});
  
  @override
  Future<ApiResponse> get() async {
    try {
      Response response = await dioClient.get("");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
