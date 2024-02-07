import 'package:app/remote/dio/dio_client.dart';
import 'package:app/remote/exception/api_error_handler.dart';
import 'package:app/remote/interface/repo_inteface.dart';
import 'package:app/remote/response/api_response.dart';

import 'package:dio/dio.dart';

class ExamoleRepo extends RepoAbstract {
  final DioClient dioClient;
  Response? response;
  ExamoleRepo({required this.dioClient});
  @override
  Future<ApiResponse> get() async {
    try {
      response =
          await dioClient.get("http://depotlink.co/jsontest/itemstree.json");
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
