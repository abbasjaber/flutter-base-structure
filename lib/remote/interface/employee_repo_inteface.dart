import 'package:app/remote/response/api_response.dart';

abstract class EmployeeRepoInterface {
  Future<ApiResponse> getClients();
  Future<ApiResponse> getHistory();
  Future<ApiResponse> submitSalesActivities(
      List<String> activities, String clientId);
  Future<ApiResponse> submitTMRActivities(
      List<String> images, String clientId, String note);
  Future<ApiResponse> startVisit(
      double latitude, double longitude, String clientId);
}
