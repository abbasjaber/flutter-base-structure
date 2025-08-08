import 'package:app/remote/constants/config_model.dart';
import 'package:app/remote/dio/dio_client.dart';
import 'package:app/remote/exception/api_error_handler.dart';
import 'package:app/remote/interface/employee_repo_inteface.dart';
import 'package:app/remote/response/api_response.dart';

import 'package:dio/dio.dart';

class EmployeeRepo extends EmployeeRepoInterface {
  final DioClient dioClient;
  Response? response;
  EmployeeRepo({required this.dioClient});
  @override
  Future<ApiResponse> getClients() async {
    try {
      response = await dioClient.get(BaseUrls.employeeClients);
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getHistory() async {
    try {
      response = await dioClient.get(BaseUrls.employeeHistory);
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
