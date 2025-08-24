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

  @override
  Future<ApiResponse> submitSalesActivities(
      List<String> activities, String clientId) async {
    try {
      response = await dioClient.post(BaseUrls.employeeSubmitReport,
          data: {'actions': activities, 'client_id': clientId});
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> submitTMRActivities(
      List<String> images, String clientId, String note) async {
    try {
      FormData formData = FormData.fromMap({
        'client_id': clientId,
        'note': note,
      });

      // Add images as individual form fields with array notation
      for (int i = 0; i < images.length; i++) {
        String imagePath = images[i];
        String filename = imagePath.split('/').last;
        MultipartFile file =
            await MultipartFile.fromFile(imagePath, filename: filename);
        formData.files.add(MapEntry('images[$i]', file));
      }

      response =
          await dioClient.post(BaseUrls.employeeSubmitReport, data: formData);
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> startVisit(
      double latitude, double longitude, String clientId) async {
    try {
      response = await dioClient.post('${BaseUrls.client}/$clientId', data: {
        'latitude': latitude,
        'longitude': longitude,
        'client_id': clientId,
      });
      return ApiResponse.withSuccess(response!);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
